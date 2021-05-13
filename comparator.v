module comparator(clk, A, B, L, G, E);

    input clk;
    input [31:0] A, B;
    output reg L, G, E;
    
    always @ (posedge clk)
    begin
        if(A < B)
        begin
            L <= 1;
            E <= 0;
            G <= 0;
        end
        
        if(A == B)
        begin
            L <= 0;
            E <= 1;
            G <= 0;
        end
        
        if(A > B)
        begin
            L <= 0;
            E <= 0;
            G <= 1;
        end
     end

endmodule
