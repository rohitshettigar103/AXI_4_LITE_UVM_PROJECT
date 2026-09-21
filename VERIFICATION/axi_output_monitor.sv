
class axi_output_monitor extends uvm_monitor;
	`uvm_component_utils(axi_output_monitor)

	virtual axi_interface vif;

	uvm_analysis_port#(axi_transaction) write_resp_ap;
	uvm_analysis_port#(axi_transaction) read_resp_ap;
	

	function new(string name="axi_output_monitor",uvm_component parent);
		super.new(name,parent);
		write_resp_ap=new("write_resp_ap",this);
		read_resp_ap=new("read_resp_ap",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		 if (!uvm_config_db#(virtual axi_interface)::get(this, "", "vif", vif))
			 `uvm_fatal("NOVIF", "no virtual interface")
	endfunction



	task run_phase(uvm_phase phase);
		fork
			write_resp();
			read_resp();
		join
	endtask

	task write_resp();
		axi_transaction tr;
		forever begin
		//	if(vif.mon_clk.bvalid!=1 && vif.mon_clk.bready!=1) 
			@(vif.mon_clk iff (vif.mon_clk.bvalid && vif.mon_clk.bready));
		//	begin
			tr=axi_transaction::type_id::create("write_resp");
			tr.read_write=0;
			tr.bresp=vif.mon_clk.bresp;
			
			`uvm_info("OUPUT_MON", $sformatf("OUTPUT MONITOR WRITE: %s", tr.convert2string()), UVM_LOW)
			//`uvm_info("OUTPUT_MON", $sformatf("Write response: bresp=%0d", tr.bresp), UVM_LOW)
			write_resp_ap.write(tr);

		end
	endtask

	task read_resp();
		axi_transaction tr;
		forever begin
		//	if(vif.mon_clk.rvalid!=1 && vif.mon_clk.rready!=1)
			@(vif.mon_clk iff (vif.mon_clk.rvalid && vif.mon_clk.rready));
//			begin
			tr=axi_transaction::type_id::create("read_resp");
			tr.read_write=1;
			tr.rdata=vif.mon_clk.rdata;
			tr.rresp=vif.mon_clk.rresp;
			//`uvm_info("OUTPUT_MON", $sformatf("OUTPUT MONITOR read: %s", tr.convert2string()), UVM_LOW)

			`uvm_info("OUTPUT_MON", $sformatf("Read response: rdata=0x%0d rresp=%0d", vif.mon_clk.rdata, vif.mon_clk.rresp), UVM_LOW)
			read_resp_ap.write(tr);
			//end

		end
	endtask
endclass
/*
			
class axi_output_monitor extends uvm_monitor;
        `uvm_component_utils(axi_output_monitor)

        virtual axi_interface vif;
        uvm_analysis_port#(axi_transaction) write_resp_ap;
        uvm_analysis_port#(axi_transaction) read_resp_ap;
        axi_transaction write_resp_tr, read_resp_tr;

        function new(string name="axi_output_monitor", uvm_component parent);
                super.new(name,parent);
                write_resp_ap=new("write_resp_ap",this);
                read_resp_ap=new("read_resp_ap",this);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(virtual axi_interface)::get(this,"","vif",vif))
                        `uvm_fatal("NOVIF","config db not set for output monitor")
        endfunction

        task run_phase(uvm_phase phase);
                forever
                begin
                        @(vif.mon_clk);
                        if((vif.mon_clk.bready) && vif.mon_clk.rready)
                        begin
                                fork
                                        capture_bresp();
                                        capture_rdata();
                                join
                        end
                        else if(vif.mon_clk.bready && !vif.mon_clk.rready)
                        begin
                                capture_bresp();
                        end
                        else if(!vif.mon_clk.bready && vif.mon_clk.rready)
                        begin
                                capture_rdata();
                        end
                end
        endtask

        task capture_bresp();
                if(vif.mon_clk.bready)
                begin
                        write_resp_tr=axi_transaction::type_id::create("write_resp_tr");
                        //`uvm_info("OUTPUT_MON", $sformatf("WAITING FOR BVALID at time %0t", $time), UVM_LOW)
                        @(vif.mon_clk iff vif.mon_clk.bvalid);
                        //`uvm_info("OUTPUT_MON", $sformatf("GOT BVALID at time %0t", $time), UVM_LOW)
                        write_resp_tr.bvalid=vif.mon_clk.bvalid;
                        write_resp_tr.bresp=vif.mon_clk.bresp;
                        write_resp_ap.write(write_resp_tr);
                        //`uvm_info("OUTPUT_MON", $sformatf("WRITE RESP BRESP=%0b BVALID=%0b at time %0t", write_resp_tr.bresp, write_resp_tr.bvalid, $time), UVM_LOW)
                end
        endtask

        task capture_rdata();
                if(vif.mon_clk.rready)
                begin
                        read_resp_tr=axi_transaction::type_id::create("read_resp_tr");
                        //`uvm_info("OUTPUT_MON", $sformatf("WAITING FOR RVALID at time %0t", $time), UVM_LOW)
                        @(vif.mon_clk iff vif.mon_clk.rvalid);
                        //`uvm_info("OUTPUT_MON", $sformatf("GOT RVALID at time %0t", $time), UVM_LOW)
                        read_resp_tr.rvalid=vif.mon_clk.rvalid;
                        read_resp_tr.rdata=vif.mon_clk.rdata;
                        read_resp_tr.rresp=vif.mon_clk.rresp;
                        read_resp_ap.write(read_resp_tr);
                        //`uvm_info("OUTPUT_MON", $sformatf("READ RESP RDATA=%0h RRESP=%0b RVALID=%0b at time %0t",read_resp_tr.rdata, read_resp_tr.rresp, read_resp_tr.rvalid, $time), UVM_LOW)
                end
        endtask
endclass
*/
