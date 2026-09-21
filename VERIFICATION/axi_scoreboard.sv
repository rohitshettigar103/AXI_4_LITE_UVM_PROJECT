class axi_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(axi_scoreboard)

        bit [`DW-1:0] mem [$];
        bit [7:0] MATCH, MISMATCH;

        uvm_tlm_analysis_fifo#(axi_transaction) in_wrt_fifo;
        uvm_tlm_analysis_fifo#(axi_transaction) in_rd_fifo;
        uvm_tlm_analysis_fifo#(axi_transaction) out_wrt_fifo;
        uvm_tlm_analysis_fifo#(axi_transaction) out_rd_fifo;

        bit [1:0]     bresp, rresp;
        bit [`DW-1:0] rdata;

        axi_transaction wrt, rd, out_wrt, out_rd;

        function new(string name="axi_scoreboard", uvm_component parent);
                super.new(name,parent);
                in_wrt_fifo=new("in_wrt_fifo",this);
                in_rd_fifo=new("in_rd_fifo",this);
                out_wrt_fifo=new("out_wrt_fifo",this);
                out_rd_fifo=new("out_rd_fifo",this);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                mem.delete();
                for(int i=0; i<`MEM; i++)
                        mem.push_back({`DW{1'b0}});
        endfunction

        // Byte-address ranges from the spec's address map:
        // 0-36  (0x00-0x24) normal R/W
        // 40-48 (0x28-0x30) read-only  -> writable=0, readable=1
        // 52-56 (0x34-0x38) write-only -> writable=1, readable=0
        // 60    (0x3C)      reserved/normal R/W
        function bit write_valid(bit [`AW-1:0] addr);
                if((addr>=0 && addr<=36)||(addr>=52 && addr<=56)||(addr==60))
                        return 1;
                else
                        return 0;
        endfunction

        function bit read_valid(bit [`AW-1:0] addr);
                if((addr>=0 && addr<=36) || (addr>=40 && addr<=48) || (addr==60))
                        return 1;
                else
                        return 0;
        endfunction

        task run_phase(uvm_phase phase);
                forever
                begin
                        fork
                                begin
                                        in_wrt_fifo.get(wrt);
                                        write();
                                end
                                begin
                                        in_rd_fifo.get(rd);
                                        read();
                                end
			join_any
                end
        endtask

        task write();
                if(wrt.awaddr > 63)
                begin
                        bresp=2'b11;
                end
                else if(wrt.awaddr % 4 != 0)
                begin
                        bresp=2'b10;
                end
                else if(write_valid(wrt.awaddr))
                begin
                        foreach(wrt.wstrb[i])
                        begin
                                if(wrt.wstrb[i])
                                        mem[wrt.awaddr>>2][i*8+:8]=wrt.wdata[i*8+:8];
                        end
                        bresp=2'b00;
                end
                else
                        bresp=2'b10;

                out_wrt_fifo.get(out_wrt);
                if(out_wrt.bresp == bresp)
                begin
                        MATCH++;
                        `uvm_info("SCB",$sformatf("WRITE MATCH AWADDR=%0d WDATA=%0d WSTRB=%b EXP_BRESP=%b GOT_BRESP=%b",
                                wrt.awaddr, wrt.wdata, wrt.wstrb, bresp, out_wrt.bresp), UVM_LOW)
                end
                else
                begin
                        MISMATCH++;
                        `uvm_error("SCB", $sformatf("WRITE MISMATCH AWADDR=%0d WDATA=%0d WSTRB=%b EXP_BRESP=%b GOT_BRESP=%b",
                                wrt.awaddr, wrt.wdata, wrt.wstrb, bresp, out_wrt.bresp))
                end
        endtask

        task read();
                if(rd.araddr > 63)
                begin
                        rresp=2'b11;
                        rdata=0;
                end
                else if(rd.araddr % 4 != 0)
                begin
                        rresp=2'b10;
                        rdata=0;
                end
                else if(read_valid(rd.araddr))
                begin
                        rresp=2'b00;
                        if((rd.araddr>>2) < mem.size())
                                rdata=mem[rd.araddr>>2];
                        else
                                rdata=0;
                end
                else
                begin
                        rresp=2'b10;
                        rdata=0;
                end

                out_rd_fifo.get(out_rd);
                if(rdata == out_rd.rdata && rresp == out_rd.rresp)
                begin
                        MATCH++;
                        `uvm_info("SCB", $sformatf("READ MATCH ARADDR=%0d EXP_RDATA=%0d EXP_RRESP=%b GOT_RDATA=%0d GOT_RRESP=%b",
                                rd.araddr, rdata, rresp, out_rd.rdata, out_rd.rresp), UVM_LOW)
                end
                else
                begin
                        MISMATCH++;
                        `uvm_error("SCB", $sformatf("READ MISMATCH ARADDR=%0d EXP_RDATA=%0d EXP_RRESP=%b GOT_RDATA=%0d GOT_RRESP=%b",
                                rd.araddr, rdata, rresp, out_rd.rdata, out_rd.rresp))
                end
        endtask

        function void report_phase(uvm_phase phase);
                `uvm_info("SCB", $sformatf("TOTAL TRANSACTION = %0d MATCH = %0d MISMATCH = %0d",
                        MATCH+MISMATCH, MATCH, MISMATCH), UVM_LOW)
        endfunction

endclass
