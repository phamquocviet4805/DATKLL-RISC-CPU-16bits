`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 03:15:05 PM
// Design Name: 
// Module Name: special_register
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


module special_register(
    input        clk,
    input        rst,
    input        ra_signal,
    input        at_signal,
    input        hi_signal,
    input        lo_signal,
    input        hi_from_alu_signal,
    input        lo_from_alu_signal,

    input  [15:0] ra_data,
    input  [15:0] at_data,
    input  [15:0] hi_data,
    input  [15:0] lo_data,
    input  [15:0] pc,
    input  [15:0] hi_from_alu_data,
    input  [15:0] lo_from_alu_data,

    input  [2:0] mfsr_sel,
    output reg [15:0] mfsr_data
);
    reg [15:0] ra, at, hi, lo;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ra <= 16'h0000;
            at <= 16'h0000;
            hi <= 16'h0000;
            lo <= 16'h0000;
        end else begin
            // Write from MTSR
            if (ra_signal) ra <= ra_data;
            if (at_signal) at <= at_data;
            if (hi_signal) hi <= hi_data;
            if (lo_signal) lo <= lo_data;

            // Write from ALU (MULT/DIV) - with priority
            if (hi_from_alu_signal) hi <= hi_from_alu_data;
            if (lo_from_alu_signal) lo <= lo_from_alu_data;
        end
    end

    always @* begin
        case (mfsr_sel)
            3'b000: mfsr_data = 16'h0000; // ZERO
            3'b001: mfsr_data = pc;       // PC
            3'b010: mfsr_data = ra;       // RA
            3'b011: mfsr_data = at;       // AT
            3'b100: mfsr_data = hi;       // HI
            3'b101: mfsr_data = lo;       // LO
            default: mfsr_data = 16'h0000;
        endcase
    end
endmodule
