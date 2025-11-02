`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2025 02:19:06 PM
// Design Name: 
// Module Name: reg_file
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


// REGISTER FILE

module reg_file(rs1,rs2,rd,data,reg_wrt,readA_out,readB_out,r3,clk,bank_sel);
input reg_wrt,clk;
input [1:0] bank_sel;
input [2:0]rs1,rs2,rd;
input [15:0]data;
output [15:0]readA_out,readB_out;
output [15:0] r3;

wire [3:0] rs1_ext = (bank_sel == 2'b01) ? {1'b1, rs1} : {1'b0, rs1};
wire [3:0] rs2_ext = (bank_sel == 2'b01) ? {1'b1, rs2} : {1'b0, rs2};
wire [3:0] rd_ext  = (bank_sel == 2'b10) ? {1'b1, rd} : {1'b0, rd};
reg [15:0] x [0:15];
integer i;
initial begin
    x[0]=0;    
    x[1]=0;    
    x[2]=0;     
    x[3]=0;     
    x[4]=0;    
    x[5]=0;     
    x[6]=0;    
    x[7]=0;    
    x[8]=0;     // R0 contains zero
    x[9]=0;     // Stack pointer 
    x[10]=0;    // Return address
    x[11]=0;    // Function argument/ result
    x[12]=0;    // Propram counter
    x[13]=0;    // Assembler Temporary
    x[14]=0;    // HI
    x[15]=0;    // LO
end

always @(posedge clk)
begin
    if(reg_wrt==1)
        x[rd_ext]<=data;
end
assign readA_out = x[rs1_ext];
assign readB_out = x[rs2_ext];
assign r3 = x[11];
endmodule