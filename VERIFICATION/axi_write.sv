class axi_write extends uvm_sequence #(axi_transaction);
	`uvm_object_utils(axi_write)

	function new(string name="axi_write");
		super.new(name);
	endfunction

	task body();
		axi_transaction tr;
		repeat(10)
		begin
			tr=axi_transaction::type_id::create("tr");
			start_item(tr);
			if(!tr.randomize() with {
				read_write==0;
				awvalid == 1;
				//awaddr inside {[32'h34:32'h38]};
				awaddr inside {[4:7]};
				wvalid == 1;
				bready ==1;
			})
			`uvm_error("WRITE_SEQ","randomization failed")

			//`uvm_info("WRITE_SEQ",tr.convert2string(),UVM_LOW)
			finish_item(tr);
		end
	endtask
endclass


