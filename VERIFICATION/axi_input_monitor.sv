
class axi_input_monitor extends uvm_monitor;
	`uvm_component_utils(axi_input_monitor)


	virtual axi_interface vif;

	uvm_analysis_port#(axi_transaction) write_req_ap;
	uvm_analysis_port#(axi_transaction) read_req_ap;

	function new(string name="axi_input_monitor",uvm_component parent);
		super.new(name,parent);
		write_req_ap=new("write_req_ap",this);
		read_req_ap=new("read_req_ap",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual axi_interface)::get(this, "", "vif", vif))
			`uvm_fatal("VIF", "no virtual interface")
	endfunction

	task run_phase(uvm_phase phase);
		fork
			write_capture();
			read_capture();
		join
	endtask

	task write_capture();
		bit [`AW-1:0]awaddr_c;
		bit [2:0] awprot_c;
		bit [`DW-1:0] wdata_c;
		bit [`SW-1:0] wstrb_c;

		axi_transaction tr;

		forever begin
			
//			tr=axi_transaction::type_id::create("tr",this);
			fork
				begin
					@(vif.mon_clk iff(vif.mon_clk.awvalid && vif.mon_clk.awready));
					awaddr_c = vif.mon_clk.awaddr;
					awprot_c = vif.mon_clk.awprot;
				end
				begin
					@(vif.mon_clk iff(vif.mon_clk.wvalid && vif.mon_clk.wready));
					wdata_c= vif.mon_clk.wdata;
					wstrb_c= vif.mon_clk.wstrb;
				end
			join

			tr=axi_transaction::type_id::create("tr",this);
			
			tr.read_write=0;
			tr.awaddr=awaddr_c;
			tr.awprot=awprot_c;
			tr.wdata=wdata_c;
			tr.wstrb=wstrb_c;
			tr.awvalid=1;
			tr.wvalid=1;
			`uvm_info("INPUT_MON", $sformatf("INPUT MONITOR WRITE: %s", tr.convert2string()), UVM_LOW)


			write_req_ap.write(tr);
		end
	endtask

	task read_capture();
		axi_transaction tr;
		forever begin
			@(vif.mon_clk iff (vif.mon_clk.arvalid && vif.mon_clk.arready));
			tr=axi_transaction::type_id::create("tr");
			tr.read_write=1;
			tr.araddr=vif.mon_clk.araddr;
			tr.arprot=vif.mon_clk.arprot;
			`uvm_info("INPUT_MON", $sformatf("INPUT MONITOR READ: %s", tr.convert2string()), UVM_LOW)

			read_req_ap.write(tr);
		end
	endtask
endclass


					

/*

class axi_input_monitor extends uvm_monitor;
        `uvm_component_utils(axi_input_monitor)

        virtual axi_interface vif;

        uvm_analysis_port#(axi_transaction) write_req_ap;
        uvm_analysis_port#(axi_transaction) read_req_ap;

        function new(string name="axi_input_monitor",uvm_component parent);
                super.new(name,parent);
                write_req_ap=new("write_req_ap",this);
                read_req_ap=new("read_req_ap",this);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if (!uvm_config_db#(virtual axi_interface)::get(this, "", "vif", vif))
                        `uvm_fatal("VIF", "no virtual interface")
        endfunction

        task run_phase(uvm_phase phase);
                fork
                        write_capture();
                        read_capture();
                join
        endtask

       // Captures AW+W signals whenever either handshake is seen.
        // No merging, no waiting for both - just take what is on the
        // bus at that moment and publish it.
        task write_capture();
                axi_transaction tr;
                forever begin
                        @(vif.mon_clk iff ((vif.mon_clk.awvalid && vif.mon_clk.awready) ||
                                           (vif.mon_clk.wvalid  && vif.mon_clk.wready)));

                        tr = axi_transaction::type_id::create("tr");
                        tr.read_write = 0;
                        tr.awaddr  = vif.mon_clk.awaddr;
                        tr.awprot  = vif.mon_clk.awprot;
                        tr.awvalid = vif.mon_clk.awvalid;
                        tr.awready = vif.mon_clk.awready;
                        tr.wdata   = vif.mon_clk.wdata;
                        tr.wstrb   = vif.mon_clk.wstrb;
                        tr.wvalid  = vif.mon_clk.wvalid;
                        tr.wready  = vif.mon_clk.wready;

                        `uvm_info("INPUT_MON", $sformatf("INPUT MONITOR WRITE: %s", tr.convert2string()), UVM_LOW)
                        write_req_ap.write(tr);
                end
        endtask

        // Captures AR signals on the AR handshake.
        task read_capture();
                axi_transaction tr;
                forever begin
                        @(vif.mon_clk iff (vif.mon_clk.arvalid && vif.mon_clk.arready));

                        tr = axi_transaction::type_id::create("tr");
                        tr.read_write = 1;
                        tr.araddr  = vif.mon_clk.araddr;
                        tr.arprot  = vif.mon_clk.arprot;
                        tr.arvalid = vif.mon_clk.arvalid;
                        tr.arready = vif.mon_clk.arready;

                        `uvm_info("INPUT_MON", $sformatf("INPUT MONITOR READ: %s", tr.convert2string()), UVM_LOW)
                        read_req_ap.write(tr);
                end
        endtask
endclass
*/

/*

class axi_input_monitor extends uvm_monitor;
        `uvm_component_utils(axi_input_monitor)

        virtual axi_interface vif;
        uvm_analysis_port#(axi_transaction) write_req_ap;
        uvm_analysis_port#(axi_transaction) read_req_ap;
        axi_transaction write_tr, read_tr;
        bit aw_done, w_done, ar_done, wr_create;

        function new(string name="axi_input_monitor", uvm_component parent);
                super.new(name,parent);
                write_req_ap=new("write_req_ap",this);
                read_req_ap=new("read_req_ap",this);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(virtual axi_interface)::get(this,"","vif",vif))
                        `uvm_fatal("VIF","config db not set for input monitor")
        endfunction

        task run_phase(uvm_phase phase);
                forever
                begin
                        @(vif.mon_clk);
                        if(vif.mon_clk.awvalid || vif.mon_clk.wvalid)
                        begin
                                if(wr_create==0)
                                begin
                                        write_tr=axi_transaction::type_id::create("write_tr");
                                        wr_create=1;
                                end

                                fork
                                        begin
                                                fork
                                                        capture_aw();
                                                        capture_w();
                                                join

                                                if(aw_done && w_done)
                                                        publish_write();
                                        end

                                        begin
                                                if(vif.mon_clk.arvalid)
                                                begin
                                                        capture_ar();
                                                        publish_read();
                                                end
                                        end
                                join
                        end

                        else if(vif.mon_clk.arvalid)
                        begin
                                capture_ar();
                                publish_read();
                        end
                end
        endtask

        task capture_aw();
                if(vif.mon_clk.awvalid && aw_done==0)
                begin
                        //`uvm_info("INPUT_MON", $sformatf("WAITING FOR AWREADY at time %0t", $time), UVM_LOW)
                        @(vif.mon_clk iff (vif.mon_clk.awvalid && vif.mon_clk.awready));
                        //`uvm_info("INPUT_MON", $sformatf("GOT AWREADY at time %0t", $time), UVM_LOW)

                        aw_done=1;
                        write_tr.awaddr=vif.mon_clk.awaddr;
                        write_tr.awvalid=vif.mon_clk.awvalid;
                       // `uvm_info("INPUT_MON", $sformatf("ADDR AWADDR=%0h AWVALID=%0b", write_tr.awaddr, write_tr.awvalid), UVM_LOW)
                end
        endtask

        task capture_w();
                if(vif.mon_clk.wvalid && w_done==0)
                begin
                     //   `uvm_info("INPUT_MON", $sformatf("WAITING FOR WREADY at time %0t", $time), UVM_LOW)
                        @(vif.mon_clk iff (vif.mon_clk.wvalid && vif.mon_clk.wready));
                    //    `uvm_info("INPUT_MON", $sformatf("GOT WREADY at time %0t", $time), UVM_LOW)
                        w_done=1;
                        write_tr.wdata=vif.mon_clk.wdata;
                        write_tr.wstrb=vif.mon_clk.wstrb;
                        write_tr.wvalid=vif.mon_clk.wvalid;
                  //      `uvm_info("INPUT_MON", $sformatf("DATA WDATA=%0h WSTRB=%0b WVALID=%0b", write_tr.wdata, write_tr.wstrb, write_tr.wvalid), UVM_LOW)
                end
        endtask

        task publish_write();
                //`uvm_info("INPUT_MON", $sformatf("WAITING FOR BREADY at time %0t", $time), UVM_LOW)
                @(vif.mon_clk iff vif.mon_clk.bready);
                //`uvm_info("INPUT_MON", $sformatf("WAITING FOR WRITE RESPONSE HANDSHAKE at time %0t", $time), UVM_LOW)
                @(vif.mon_clk iff vif.mon_clk.bvalid);

                write_req_ap.write(write_tr);
                aw_done=0;
                w_done=0;
                wr_create=0;
              //  `uvm_info("INPUT_MON", $sformat"WRITE PUBLISHED AWADDR=%0h WDATA=%0h WSTRB=%0b WVALID=%0b at time %0t","WRITE PUBLISHED AWADDR=%0h WDATA=%0h WSTRB=%0b WVALID=%0b at time %0t",write_tr.awaddr, write_tr.wdata, write_tr.wstrb, write_tr.wvalid, $time), UVM_LOW)
        endtask

        task capture_ar();
                if(vif.mon_clk.arvalid && ar_done==0)
                begin
                        read_tr=axi_transaction::type_id::create("read_tr");
                        //`uvm_info("INPUT_MON", $sformatf("WAITING FOR ARREADY at time %0t", $time), UVM_LOW)
                        @(vif.mon_clk iff (vif.mon_clk.arvalid && vif.mon_clk.arready));
                        //`uvm_info("INPUT_MON", $sformatf("GOT ARREADY at time %0t", $time), UVM_LOW)
                        read_tr.araddr=vif.mon_clk.araddr;
                        read_tr.arvalid=vif.mon_clk.arvalid;
                        ar_done=1;
                end
        endtask

        task publish_read();
                if(ar_done)
                begin
                        @(vif.mon_clk iff(vif.mon_clk.rready && vif.mon_clk.rvalid));
                        read_req_ap.write(read_tr);
                       // `uvm_info("INPUT_MON", $sformatf("READ PUBLISHED ARADDR=%0h ARVALID=%0b at time %0t", read_tr.araddr, read_tr.arvalid, $time), UVM_LOW)
                        ar_done=0;
                end
        endtask
endclass

*/
