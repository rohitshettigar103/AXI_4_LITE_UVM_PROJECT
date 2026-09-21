`include "axi_defines.svh"
`include "uvm_macros.svh"
`timescale 1ns/1ns
import uvm_pkg::*;
import axi_pkg::*;

module top;

	logic aclk;
	logic aresetn;

	
	initial aclk = 0;
	always #5 aclk = ~aclk;   

	// reset generation
	initial begin
		aresetn = 0;
		#10;
		aresetn=1;
	

	end

	axi_interface intf(.aclk(aclk), .aresetn(aresetn));
	axi4_lite_slave #(
		.DATA_WIDTH   (`DW),
		.ADDR_WIDTH   (`AW),
		.MEM_DEPTH    (`MEM),
		.DEFAULT_PROT (3'b000)
	) dut (
		.ACLK    (aclk),
		.ARESETn (aresetn),

		.AWADDR  (intf.awaddr),
		.AWPROT  (intf.awprot),
		.AWVALID (intf.awvalid),
		.AWREADY (intf.awready),

		.WDATA   (intf.wdata),
		.WSTRB   (intf.wstrb),
		.WVALID  (intf.wvalid),
		.WREADY  (intf.wready),

		.BRESP   (intf.bresp),
		.BVALID  (intf.bvalid),
		.BREADY  (intf.bready),

		.ARADDR  (intf.araddr),
		.ARPROT  (intf.arprot),
		.ARVALID (intf.arvalid),
		.ARREADY (intf.arready),

		.RDATA   (intf.rdata),
		.RRESP   (intf.rresp),
		.RVALID  (intf.rvalid),
		.RREADY  (intf.rready)
	);

	initial begin
		uvm_config_db#(virtual axi_interface)::set(null, "*", "vif", intf);
		run_test();
	end

endmodule
