// Writes to the Write-Only region (52-56) - legal write, expect OKAY.
class axi_write_wo_seq extends uvm_sequence #(axi_transaction);
        `uvm_object_utils(axi_write_wo_seq)
        
        function new(string name="axi_write_wo_seq"); 
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
                                awaddr inside {52,56};
                        })
                                `uvm_error("WR_WO_SEQ","randomization failed")
                        finish_item(tr);
                end
        endtask
endclass
