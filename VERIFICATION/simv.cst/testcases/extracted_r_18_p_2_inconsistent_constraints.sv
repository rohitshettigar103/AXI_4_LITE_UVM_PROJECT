class c_18_2;
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

program p_18_2;
    c_18_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "1001zxzxzxz0x00x1z11z0z000zx1z1zxxxxxzxxzxxxxzxzzzxxzxzzxzzxzxxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
