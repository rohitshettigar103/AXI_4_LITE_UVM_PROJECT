class c_11_2;
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

program p_11_2;
    c_11_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "0xx00xxz11zxzz0xz01z11zz10xz0zx0zxxxxzzzxxzzxxzxxzxxxzzxxzzxxxxx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
