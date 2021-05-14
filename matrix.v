`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 04:43:15
// Design Name: 
// Module Name: matrix
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


module matrix(clk,reset,value1,value2,addra,addrA,addrb,addrB,addrc,addrC,wea,weA,web,weB,wec,weC,dina,dinA,dinb,dinB,dinc,dinC,done);
input clk,reset;
input [31:0] value1,value2;

output reg [13:0] addra;
output reg [13:0] addrA;
output reg [13:0] addrb;
output reg [13:0] addrB;
output reg [9:0] addrC;
output reg [9:0] addrc;

output reg wea;
output reg weA;
output reg web;
output reg weB;
output reg weC;
output reg wec;


 reg ena;
 reg enA;
 reg enb;
 reg enB;
 reg enC;
 reg enc;

output reg [31:0] dina;
output reg [31:0] dinA;
output reg [31:0] dinb;
output reg [31:0] dinB;
output reg [31:0] dinC;
output reg [31:0] dinc;
 
output reg done;


reg [5:0]j,k,l;
//counter

wire [13:0]evena;

wire [13:0]evenb;

wire [9:0]evenc;

reg reset1,enable1,enable2,enable3,enable4,enablea,enableb,enablec;

counter_even a1(reset,clk,enablea,evena);


counter_even b1(reset,clk,enableb,evenb);

counter_even c1(reset,clk,enablec,evenc);


defparam a1.COUNT_LEN=13;
defparam b1.COUNT_LEN=13;
defparam c1.COUNT_LEN=9;



//state initialisation
`define reset_state 5'd0
`define enden 5'd4
`define statea 5'd1
`define stateb 5'd2
`define statec 5'd3

reg [31:0]val,ri;
reg [5:0]state;
reg [5:0]next_state;
  
/*
genvar i;
generate
for(i=0;i<16;i=i+1)
begin
blk_mem_gen_0 sparse (
    .clka(clk),    // input wire clka
    .ena(ena[i]),      // input wire ena
    .wea(wea[i]),      // input wire [0 : 0] wea
    .addra(addra[i]),  // input wire [3 : 0] addra
    .dina(dina[i]),    // input wire [5 : 0] dina
    .douta(douta[i]),  // output wire [5 : 0] douta
    .clkb(clk),    // input wire clkb
    .enb(enb[i]),      // input wire enb
    .web(web[i]),      // input wire [0 : 0] web
    .addrb(addrb[i]),  // input wire [3 : 0] addrb
    .dinb(dinb[i]),    // input wire [5 : 0] dinb
    .doutb(doutb[i])  // output wire [5 : 0] doutb
  );
  end
  endgenerate
*/
// taking the input
  always@(posedge clk,posedge reset) begin
  if(reset) begin
  val=31'd0;
  ri = 31'd0;
  end
  else begin
  val=value1;
  ri =value2;
  end
  end
  
  //state
 always@(posedge clk,posedge reset) begin
 if (reset) 
 state=5'd0;
 else 
 state=next_state;
 end
  
always@(state,reset,evena,evenb,evenc) begin 
if (reset)
begin
next_state=0;

end
else
begin
case(state)
`reset_state:  begin next_state=`statea;  end
 `statea: begin if(evena==14'd8734) next_state=`stateb; else next_state=`statea;  
 end
 `stateb: begin if(evenb==14'd8734) next_state=`statec; else next_state=`stateb;  
 end
 `statec: begin if(evenc==10'd558) next_state=`enden; else next_state=`statec;  
 end
`enden : begin next_state=`enden; end
default : begin next_state=`reset_state; end
endcase 
end
end


//evena
always@(state,reset)
begin
if(reset) begin enablea=1'b0;  end
else
begin
case(state)
`statea:begin
enablea=1'b1;
end
default: begin
enablea=1'b0;
end
endcase
end
end
//evenb
always@(state,reset)
begin
if(reset) begin enableb=1'b0;  end
else
begin
case(state)
`stateb:begin
enableb=1'b1;
end
default: begin
enableb=1'b0;
end
endcase
end
end
//evenc
always@(state,reset)
begin
if(reset) begin enablec=1'b0;  end
else
begin
case(state)
`statec:begin
enablec=1'b1;
end
default: begin
enablec=1'b0;
end
endcase
end
end


//functional
always@(state,reset,val,ri,evena,evenb,evenc)
begin
if(reset)
begin
dina=0;
dinA=0;
dinb=0;
dinB=0;
dinc=0;
dinC=0;

wea=0;
weA=0;
web=0;
weB=0;
wec=0;
weC=0;


ena=0;
enA=0;
enb=0;
enB=0;
enc=0;
enC=0;

addra=0;
addrA=0;
addrb=0;
addrB=0;
addrc=0;
addrC=0;


done=0;
end
else
case(state)
`reset_state: begin
done=0;

dina=0;
dinA=0;
dinb=0;
dinB=0;
dinc=0;
dinC=0;

wea=0;
weA=0;
web=0;
weB=0;
wec=0;
weC=0;


ena=0;
enA=0;
enb=0;
enB=0;
enc=0;
enC=0;

addra=0;
addrA=0;
addrb=0;
addrB=0;
addrc=0;
addrC=0;
end

`statea:begin
dina=val;
dinA=ri;
dinb=0;
dinB=0;
dinc=0;
dinC=0;

wea=1;
weA=1;
web=0;
weB=0;
wec=0;
weC=0;


ena=1;
enA=1;
enb=0;
enB=0;
enc=0;
enC=0;

addra=evena;
addrA=evena+1;
addrb=0;
addrB=0;
addrc=0;
addrC=0;
end
`stateb:begin
dina=0;
dinA=0;
dinb=val;
dinB=ri;
dinc=0;
dinC=0;

wea=0;
weA=0;
web=1;
weB=1;
wec=0;
weC=0;


ena=0;
enA=0;
enb=1;
enB=1;
enc=0;
enC=0;

addra=0;
addrA=0;
addrb=evenb;
addrB=evenb+1;
addrc=0;
addrC=0;
end
`statec:begin
dina=0;
dinA=0;
dinb=0;
dinB=0;
dinc=val;
dinC=ri;

wea=0;
weA=0;
web=0;
weB=0;
wec=1;
weC=1;


ena=0;
enA=0;
enb=0;
enB=0;
enc=1;
enC=1;

addra=0;
addrA=0;
addrb=0;
addrB=0;
addrc=evenc;
addrC=evenc+1;
end

`enden :begin 
done=1;
dina=0;
dinA=0;
dinb=0;
dinB=0;
dinc=0;
dinC=0;

wea=0;
weA=0;
web=0;
weB=0;
wec=0;
weC=0;


ena=1;
enA=1;
enb=1;
enB=1;
enc=1;
enC=1;

addra=0;
addrA=0;
addrb=0;
addrB=0;
addrc=0;
addrC=0;
end
default: begin
done=0;

dina=0;
dinA=0;
dinb=0;
dinB=0;
dinc=0;
dinC=0;

wea=0;
weA=0;
web=0;
weB=0;
wec=0;
weC=0;


ena=1;
enA=1;
enb=1;
enB=1;
enc=1;
enC=1;

addra=0;
addrA=0;
addrb=0;
addrB=0;
addrc=0;
addrC=0;
end
endcase
end 

endmodule
