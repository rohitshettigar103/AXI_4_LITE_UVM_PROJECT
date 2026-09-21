/*`include "uvm_macros.svh"

package axi_pkg;
	import uvm_pkg::*;

	`include "axi_transaction.sv"
	`include "axi_sequencer.sv"
	`include "axi_write.sv"
	`include "axi_read.sv"
	`include "axi_driver.sv"
	`include "axi_input_monitor.sv"
	`include "axi_output_monitor.sv"
	`include "axi_active_agent.sv"
	`include "axi_passive_agent.sv"
	`include "axi_scoreboard.sv"
	`include "axi_env.sv"
	`include "axi_test.sv"

endpackage
*/
`include "uvm_macros.svh"

package axi_pkg;
        import uvm_pkg::*;

        `include "axi_transaction.sv"
        `include "axi_sequencer.sv"
        `include "axi_write.sv"
        `include "axi_read.sv"
        `include "axi_write_ro_seq.sv"
        `include "axi_write_wo_seq.sv"
        `include "axi_write_unaligned_seq.sv"
        `include "axi_write_decerr_seq.sv"
        `include "axi_read_wo_seq.sv"
        `include "axi_read_ro_seq.sv"
        `include "axi_read_unaligned_seq.sv"
        `include "axi_read_decerr_seq.sv"
	`include "axi_write_strb.sv"
	`include "axi_write_addr.sv"
	`include "axi_read_addr.sv"
        `include "axi_driver.sv"
        `include "axi_input_monitor.sv"
        `include "axi_output_monitor.sv"
        `include "axi_active_agent.sv"
        `include "axi_passive_agent.sv"
        `include "axi_scoreboard.sv"
        `include "axi_subscriber.sv"
        `include "axi_env.sv"
        //`include "axi_test.sv"
	`include "axi_regression_test.sv"

endpackage
