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
			@(vif.mon_clk iff(vif.mon_clk.bvalid && vif.mon_clk.bready));
			tr=axi_transaction::type_id::create("write_resp");
			tr.read_write=0;
			tr.bresp=vif.mon_clk.bresp;
			  `uvm_info("OUTPUT_MON", $sformatf("Write response: bresp=%0d", t.bresp), UVM_LOW)
			write_resp_ap.write(tr);
		end
	endtask

	task read_resp();
		axi_transaction tr;
		forever begin
			@(vif.mon_clk iff(vif.mon_clk.rvalid && vif.mon_clk.rready));
			tr=axi_transaction::type_id::create("read_resp");
			tr.read_write=1;
			tr.rdata=vif.mon_clk.rdata;
			tr.rresp=vif.mon_clk.rresp;

			`uvm_info("OUTPUT_MON", $sformatf("Read response: rdata=0x%0h rresp=%0d", t.rdata, t.rresp), UVM_LOW)
			read_resp_ap.write(tr);
		end
	endtask
endclass
			

