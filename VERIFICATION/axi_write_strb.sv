// axi_write_wstrb_sweep_seq.sv
// Forces WSTRB=0000 (no bytes) and WSTRB=1111 (all bytes)
class axi_write_strb_seq extends uvm_sequence #(axi_transaction);
        `uvm_object_utils(axi_write_strb_seq)

        function new(string name="axi_write_wstrb_seq"); super.new(name); endfunction

        task body();
                axi_transaction tr;
                bit [3:0] strobes[] = '{4'h0, 4'hF, 4'h5};

                foreach(strobes[i]) begin
                        tr=axi_transaction::type_id::create("tr");
                        start_item(tr);
                        if(!tr.randomize() with {
                                read_write==0; awvalid==1; wvalid==1; bready==1;
                                awaddr inside {4,8,12};
                                wstrb == strobes[i];
                        })
                                `uvm_error("WR_WSTRB_SWEEP","randomization failed")
                        finish_item(tr);
                end
        endtask
endclass
