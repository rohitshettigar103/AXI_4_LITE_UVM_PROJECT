`include "axi_defines.svh"
interface axi_interface(input logic aclk, input logic aresetn);

	logic [`AW-1:0] awaddr;
	logic [2:0] awprot;
	logic awvalid;
	logic awready;

	logic [`DW-1:0] wdata;
	logic [`SW-1:0] wstrb;
	logic wvalid;
	logic wready;

	logic [1:0] bresp;
	logic bvalid;
	logic bready;

	logic [`AW-1:0] araddr;
	logic [2:0] arprot;
	logic arvalid;
	logic arready;

	logic [`DW-1:0] rdata;
	logic [1:0] rresp;
	logic rvalid;
	logic rready;


	clocking drv_clk @(posedge aclk);
		output awaddr;
		output awprot;
		output awvalid;
		output wdata;
		output wstrb;
		output wvalid;
		output bready;
		output araddr;
		output arprot;
		output arvalid;
		output rready;
		input awready;
		input wready;
		input bresp,bvalid;
		input arready;
		input rdata,rresp,rvalid;
	endclocking
	
	clocking mon_clk @(posedge aclk);
		input awaddr;
		input awprot;
		input awvalid;
		input wdata;
		input wstrb;
		input wvalid;
		input bready;
		input araddr;
		input arprot;
		input arvalid;
		input rready;
		input awready;
		input wready;
		input bresp,bvalid;
		input arready;
		input rdata,rresp,rvalid;
	endclocking

	modport DRV (clocking drv_clk,input aresetn);
	modport MON (clocking mon_clk,input aresetn);
endinterface

	

	

