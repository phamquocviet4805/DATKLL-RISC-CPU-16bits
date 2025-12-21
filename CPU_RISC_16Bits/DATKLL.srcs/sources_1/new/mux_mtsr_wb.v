`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 03:15:05 PM
// Design Name: 
// Module Name: mux_mtsr_wb
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


module mux_mtsr_wb( input[15:0] A, B, input mux, output[15:0] outmux);
        assign outmux = (mux == 1'b0) ? A : B;
endmodule
