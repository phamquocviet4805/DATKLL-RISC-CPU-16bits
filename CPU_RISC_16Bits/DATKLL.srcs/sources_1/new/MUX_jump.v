`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 03:15:05 PM
// Design Name: 
// Module Name: MUX_jump
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

module MUX_jump(input[15:0] pc_jump, pc_branch, input jump_signal, output[15:0] next_pc);
    assign next_pc = (jump_signal == 1'b1) ? pc_jump : pc_branch;
endmodule
