/*
class axi_env extends uvm_env;
	`uvm_component_utils(axi_env)
	axi_active_agent active_agt;
	axi_passive_agent passive_agt;
	axi_scoreboard scr;
	function new(string name="axi_env",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(uvm_active_passive_enum)::set(this, "active_agt",  "is_active", UVM_ACTIVE);
		uvm_config_db#(uvm_active_passive_enum)::set(this, "passive_agt", "is_passive", UVM_PASSIVE);
		active_agt =axi_active_agent::type_id::create("active_agt", this);
		passive_agt=axi_passive_agent::type_id::create("passive_agt", this);

		scr= axi_scoreboard::type_id::create("scr", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		active_agt.in_mon.write_req_ap.connect(scr.write_req_imp);
		active_agt.in_mon.read_req_ap.connect(scr.read_req_imp);
		passive_agt.out_mon.write_resp_ap.connect(scr.write_resp_imp);
		passive_agt.out_mon.read_resp_ap.connect(scr.read_resp_imp);
		endfunction
endclass

*/
class axi_env extends uvm_env;
        `uvm_component_utils(axi_env)
        axi_active_agent active_agt;
        axi_passive_agent passive_agt;
        axi_scoreboard scr;
	axi_req_coverage req_cov;
        function new(string name="axi_env",uvm_component parent);
                super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                uvm_config_db#(uvm_active_passive_enum)::set(this, "active_agt",  "is_active", UVM_ACTIVE);
                uvm_config_db#(uvm_active_passive_enum)::set(this, "passive_agt", "is_active", UVM_PASSIVE);
                active_agt =axi_active_agent::type_id::create("active_agt", this);
                passive_agt=axi_passive_agent::type_id::create("passive_agt", this);

                scr= axi_scoreboard::type_id::create("scr", this);
		req_cov  = axi_req_coverage::type_id::create("req_cov", this);
        endfunction

        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                active_agt.in_mon.write_req_ap.connect(scr.in_wrt_fifo.analysis_export);
                active_agt.in_mon.read_req_ap.connect(scr.in_rd_fifo.analysis_export);
                passive_agt.out_mon.write_resp_ap.connect(scr.out_wrt_fifo.analysis_export);
                passive_agt.out_mon.read_resp_ap.connect(scr.out_rd_fifo.analysis_export);
		active_agt.in_mon.write_req_ap.connect(req_cov.analysis_export);
		active_agt.in_mon.read_req_ap.connect(req_cov.analysis_export);
                endfunction
endclass
