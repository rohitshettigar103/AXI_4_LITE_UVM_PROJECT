class c_20_2;
    rand bit[31:0] araddr; // rand_mode = ON 

    constraint c4_this    // (constraint_mode = ON) (axi_transaction.sv:69)
    {
       (araddr inside {[32'h0:32'h24]});
    }
    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (axi_read.sv:14)
    {
       (araddr inside {[32'h34:32'h38]});
    }
endclass

program p_20_2;
    c_20_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "zxxx10z010z0z10xxx0x1xzxxx11xz00zzzzxxzxxxxxxzxxxxzzxxxzzzzzzzxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
