// Writes to the Read-Only region (40-48) - expect SLVERR,
class axi_write_ro_seq extends uvm_sequence #(axi_transaction);
        `uvm_object_utils(axi_write_ro_seq)

        function new(string name="axi_write_ro_seq"); 
		super.new(name); 
	endfunction

        task body();
                axi_transaction tr;
                repeat(10) begin
                        tr=axi_transaction::type_id::create("tr");
                        start_item(tr);
                        if(!tr.randomize() with {
                                read_write==0; 
				awvalid==1; 
				wvalid==1; 
				bready==1;
                                awaddr inside {40,44,48};
                        })
                                `uvm_error("WR_RO_SEQ","randomization failed")
                        finish_item(tr);
                end
        endtask
endclass
