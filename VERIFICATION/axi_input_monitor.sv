class axi_input_monitor extends uvm_monitor;
	`uvm_component_utils(axi_input_monitor)


	virtual axi_interface vif;

	uvm_analysis_port#(axi_transaction) write_req_ap;
	uvm_analysis_port#(axi_transaction) read_req_ap;

	function new(string name="axi_input_monitor",uvm_component parent);
		super.new(name,parent);
		write_req_ap=new("write_req_ap",this);
		read_req_ap=new("read_req_ap",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual axi_interface)::get(this, "", "vif", vif))
			`uvm_fatal("VIF", "no virtual interface")
	endfunction

	task run_phase(uvm_phase phase);
		fork
			write_capture();
			read_capture();
		join
	endtask

	task write_capture();
		bit [`AW-1:0]awaddr_c;
		bit [2:0] awprot_c;
		bit [`DW-1:0] wdata_c;
		bit [`SW-1:0] wstrb_c;

		axi_transaction tr;

		forever begin
			fork
				begin
					@(vif.mon_clk iff(vif.mon_clk.awvalid && vif.mon_clk.awready));
					awaddr_c = vif.mon_clk.awaddr;
					awprot_c = vif.mon_clk.awprot;
				end
				begin
					@(vif.mon_clk iff(vif.mon_clk.wvalid && vif.mon_clk.wready));
					wdata_c = vif.mon_clk.wdata;
					wstrb_c = vif.mon_clk.wstrb;
				end
			join

			tr=axi_transaction::type_id::create("tr",this);
			tr.read_write=0;
			tr.awaddr=awaddr_c;
			tr.awprot=awprot_c;
			tr.wdata=wdata_c;
			tr.wstrb=wstrb_c;

			 `uvm_info("INPUT_MON", $sformatf("INPUT MONITOR WRITE: %s", t.convert2string()), UVM_LOW)

			write_req_ap.write(tr);
		end
	endtask

	task read_capture();
		axi_transaction tr;
		forever begin
			@(vif.mon_clk iff (vif.mon_clk.arvalid && vif.mon_clk.arready));
			tr=axi_transaction::type_id::create("tr");
			tr.read_write=1;
			tr.araddr=vif.mon_clk.araddr;
			tr.arprot=vif.mon_clk.arprot;
			`uvm_info("INPUT_MON", $sformatf("INPUT MONITOR READ: %s", t.convert2string()), UVM_LOW)

			read_req_ap.write(tr);
		end
	endtask
endclass


					

