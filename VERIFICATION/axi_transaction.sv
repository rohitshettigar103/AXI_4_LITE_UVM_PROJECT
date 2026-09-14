`include "uvm_macros.svh"
import uvm_pkg::*;
class axi_transaction extends uvm_sequence_item;

	rand bit [`AW-1:0] awaddr;
	rand bit [2:0] awprot;
	rand bit awvalid;
	bit awready;

	rand bit [`DW-1:0] wdata;
	rand bit [`SW-1:0] wstrb;
	rand bit wvalid;
	bit wready;

	rand bit bready;
	bit [1:0] bresp;
	bit bvalid;

	rand bit [`AW-1:0] araddr;
	rand bit [2:0] arprot;
	rand bit arvalid;
	bit arready;

	rand bit rready;
	bit [`DW-1:0] rdata;
	bit [1:0] rresp;
	bit rvalid;

	rand bit read_write;


	`uvm_object_utils_begin(axi_transaction)
	`uvm_field_int(awaddr,UVM_ALL_ON)
	`uvm_field_int(awprot,UVM_ALL_ON)
	`uvm_field_int(awvalid,UVM_ALL_ON)
	`uvm_field_int(awready,UVM_ALL_ON)
	`uvm_field_int(wdata,UVM_ALL_ON)
	`uvm_field_int(wstrb,UVM_ALL_ON)
	`uvm_field_int(wvalid,UVM_ALL_ON)
	`uvm_field_int(wready,UVM_ALL_ON)
	`uvm_field_int(bready,UVM_ALL_ON)
	`uvm_field_int(bresp,UVM_ALL_ON)
	`uvm_field_int(bvalid,UVM_ALL_ON)
	`uvm_field_int(araddr,UVM_ALL_ON)
	`uvm_field_int(arprot,UVM_ALL_ON)
	`uvm_field_int(arvalid,UVM_ALL_ON)
	`uvm_field_int(arready,UVM_ALL_ON)
	`uvm_field_int(rready,UVM_ALL_ON)
	`uvm_field_int(rdata,UVM_ALL_ON)
	`uvm_field_int(rresp,UVM_ALL_ON)
	`uvm_field_int(rvalid,UVM_ALL_ON)
	`uvm_field_int(read_write,UVM_ALL_ON)
	`uvm_object_utils_end


	function new(string name="axi_transaction");
		super.new(name);
	endfunction

	constraint c1{
		awaddr[1:0]==2'b00;
	}
	constraint c2{
		araddr[1:0]==2'b00;
	}
	constraint c3{
		awaddr inside {[32'h00:32'h3C]};
	}
	constraint c4{
		araddr inside {[32'h00:32'h3C]};
	}


	function string convert2string();
		if(read_write==0)
			return $sformatf("WRITE::::::::awaddr=%0h,awprot=%0h,awvalid=%0h,awready=%0h,wdata=%0h,wstrb=%0h,wvalid=%0h,wready=%0h,bresp=%0d,bva				lid=%0b,bready=%0b",awaddr,awprot,awvalid,awready,wdata,wstrb,wvalid,wready,bresp,bvalid,bready);
		else
			return $sformatf("READ:::::::::araddr=%0h,arprot=%0h,arvalid=%0b,arready=%0b,rdata=%0h,rreasp=%0d,rvalid=%0b,rready=%0b",araddr,
				arprot,arvalid,arready,rdata,rresp,rvalid,rready);
	endfunction
endclass




