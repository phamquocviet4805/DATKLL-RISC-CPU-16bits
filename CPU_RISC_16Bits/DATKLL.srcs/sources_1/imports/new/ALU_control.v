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
    input [3:0] alu_op,        // Control Unit
    input [2:0] funct3,        // instruction
    output reg [5:0] ALU_control   // ALU
);

    wire [6:0] control_sig;
    assign control_sig = {alu_op, funct3};

    always @(*) begin
        case (control_sig)
            //ALU0: Unsigned
            7'b0000_000: ALU_control = 6'b000000;  // ADDU
            7'b0000_001: ALU_control = 6'b000001;  // SUBU
            7'b0000_010: ALU_control = 6'b000010;  // MULTU
            7'b0000_011: ALU_control = 6'b000011;  // DIVU
            7'b0000_100: ALU_control = 6'b000100;  // AND
            7'b0000_101: ALU_control = 6'b000101;  // OR
            7'b0000_110: ALU_control = 6'b000110;  // NOR
            7'b0000_111: ALU_control = 6'b000111;  // XOR
            
            //ALU1: Signed
            7'b0001_000: ALU_control = 6'b001000;  // ADD
            7'b0001_001: ALU_control = 6'b001001;  // SUB
            7'b0001_010: ALU_control = 6'b001010;  // MULT
            7'b0001_011: ALU_control = 6'b001011;  // DIV
            7'b0001_100: ALU_control = 6'b001100;  // SLT
            7'b0001_101: ALU_control = 6'b001101;  // SEQ
            7'b0001_110: ALU_control = 6'b001110;  // SLTU
            7'b0001_111: ALU_control = 6'b001111;  // JR

            //Shift / Rotate
            7'b0010_000: ALU_control = 6'b010000;  // SHR
            7'b0010_001: ALU_control = 6'b010001;  // SHL
            7'b0010_010: ALU_control = 6'b010010;  // ROR
            7'b0010_011: ALU_control = 6'b010011;  // ROL
//            7'b0010_100: ALU_control = 6'b010100;  
//            7'b0010_101: ALU_control = 6'b010101;  
//            7'b0010_110: ALU_control = 6'b010110;  
//            7'b0010_111: ALU_control = 6'b010111;  

            //Immidiate
            7'b0011_000: ALU_control = 6'b001000;  // ADDI

            7'b0100_000: ALU_control = 6'b001100;  // SLTI
            
            //Branch Compare
            7'b0101_000: ALU_control = 6'b011000;  // BNEQ
            7'b0110_000: ALU_control = 6'b011001;  // BGTZ
            
            //Jump
            7'b0111_000: ALU_control = 6'b011010;    // jump
            
            //Memory
            7'b1000_000: ALU_control = 6'b011011;    // lh - sh
            
            //MFSR - MTSR
            7'b1001_000: ALU_control = 6'b011100;    
            

            default:   ALU_control = 6'b000000;  // Defautl: ADDU
        endcase
    end
endmodule
