// Reads from a non-word-aligned address - expect SLVERR.
class axi_read_unaligned_seq extends uvm_sequence #(axi_transaction);
        `uvm_object_utils(axi_read_unaligned_seq)
        
        function new(string name="axi_read_unaligned_seq"); 
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
                                araddr inside {1,2,3,5,6,7};
                        })
                                `uvm_error("RD_UNALIGN_SEQ","randomization failed")
                        finish_item(tr);
                end
        endtask
endclass
