`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2025 01:40:07 PM
// Design Name: 
// Module Name: MUX_2_1_PC
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


module MUX_2_1_PC( input[15:0] A, B, input mux, output [15:0] outmux );
    assign outmux = (mux == 0) ? A : B;
endmodule

