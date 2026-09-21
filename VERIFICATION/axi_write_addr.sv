
class axi_write_addr extends uvm_sequence #(axi_transaction);
        `uvm_object_utils(axi_write_addr)
        
        function new(string name="axi_write_addr"); 
		super.new(name); 
	endfunction

        task body();
                axi_transaction tr;
                repeat(50000) begin
                        tr=axi_transaction::type_id::create("tr");
                        start_item(tr);
                        tr.randomize();
                        finish_item(tr);
                end
        endtask
endclass
