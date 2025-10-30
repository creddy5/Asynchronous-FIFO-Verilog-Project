`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2025 19:51:26
// Design Name: 
// Module Name: asyn_fifo
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


module asyn_fifo #(
    parameter DATA_WIDTH=4,
    parameter FIFO_DEPTH=8,
    parameter ADDR_SIZE=4 
    )(
    input [DATA_WIDTH-1:0] DATA_IN,
    input W_EN,R_EN,W_CLK,R_CLK,RST,
    output FULL,EMPTY,
    output reg [DATA_WIDTH-1:0] DATA_OUT
    );
    reg [ADDR_SIZE-1:0] Wb_PTR,Rb_PTR,Wg_PTR_S1,Wg_PTR_S2,Rg_PTR_S1,Rg_PTR_S2;
    wire[ADDR_SIZE-1:0] Wg_PTR,Rg_PTR;
    reg [DATA_WIDTH-1:0] MEM [FIFO_DEPTH-1:0];
    
    //Writing to FIFO
    always @(posedge W_CLK) 
    begin
    if(RST) Wb_PTR <=0;
    else
   begin
     if(W_EN && !FULL)
     begin
     MEM [Wb_PTR] <= DATA_IN;
     Wb_PTR <= Wb_PTR+1;
     end
   end
 end
     
     //Reading from FIFO
     always @(posedge R_CLK) 
    begin
    if(RST) Rb_PTR <=0;
    else
   begin
     if(R_EN && !EMPTY)
     begin
     DATA_OUT <= MEM [Rb_PTR];
     Rb_PTR <= Rb_PTR+1;
     end
   end
 end
     
 // Binary to Gray Conversion       
 assign Wg_PTR = Wb_PTR ^(Wb_PTR >>1);
 assign Rg_PTR = Rb_PTR ^(Rb_PTR >>1);    
     
 //pass to 2 stage Write Sync
 always @ (posedge W_CLK)
 begin
 if(RST) begin
 Wg_PTR_S1 <=0;
 Wg_PTR_S2 <=0;
 end 
 else
 begin
  Wg_PTR_S1 <=Wg_PTR;
  Wg_PTR_S2 <=Wg_PTR_S1;
 end
 end
     
   //pass to 2 stage Read Sync
 always @ (posedge R_CLK)
 begin
 if(RST) begin
 Rg_PTR_S1 <=0;
 Rg_PTR_S2 <=0;
 end 
 else
 begin
  Rg_PTR_S1 <=Rg_PTR;
  Rg_PTR_S2 <=Rg_PTR_S1;
 end
 end
 
 //empty condition
 assign EMPTY=(Rg_PTR==Wg_PTR_S2);
 
 //full condition
 assign FULL = (Wg_PTR == {~Rg_PTR_S2[ADDR_SIZE-1:ADDR_SIZE-2], Rg_PTR_S2[ADDR_SIZE-3:0]});
   
endmodule
