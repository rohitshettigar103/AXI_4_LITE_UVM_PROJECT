class axi_passive_agent extends uvm_agent;
	`uvm_component_utils(axi_passive_agent)

	axi_output_monitor out_mon;

	function new(string name="axi_passive_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active);
		super.build_phase(phase);
		out_mon=axi_output_monitor::type_id::create("out_mon",this);
	endfunction
endclass
