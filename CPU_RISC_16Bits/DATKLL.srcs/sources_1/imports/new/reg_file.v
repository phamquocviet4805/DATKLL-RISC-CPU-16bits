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

module reg_file(
    input reg_wrt, clk,
    input [2:0] rs, rt, rd,
    input [15:0] data,
    output [15:0] readA_out, readB_out,
    output [15:0] r3
);

reg [15:0] x [0:7];

initial begin
    x[0]=0;    
    x[1]=0;    
    x[2]=0;     
    x[3]=0;     
    x[4]=0;    
    x[5]=0;     
    x[6]=0;    
    x[7]=0;    
end

//wire [3:0] rs_ext = x[rs];
//wire [3:0] rt_ext =  x[rt];
//wire [3:0] rd_ext =  x[rd];

always @(posedge clk)
begin
    if (reg_wrt==1)
        x[rd] <= data;
end

assign readA_out = x[rs];
assign readB_out = x[rt];

endmodule