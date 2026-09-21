// Writes to an out-of-range address (>63) - expect DECERR.
class axi_write_decerr_seq extends uvm_sequence #(axi_transaction);
        `uvm_object_utils(axi_write_decerr_seq)
        
        function new(string name="axi_write_decerr_seq"); 
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
                                awaddr inside {64,100,124};
                        })
                                `uvm_error("WR_DECERR_SEQ","randomization failed")
                        finish_item(tr);
                end
        endtask
endclass
