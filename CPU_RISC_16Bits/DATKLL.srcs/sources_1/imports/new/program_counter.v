`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2025 01:05:31 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter (
    input clk,
    input reset,         
    input [15:0] pc_in,   
    input hold_hlt,
    output reg [15:0] pc_out 
);
initial begin
    pc_out = 16'h0000;
end   
always @(posedge clk or negedge reset) begin
    if (reset) 
        pc_out <= 16'h0000;
    else if (!hold_hlt) 
        pc_out <= pc_in;
end
endmodule

