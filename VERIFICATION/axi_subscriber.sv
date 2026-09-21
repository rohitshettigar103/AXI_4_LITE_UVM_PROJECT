// axi_req_coverage.sv
// Connects to BOTH write_req_ap and read_req_ap (both carry
// axi_transaction, so both can feed the same subscriber). Samples
// which address region was hit, and for writes, which WSTRB
// pattern was used.\

class axi_req_coverage extends uvm_subscriber #(axi_transaction);
        `uvm_component_utils(axi_req_coverage)

        axi_transaction tr;

        covergroup cg;
                option.per_instance = 1;

               cp_rw: coverpoint tr.read_write {
                        bins write = {0};
                        bins read  = {1};
                }

                cp_awaddr: coverpoint tr.awaddr iff(tr.read_write==0) {
                        bins normal          = {[0:36]};
                        bins read_only       = {[40:48]};
                        bins write_only      = {[52:56]};
                     //   bins reserved        = {60};
                        bins invalid_default = default;
                }

                cp_araddr: coverpoint tr.araddr iff(tr.read_write==1) {
                        bins normal          = {[0:36]};
                        bins read_only       = {[40:48]};
                        bins write_only      = {[52:56]};
                 //       bins reserved        = {60};
                        bins invalid_default = default;
                }

                cp_wstrb: coverpoint tr.wstrb iff(tr.read_write==0) {
                        bins all_bytes = {4'hF};
                        bins no_bytes  = {4'h0};
                        bins partial= {[4'h1:4'hE]};
                }
        endgroup

        function new(string name="axi_req_coverage", uvm_component parent);
                super.new(name,parent);
                cg = new();
        endfunction

        function void write(axi_transaction t);
                tr = t;
                cg.sample();
        endfunction

        function void report_phase(uvm_phase phase);
                `uvm_info("REQ_COV", $sformatf("Request coverage = %0.2f%%", cg.get_coverage()), UVM_LOW)
        endfunction

endclass

