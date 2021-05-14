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
module topmod(clk,reset,input1,input2,addrext,valid,zeros,op1,op2,done);

input clk;
input reset;
input[31:0] input1;
input [31:0]input2;
output wire [63:0] op1;
output wire [63:0] op2;
output wire [9:0] addrext;
output wire valid;
output wire zeros;

wire [13:0] address_val1,address_val2,address_col1,address_col2;
wire [9:0]address_row1,address_row2;
wire [31:0] value_data_in1,value_data_in2;
wire [31:0] column_data_in1,column_data_in2,row_data_in1,row_data_in2;
wire [31:0] dout_value1,dout_value2,dout_col1,dout_col2,dout_row1,dout_row2;
wire wea_value,web_value,wea_col,web_col,wea_row,web_row;

blk_mem_gen_0 spv_ram(.clka(clk), .addra(address_val1), .dina(value_data_in1), .douta(dout_value1), .wea(wea_value), .clkb(clk),.web(web_value),.addrb(address_val2),.dinb(value_data_in2),.doutb(dout_value2));
blk_mem_gen_0 col_ram(.clka(clk), .addra(address_col1), .dina(column_data_in1), .douta(dout_col1),  .wea(wea_col),   .clkb(clk),.web(web_col),.addrb(address_col2), .dinb(column_data_in2),.doutb(dout_col2)  );
blk_mem_gen_1 row_ram(.clka(clk), .addra(address_row1), .dina(row_data_in1), .douta(dout_row1),     .wea(wea_row),   .clkb(clk),.web(web_row), .addrb(address_row2),.dinb(row_data_in2),.doutb(dout_row2));

output wire done;
wire done_mul;
wire [13:0]address_val1_matrix,address_col1_matrix;
wire [9:0] address_row1_matrix;
wire wea_col_matrix,wea_row_matrix,wea_value_matrix,web_col_matrix,web_row_matrix,web_value_matrix;
//matrix is having an active high signal as reset hence the !
matrix init_instance(clk,((!reset)||(done_mul)),input1,input2,address_val1_matrix,address_val2,address_col1_matrix,address_col2,address_row1_matrix,address_row2,wea_value_matrix,web_value_matrix,wea_col_matrix,web_col_matrix,wea_row_matrix,web_row_matrix,value_data_in1,value_data_in2,column_data_in1,column_data_in2,row_data_in1,row_data_in2,done);

wire rst1;

wire [63:0] op1_mul,op2_mul;
wire valid_mul,zeros_mul;
wire [13:0] address_col1_mul,address_val1_mul;
wire [9:0] address_row1_mul;
mul_new  mul_instance(clk, (reset&&(done)),rst1, input1, input2, op1_mul, op2_mul ,addrext, valid_mul, zeros_mul, dout_row1,dout_col1,address_val1_mul,address_row1_mul,dout_value1,address_col1_mul,done_mul);

assign op1=done?op1_mul:0;
assign op2=done?op2_mul:0;
assign valid=done?valid_mul:0;
assign zeros=done?zeros_mul:0;
assign address_val1=done? address_val1_mul:address_val1_matrix;
assign address_col1=done? address_col1_mul:address_col1_matrix;
assign address_row1=done? address_row1_mul:address_row1_matrix;
assign wea_col=done?0:wea_col_matrix;
assign wea_row=done?0:wea_row_matrix;
assign wea_value=done?0:wea_value_matrix;
assign web_col=done?0:web_col_matrix;
assign web_row=done?0:web_row_matrix;
assign web_value=done?0:web_value_matrix;
wire count;
counter top_count_instance(!reset,clk,done,count);

defparam top_count_instance.COUNT_LEN=0;

assign rst1=count;
endmodule    