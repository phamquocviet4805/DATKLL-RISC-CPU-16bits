`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 10:08:14 AM
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
    input clk, rst, ra_signal, at_signal, hi_signal, lo_signal, hi_from_alu_signal, lo_from_alu_signal,
    input [15:0] ra_data, at_data, hi_data, lo_data, pc, hi_from_alu_data, lo_from_alu_data,
    input [2:0] mfsr_sel,
    output reg [15:0] mfsr_data
    );
    reg [15:0] ra, at, hi, lo;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
          ra <= 16'h0000; at <= 16'h0000; hi <= 16'h0000; lo <= 16'h0000;
        end 
        else begin
           if (ra_signal) ra <= ra_data;
           if (at_signal) at <= at_data;
           if (hi_signal) hi <= hi_data;
           if (lo_signal) lo <= lo_data;
           if (hi_from_alu_signal) hi <= hi_from_alu_data;
           if (lo_from_alu_signal) lo <= lo_from_alu_data;
       end
    end
    
    always @* begin
    case (mfsr_sel)
      3'b000: mfsr_data = 16'h0000;    // $ZERO
      3'b001: mfsr_data = pc;           // $PC
      3'b010: mfsr_data = ra;          // $RA
      3'b011: mfsr_data = at;          // $AT
      3'b100: mfsr_data = hi;          // $HI
      3'b101: mfsr_data = lo;          // $LO
      default: mfsr_data = 16'h0000;   // undefined -> 0 
    endcase
  end
endmodule
