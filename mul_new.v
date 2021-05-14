`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2021 18:34:02
// Design Name: 
// Module Name: mul_new
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mul_new(clk, rst,rst1, datain1, datain2, dataout1, dataout2 ,addrext, valid, zeros, row_wire,col_wire,addrsp,addrrow,sparse,addrsp_copy,done);
	input wire [31:0] row_wire, col_wire;
   output reg [13:0] addrsp,addrsp_copy;
   output reg [9:0] addrrow;
    input wire [31:0] sparse;
    input clk, rst,rst1;
    input [31:0] datain1, datain2;
    output [9:0] addrext;
	output reg done;
    
    output [63:0] dataout1, dataout2;
    
    output reg valid, zeros;
    reg [9:0]done_counter;
    reg [4:0] sclk_counter;
    reg sclk;
    reg sclk_rst;
    always@(posedge clk)
	begin
	if(!rst)
	begin
	addrsp_copy=0;
	end
	else begin
	addrsp_copy=addrsp;
	
	end
	
	end
    always @ (posedge clk)
	begin
	
		if(!sclk_rst)
		begin
			sclk_counter <= 0;
			sclk <= 0;
        end
		else
		begin
            if(sclk_counter == 27)
            begin 
                sclk <= 1;
                sclk_counter <= 0;
            end
            else	
            begin
                sclk <= 0;
                sclk_counter <= sclk_counter + 1;
            end
       end
	end
	

    
    assign addrext = col_wire[9:0];
	
    
   /*  blk_mem_gen_sparse spv_ram(.clka(clk), .addra(addrsp), .dina(32'b0), .douta(sparse), .wea(1'b0));
    blk_mem_gen_col col_ram(.clka(clk), .addra(addrsp), .dina(32'b0), .douta(col_wire),  .wea(1'b0));
    blk_mem_gen_row_CSR row_ram(.clka(clk), .addra(addrrow), .dina(32'b0), .douta(row_wire), .wea(1'b0)); */
    
    //wire [31:0] B [1:0];
    wire [63:0] P [0:1];
    
    mult_gen_0 M0(.CLK(clk), .A(sparse), .B(datain1), .P(P[0]));
    mult_gen_0 M1(.CLK(clk), .A(sparse), .B(datain2), .P(P[1]));
    
    reg bp;
    wire [63:0] adder1, adder2;
    
    c_addsub_0 A1(.CLK(clk), .A(dataout1), .B(P[0]), .BYPASS(bp), .S(adder1));
    c_addsub_0 A2(.CLK(clk), .A(dataout2), .B(P[1]), .BYPASS(bp), .S(adder2));
    
    reg we_res;
    reg [8:0] addr_resa1, addr_resb1;

    
    blk_mem_gen_2 B_res1(.clka(clk), .addra(addr_resa1), .dina(adder1), .wea(we_res), 
                         .clkb(clk), .addrb(addr_resb1), .doutb(dataout1));
                         
    blk_mem_gen_2 B_res2(.clka(clk), .addra(addr_resa1), .dina(adder2), .wea(we_res), 
                         .clkb(clk), .addrb(addr_resb1), .doutb(dataout2));
    
    
    reg [9:0] ref_counter;
    reg counter_rst;
    
    always @ (posedge clk)
    if(!counter_rst)
        ref_counter <= 0;
    else
        if(ref_counter == 560/2 - 1)
        begin
            ref_counter <= 0;
        end
        else
        ref_counter <= ref_counter + 1'b1;
    
    
    reg [280 -1:0] counter;
    //reg counter_rst;
    
    always @ (posedge clk)
    if(!counter_rst)
        counter <= 1'b1;
    else
        counter <= {counter[280 - 2:0], counter[280 - 1]};
        
    reg [8:0] tempaddress1, tempaddress2;
    reg [31:0] add_counter;
    
    wire L, G, E;
    
    comparator c(sclk, add_counter, row_wire, L, G, E);
                    
    always @ (posedge clk)
    if(!rst)
    begin
    if(!rst1) begin  
	 sclk_rst <= 0;
        counter_rst <= 0;
        addrsp <= 0;
        addrrow <= addrrow;
        bp <= 1;
        we_res <= 0;
		done_counter<=0;
        addr_resa1 <= 0;
        addr_resb1 <= 0;
        add_counter <= add_counter;
        valid <= 0; 
         zeros <= 0; 
    end
	else begin
	sclk_rst <= 0;
        counter_rst <= 0;
        addrsp <= 0;
        addrrow <= 1;
        bp <= 1;
        we_res <= 0;
		done_counter<=0;
        addr_resa1 <= 0;
        addr_resb1 <= 0;
        add_counter <= 1;
        valid <= 0;
         zeros <= 0;
	
	end
	end
    else
    begin
        counter_rst <= 1;
        sclk_rst <= 1;
        
        if(counter[276])
            addrsp <= addrsp + 1;
        
        if(counter[11])
            we_res <= 1;
        if(counter[279])
			done_counter <= done_counter+1;
        
        if(we_res)
        begin
            if(addr_resa1 == 279)
                addr_resa1 <= 0;
            else
                addr_resa1 <= addr_resa1 + 1;
            
            case(addr_resa1)
                270: addr_resb1 <= 0;
                271: addr_resb1 <= 1;
                272: addr_resb1 <= 2;
                273: addr_resb1 <= 3;
                274: addr_resb1 <= 4;
                275: addr_resb1 <= 5;
                276: addr_resb1 <= 6;
                277: addr_resb1 <= 7;
                278: addr_resb1 <= 8;
                279: addr_resb1 <= 9;
                
                default: addr_resb1 <= addr_resa1 + 10;
            endcase
            
            if(counter[5])
            begin
                add_counter <= add_counter + 1;
                
                if(E)
                begin
                    bp <= 1;
                    valid <= 1;
                    addrrow <= addrrow + 1;
                end
                
                if(L)
                begin
                    bp <= 0;
                    valid <= 0;
                end
                
                if(G)
                begin
                    bp <= 0;
                    valid <= 0;
                    addrrow <= addrrow + 1;
                    zeros <= 1;
                end
            end
            else
                zeros <= 0;

        end
    end
	
	always@(posedge clk)
	begin
	if(!rst)
	begin
	done=0;
	end
	else begin
	if(done_counter==579)
	begin
	done=1;
	end
	else begin
	done=0;
	end
	end
	end
endmodule
