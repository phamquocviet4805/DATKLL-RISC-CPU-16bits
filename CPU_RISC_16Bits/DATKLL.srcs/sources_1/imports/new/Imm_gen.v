`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2025 11:57:57 AM
// Design Name: 
// Module Name: Imm_gen
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


module Imm_gen( 
    input [15:0] instruction, 
    input [2:0] imm_type, 
    output [15:0] imm_out 
);
assign imm_out =    (imm_type ==3'b000)? {{10{instruction[5]}}, instruction[5:0]}: //I-type signed
                    {{3{1'b0}}, instruction[11:0], 1'b0};   // Other type imm_out = imm_extended * 2
          
endmodule
