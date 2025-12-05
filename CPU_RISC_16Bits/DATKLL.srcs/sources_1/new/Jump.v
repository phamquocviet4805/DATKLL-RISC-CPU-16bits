`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2025 10:33:21 PM
// Design Name: 
// Module Name: Jump
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


module Jump(input [15:0] pc, [11:0] instruction, output [15:0] jump_target);
    assign jump_target = {pc[15:13], instruction[11:0], 1'b0};
endmodule
