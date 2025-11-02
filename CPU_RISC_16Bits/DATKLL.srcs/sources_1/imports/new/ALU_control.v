`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2025 09:49:56 AM
// Design Name: 
// Module Name: ALU_control
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


module ALU_control(
    input [1:0] alu_op,        // Control Unit
    input [2:0] funct3,        // instruction
    output reg [4:0] ALU_control   // ALU
);

    wire [4:0] control_sig;
    assign control_sig = {alu_op, funct3};

    always @(*) begin
        case (control_sig)
            //ALU0: Unsigned
            5'b00_000: ALU_control = 5'b00000;  // ADDU
            5'b00_001: ALU_control = 5'b00001;  // SUBU
            5'b00_010: ALU_control = 5'b00010;  // MULTU
            5'b00_011: ALU_control = 5'b00011;  // DIVU
            5'b00_100: ALU_control = 5'b00100;  // AND
            5'b00_101: ALU_control = 5'b00101;  // OR
            5'b00_110: ALU_control = 5'b00110;  // NOR
            5'b00_111: ALU_control = 5'b00111;  // XOR

            //ALU1: Signed
            5'b01_000: ALU_control = 5'b01000;  // ADD
            5'b01_001: ALU_control = 5'b01001;  // SUB
            5'b01_010: ALU_control = 5'b01010;  // MULT
            5'b01_011: ALU_control = 5'b01011;  // DIV
            5'b01_100: ALU_control = 5'b01100;  // SLT
            5'b01_101: ALU_control = 5'b01101;  // SEQ
            5'b01_110: ALU_control = 5'b01110;  // SLTU
            5'b01_111: ALU_control = 5'b01111;  // JR

            //Shift / Rotate
            5'b10_000: ALU_control = 5'b10000;  // SHR
            5'b10_001: ALU_control = 5'b10001;  // SHL
            5'b10_010: ALU_control = 5'b10010;  // ROR
            5'b10_011: ALU_control = 5'b10011;  // ROL
//            5'b10_100: ALU_control = 5'10100;  // SHR
//            5'b10_101: ALU_control = 5'10101;  // SHL
//            5'b10_110: ALU_control = 5'b10110;  // ROR
//            5'b10_111: ALU_control = 5'b10111;  // ROL

            //Branch Compare
            5'b11_000: ALU_control = 5'b10100;  // BNEQ
            5'b11_001: ALU_control = 5'b10101;  // GT

            default:   ALU_control = 5'b00000;  // Defautl: ADDU
        endcase
    end
endmodule
