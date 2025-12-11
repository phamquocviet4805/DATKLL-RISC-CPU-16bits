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
    input        reg_wrt,
    input        clk,
    input  [2:0] rs,
    input  [2:0] rt,
    input  [2:0] rd,
    input  [15:0] data,
    output [15:0] readA_out,
    output [15:0] readB_out,
    output [15:0] r0, r1, r2, r3, r4, r5, r6, r7
);

reg [15:0] x [0:7];

    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1)
            x[i] = 16'b0;
    end

    always @(posedge clk) begin
        if (reg_wrt) begin
            x[rd] <= data;
        end
    end

    assign readA_out = x[rs];
    assign readB_out = x[rt];
    assign r0        = x[0];    // debug 
    assign r1        = x[1]; 
    assign r2        = x[2]; 
    assign r3        = x[3]; 
    assign r4        = x[4]; 
    assign r5        = x[5]; 
    assign r6        = x[6];
    assign r7        = x[7];

endmodule