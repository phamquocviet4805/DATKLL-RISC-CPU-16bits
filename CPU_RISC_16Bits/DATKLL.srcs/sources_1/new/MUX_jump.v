`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2025 09:31:47 PM
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


module MUX_jump(input [15:0] pc_add_2, [11:0] instruction, jump_signal, [15:0] pc_branch_mux, output [15:0] jump_target);
    assign jump_target = (jump_signal == 1) ? {pc_add_2[15:13], instruction[11:0], 1'b0}: pc_branch_mux;
endmodule
