
class axi_read_addr extends uvm_sequence #(axi_transaction);
        `uvm_object_utils(axi_read_addr)
        
        function new(string name="axi_read_addr"); 
		super.new(name); 
	endfunction

        task body();
                axi_transaction tr;
                repeat(50) begin
                        tr=axi_transaction::type_id::create("tr");
                        start_item(tr);
                        tr.randomize();
                        finish_item(tr);
                end
        endtask
endclass
