
class axi_driver extends uvm_driver #(axi_transaction);

	`uvm_component_utils(axi_driver)

	virtual axi_interface vif;

	uvm_seq_item_pull_port#(axi_transaction) rd_seq_item_port;

	function new(string name="axi_driver",uvm_component parent);
		super.new(name,parent);
		rd_seq_item_port=new("rd_seq_item_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual axi_interface)::get(this,"","vif",vif))
			`uvm_fatal("VIF","virtual interface failed")
	endfunction

	task run_phase(uvm_phase phase);
		rst_sig();
		wait(vif.aresetn==1'b1);

		@(vif.drv_clk);
		fork
			write_sig();
			read_sig();
		join
	endtask

	task write_sig();
		axi_transaction tr;
		forever begin
			seq_item_port.get_next_item(tr);
			write_opr(tr);
			seq_item_port.item_done();
		end
	endtask
	
	task read_sig();
		axi_transaction tr;
		forever begin
			rd_seq_item_port.get_next_item(tr);
			read_opr(tr);
			rd_seq_item_port.item_done();
		end
	endtask

	task rst_sig();
		vif.drv_clk.awaddr<=0;
		vif.drv_clk.awprot<=0;
		vif.drv_clk.awvalid<=0;
		vif.drv_clk.bready<= 0;
		vif.drv_clk.rready<= 0;
		vif.drv_clk.wdata<=0;
		vif.drv_clk.wstrb<=0;
		vif.drv_clk.wvalid<=0;
		vif.drv_clk.araddr<=0;
		vif.drv_clk.arprot<=0;
		vif.drv_clk.arvalid<=0;
	endtask


	task write_opr(axi_transaction tr);
		fork
			begin
				vif.drv_clk.awaddr<=tr.awaddr;
				vif.drv_clk.awprot<=tr.awprot;
#15;
				vif.drv_clk.awvalid<=1'b1;

				do
					@(vif.drv_clk);
				while(!vif.drv_clk.awready);
				vif.drv_clk.awvalid <=1'b0;
			end
			begin
				vif.drv_clk.wdata<=tr.wdata;
				vif.drv_clk.wstrb<=tr.wstrb;
				vif.drv_clk.wvalid<=1'b1;
			//	`uvm_info("DRIVER",$sformatf("WRITE OPERATION INPUTS:%s",tr.convert2string()),UVM_LOW)
				do
					@(vif.drv_clk);
				while(!vif.drv_clk.wready);
				vif.drv_clk.wvalid<=1'b0;
			end
		join

		vif.drv_clk.bready<=1'b1;
		do
			@(vif.drv_clk);
		while(!vif.drv_clk.bvalid);
		vif.drv_clk.bready<=0;

	endtask


	task read_opr(axi_transaction tr);
		vif.drv_clk.araddr<=tr.araddr;
		vif.drv_clk.arprot<=tr.arprot;
		vif.drv_clk.arvalid<=1'b1;
		vif.drv_clk.rready<=1;

		//`uvm_info("DRIVER",$sformatf("READ OPERATION INPUTS:%s",tr.convert2string()),UVM_LOW)
		do
			@(vif.drv_clk);
		while(!vif.drv_clk.arready);
		vif.drv_clk.arvalid<=0;

		vif.drv_clk.rready<=1;
		do
			@(vif.drv_clk);
		while(!vif.drv_clk.rvalid);
		vif.drv_clk.rready<=1'b0;

	endtask
endclass

/*

class axi_driver extends uvm_driver #(axi_transaction);
        `uvm_component_utils(axi_driver)

        virtual axi_interface vif;

        uvm_seq_item_pull_port#(axi_transaction) rd_seq_item_port;

        bit addr_done, data_done, rd_addr_done;
        axi_transaction write, read;

        function new(string name="axi_driver",uvm_component parent);
                super.new(name,parent);
                rd_seq_item_port=new("rd_seq_item_port",this);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(virtual axi_interface)::get(this,"","vif",vif))
                        `uvm_fatal("VIF","virtual interface failed")
        endfunction

        task run_phase(uvm_phase phase);
                rst_sig();
                wait(vif.aresetn==1'b0);
                wait(vif.aresetn==1'b1);
                @(vif.drv_clk);

                `uvm_info("DRIVER","DRIVER RUN PHASE STARTED",UVM_LOW)
                fork
                        forever
                        begin
                                seq_item_port.get_next_item(write);
                                wrt_drive(write);
                                seq_item_port.item_done();
                        end
                        forever
                        begin
                                rd_seq_item_port.get_next_item(read);
                                rd_drive(read);
                                rd_seq_item_port.item_done();
                        end
                join
        endtask

        task rst_sig();
                vif.drv_clk.awaddr<=0;
                vif.drv_clk.awprot<=0;
                vif.drv_clk.awvalid<=0;
                vif.drv_clk.bready<=0;
                vif.drv_clk.rready<=0;
                vif.drv_clk.wdata<=0;
                vif.drv_clk.wstrb<=0;
                vif.drv_clk.wvalid<=0;
                vif.drv_clk.araddr<=0;
                vif.drv_clk.arprot<=0;
                vif.drv_clk.arvalid<=0;
        endtask

        task wrt_drive(axi_transaction t);
                @(vif.drv_clk);
                vif.drv_clk.awaddr<=t.awaddr;
                vif.drv_clk.awprot<=t.awprot;
                vif.drv_clk.awvalid<=t.awvalid;

                vif.drv_clk.wdata<=t.wdata;
                vif.drv_clk.wstrb<=t.wstrb;
                vif.drv_clk.wvalid<=t.wvalid;

                vif.drv_clk.bready<=t.bready;

                fork
                        wrt_addr(t);
                        wrt_data(t);
                join

                if(data_done && addr_done)
                        wrt_resp(t);
        endtask

        task wrt_addr(axi_transaction t);
                if(t.awvalid && addr_done==0)
                begin
                        @(vif.drv_clk iff vif.drv_clk.awready);
                        addr_done=1;
                        `uvm_info("DRIVER", $sformatf("write addr awaddr=%0h awvalid=%0b at time %0t",
                                t.awaddr,t.awvalid,$time), UVM_LOW)
                end
        endtask

        task wrt_data(axi_transaction t);
                if(t.wvalid && data_done==0)
                begin
                        @(vif.drv_clk iff vif.drv_clk.wready);
                        data_done=1;
                        `uvm_info("DRIVER", $sformatf("write data wdata=%0h wstrb=%0b wvalid=%0b at time %0t",
                                t.wdata,t.wstrb,t.wvalid,$time), UVM_LOW)
                end
        endtask

        task wrt_resp(axi_transaction t);
                if(t.bready)
                begin
                        @(vif.drv_clk iff vif.drv_clk.bvalid);
                        `uvm_info("DRIVER", $sformatf("write response handshake done at time %0t",$time), UVM_LOW)
                        addr_done=0;
                        data_done=0;
                end
        endtask

        task rd_drive(axi_transaction r);
                @(vif.drv_clk);
                vif.drv_clk.araddr<=r.araddr;
                vif.drv_clk.arprot<=r.arprot;
                vif.drv_clk.arvalid<=r.arvalid;

                vif.drv_clk.rready<=r.rready;

                rd_addr(r);
                rd_data(r);
        endtask

        task rd_addr(axi_transaction r);
                if(r.arvalid && rd_addr_done==0)
                begin
                        @(vif.drv_clk iff vif.drv_clk.arready);
                        rd_addr_done=1;
                        `uvm_info("DRIVER", $sformatf("read araddr=%0h arvalid=%0b at time %0t",
                                r.araddr,r.arvalid,$time), UVM_LOW)
                end
        endtask

        task rd_data(axi_transaction r);
                if(r.rready && rd_addr_done==1)
                begin
                        @(vif.drv_clk iff vif.drv_clk.rvalid);
                        rd_addr_done=0;
                end
        endtask
endclass


*/
	
	












