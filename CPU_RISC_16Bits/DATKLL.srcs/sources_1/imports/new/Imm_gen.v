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
    input  [15:0] instruction, 
    input  [2:0]  imm_type, 
    output reg [15:0] imm_out 
);
    always @(*) begin
        case (imm_type)
            // I-type signed: addi, slti, lh, sh
            // immediate n?m ? [5:0]
            3'b001: begin
                imm_out = {{10{instruction[5]}}, instruction[5:0]};
            end

            // Branch offset: bneq, bgtz
            // i is signed, PC <- PC + i*2
            // -> sign-extend 6 bit and << 1
            3'b010,
            3'b011: begin
                imm_out = {{9{instruction[5]}}, instruction[5:0], 1'b0};
                //   ^ 9 bit sign + 6 bit + 1 bit shift = 16
            end

            // Jump: PC <- PC[15:13] || (addr<<1)
            // address take [11:0], no sign-extend
//            3'b100: begin
//                imm_out = {3'b000, instruction[11:0], 1'b0};
//            end

            // Default: No using immediate (Imm generation)
            default: begin
                imm_out = 16'b0;
            end
        endcase
    end
endmodule