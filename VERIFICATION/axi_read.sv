class axi_read extends uvm_sequence(#axi_transaction);
	`uvm_object_utils(axi_read)

	function new(string name="axi_read");
		super.new(name);
	endfunction

	task body();
		axi_transaction tr;
		repeat(10)
		begin
			tr=axi_transaction::type_id::create("tr");
			strat_item(tr);
			if(!tr.randomize()) with {
				read_write==1;
				arvalid == 1;
				rready ==1;
			})
			`uvm_error("READ_SEQ","randomization failed")

			`uvm_info("READ_SEQ",tr.convert2string(),UVM_LOW)
			finish_utem(tr);
		end
	endtask
endclass


