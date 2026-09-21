class axi_base_test extends uvm_test;
	`uvm_component_utils(axi_base_test)

	axi_env env;

	function new(string name="axi_base_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = axi_env::type_id::create("env", this);
	endfunction

	task run_phase(uvm_phase phase);
		axi_write wr_seq;
		axi_read  rd_seq;

		phase.raise_objection(this);

		wr_seq = axi_write::type_id::create("wr_seq");
		rd_seq = axi_read::type_id::create("rd_seq");

		fork 
			wr_seq.start(env.active_agt.write_sqr);
			rd_seq.start(env.active_agt.read_sqr);
		join

		phase.drop_objection(this);
	endtask

endclass

