class axi_active_agent extends uvm_agent;
	`uvm_component_utils(axi_active_agent)

	axi_sequencer write_sqr;
	axi_sequencer read_sqr;
	axi_driver drv;
	axi_input_monitor in_mon;

	function new(string name="axi_active_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active);
		if(get_is_active==UVM_ACTIVE)
		begin
			write_sqr=axi_sequencer::type_id::create("write_sqr", this);
			read_sqr=axi_sequencer::type_id::create("read_sqr", this);
			drv=axi_driver::type_id::create("drv", this);
		end
		in_mon=axi_input_monitor::type_id::create("in_mon", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(get_is_active==UVM_ACTIVE());
		begin
			drv.seq_item_port.connect(write_sqr.seq_item_export);
			drv.rd_seq_item_port.connect(read_sqr.seq_item_export);
		end
	endfunction
endclass
