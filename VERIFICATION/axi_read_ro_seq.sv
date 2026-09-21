// Reads from the Read-Only region (40-48) - legal, expect OKAY.
class axi_read_ro_seq extends uvm_sequence #(axi_transaction);
        `uvm_object_utils(axi_read_ro_seq)
        
        function new(string name="axi_read_ro_seq"); 
		super.new(name); 
	endfunction
        task body();
                axi_transaction tr;
                repeat(10) begin
                        tr=axi_transaction::type_id::create("tr");
                        start_item(tr);
                        if(!tr.randomize() with {
                                read_write==1;
				arvalid==1;
				rready==1;
                                araddr inside {40,44,48};
                        })
                                `uvm_error("RD_RO_SEQ","randomization failed")
                        finish_item(tr);
                end
        endtask
endclass
