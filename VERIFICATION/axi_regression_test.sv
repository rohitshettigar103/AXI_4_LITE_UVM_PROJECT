
class axi_regression_test extends uvm_test;
        `uvm_component_utils(axi_regression_test)

        axi_env env;

        function new(string name="axi_regression_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                env = axi_env::type_id::create("env", this);
        endfunction

        task run_phase(uvm_phase phase);
                axi_write  wr_rand;
                axi_read  rd_rand;
                axi_write_ro_seq  wr_ro;
                axi_write_wo_seq wr_wo;
        //        axi_write_reserved_seq wr_rsvd;
                axi_write_unaligned_seq wr_unal;
                axi_write_decerr_seq  wr_dec;
                axi_read_wo_seq  rd_wo;
                axi_read_ro_seq  rd_ro;
          //      axi_read_reserved_seq rd_rsvd;
                axi_read_unaligned_seq rd_unal;
                axi_read_decerr_seq   rd_dec;
		axi_write_strb_seq wr_strb;
		axi_write_addr wr_addr;
		axi_read_addr rd_addr;

                phase.raise_objection(this);

                wr_rand = axi_write::type_id::create("wr_rand");
                rd_rand = axi_read::type_id::create("rd_rand");
                wr_ro = axi_write_ro_seq::type_id::create("wr_ro");
                wr_wo= axi_write_wo_seq::type_id::create("wr_wo");
              //  wr_rsvd = axi_write_reserved_seq::type_id::create("wr_rsvd");
                wr_unal = axi_write_unaligned_seq::type_id::create("wr_unal");
                wr_dec = axi_write_decerr_seq::type_id::create("wr_dec");
                rd_wo = axi_read_wo_seq::type_id::create("rd_wo");
                rd_ro = axi_read_ro_seq::type_id::create("rd_ro");
            //    rd_rsvd = axi_read_reserved_seq::type_id::create("rd_rsvd");
                rd_unal = axi_read_unaligned_seq::type_id::create("rd_unal");
                rd_dec  = axi_read_decerr_seq::type_id::create("rd_dec");
		wr_addr=axi_write_addr::type_id::create("wr_addr");
		rd_addr=axi_read_addr::type_id::create("rd_addr");

		wr_strb=axi_write_strb_seq::type_id::create("wr_strb");
                        begin
                               wr_rand.start(env.active_agt.write_sqr);
				  #1000;
                                wr_ro.start(env.active_agt.write_sqr);
				  #1000;
                                wr_wo.start(env.active_agt.write_sqr);
				  #1000;
                //                wr_rsvd.start(env.active_agt.write_sqr);
                                wr_unal.start(env.active_agt.write_sqr);
				   #1000;
                                wr_dec.start(env.active_agt.write_sqr);
				   #1000;
				wr_strb.start(env.active_agt.write_sqr);
				  #1000;
				wr_addr.start(env.active_agt.write_sqr);
				  #1000;
                        //end
                        //begin
                                rd_rand.start(env.active_agt.read_sqr);
				   #1000;
                                rd_wo.start(env.active_agt.read_sqr);
				   #1000;
                                rd_ro.start(env.active_agt.read_sqr);
				   #1000;
                  //              rd_rsvd.start(env.active_agt.read_sqr);
                                rd_unal.start(env.active_agt.read_sqr);
				   #1000;
                                rd_dec.start(env.active_agt.read_sqr);
				   #1000;
				rd_addr.start(env.active_agt.read_sqr);
				   #1000;
                        end
		#1000;	
                phase.drop_objection(this);
        endtask
endclass
