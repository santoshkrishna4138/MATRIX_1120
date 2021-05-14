`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03.04.2021 06:50:14
// Design Name:
// Module Name: topmod
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
module topmod(clk,reset,input1,input2,addrext,valid,zeros,op1,op2);

input clk;
input reset;
input[31:0] input1;
input [31:0]input2;
output wire [63:0] op1;
output wire [63:0] op2;
output wire [9:0] addrext;
output wire valid;
output wire zeros;

reg [13:0] address_val1,address_val2,address_col1,address_col2,address_row1,address_row2;
reg [31:0] value_data_in1,value_data_in2;
reg [31:0] column_data_in1,column_data_in2,row_data_in1,row_data_in2;
reg [31:0] dout_value1,dout_value2,dout_col1,dout_col2,dout_row1,dout_row2;
reg wea_value,web_value,wea_col,web_col,wea_row,web_row;

blk_mem_gen_0 spv_ram(.clka(clk), .addra(address_val1), .dina(value_data_in1), .douta(dout_value1), .wea(wea_value), .clkb(clk),.web(web_value),.addrb(address_val2),.dinb(value_data_in2),.doutb(dout_value2));
blk_mem_gen_0 col_ram(.clka(clk), .addra(address_col1), .dina(column_data_in1), .douta(dout_col1),  .wea(wea_col),   .clkb(clk),.web(web_col),.addrb(address_col2), .dinb(column_data_in2),.doutb(dout_col2)  );
blk_mem_gen_0 row_ram(.clka(clk), .addra(address_row1), .dina(row_data_in1), .douta(dout_row1),     .wea(wea_row),   .clkb(clk),.web(web_row), .addrb(address_row2),.dinb(row_data_in2),doutb(dout_row2));

wire done;
//matrix is having an active high signal as reset hence the !
matrix(clk,(!reset),input1,input2,address_val1,address_val2,address_col1,address_col2,address_row1,address_row2,wea_value,web_value,wea_col,web_col,wea_row,web_row,value_data_in1,value_data_in2,column_data_in1,column_data_in2,row_data_in1,row_data_in2,done);

reg rst1;
mul_new(clk, (reset||(done)),rst1, input1, input2, op1, op2 ,addrext, valid, zeros, dout_row1,dout_row2,address_val1,address_row1,dout_value1,address_col1);




endmodule    