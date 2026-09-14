class axi_driver extends uvm_driver#(axi_transaction);
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
		wait(vif.aresetn==1'b0);
		wait(vif.aresetn==1'b1);

		@(vif.drv_clk);
		fork
			write_sig();
			read_sig();
		join_none
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
			seq_item_port.get_next_item(tr);
			read_opr(tr);
			seq_item_port.item_done();
		end
	endtask

	task rst_sig();
		vif.drv_clk.awaddr<=0;
		vif.drv_clk.awprot<=0;
		vif.drv_clk.awvqlid<=0;
		vif.drv_clk.wdata<=0;
		vif.drv_clk.wstrb<=0;
		vif.drv_clk.wvalid<=0;
		vif.drv_clk.araddr<=0;
		vif.drv_clk.arprot<=0;
		vif.drv_clk.arvalid<=0;
	endtask


	task write(axi_transaction tr);
		fork
			begin
				vif.drv_clk.awaddr<=tr.awaddr;
				vif.drv_clk.awprot<=tr.awprot;
				vif.drv_clk.awvalid<=1'b1;

				do
					@(vif.drv_clk);
				while(!vif.drv_clk.awready);
				vif.drv_clk.awvalid <=1'b0;
			end
			begin
				vif.drv_clk.wdata<=tr.wdata;
				vif.drv_clk.wstrb<=tr.wsatrb;
				vif.drv_clk.wvalid<=1'b1;
				do
					@(vif.drv_clk);
				while(!vif.drv_clk.wready);
				vif.drv_clk.wvalid<=1'b0;
			end
		join
		`uvm_info("DRIVER",$sformatf("WRITE OPERATION INPUTS:%s",tr.convert2string()),UVM_LOW)
	endtask

	task read(axi_transaction tr);
		vif.drv_clk.araadr<=tr.araddr;
		vif.drv_clk.arprot<=tr.arprot;
		vif.drv_clk.arvalid<=1'b1;
		do
			@(vif.drv_clk);
		while(!vif.drv_clk.arready);
		vif.drv_clk.arvalid<=0;
		`uvm_info("DRIVER",$sformatf("READ OPERATION INPUTS:%s",tr.convert2string()),UVM_LOW)
	endtask
endclass






	
	












