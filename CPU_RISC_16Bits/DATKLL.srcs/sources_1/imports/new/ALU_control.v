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
/*

module ALU_control(
    input [3:0] alu_op,        // Control Unit
    input [2:0] funct3,        // instruction
    output reg [5:0] ALU_control   // ALU
);

    wire [6:0] control_sig;
    assign control_sig = {alu_op, funct3};

    always @(*) begin
        ALU_control = 6'b000000;
        case (alu_op)
        4'b0000: begin // ALU0 unsigned
            case (funct3)
            3'b000: ALU_control = 6'b000000;  // ADDU
            3'b001: ALU_control = 6'b000001;  // SUBU
            3'b010: ALU_control = 6'b000010;  // MULTU
            3'b011: ALU_control = 6'b000011;  // DIVU
            3'b100: ALU_control = 6'b000100;  // AND
            3'b101: ALU_control = 6'b000101;  // OR
            3'b110: ALU_control = 6'b000110;  // NOR
            3'b111: ALU_control = 6'b000111;  // XOR
            default: ALU_control = 6'b111111;
            endcase
        end
        4'b0001: begin //ALU1: Signed
            case (funct3)
            3'b000: ALU_control = 6'b001000;  // ADD
            3'b001: ALU_control = 6'b001001;  // SUB
            3'b010: ALU_control = 6'b001010;  // MULT
            3'b011: ALU_control = 6'b001011;  // DIV
            3'b100: ALU_control = 6'b001100;  // SLT
            3'b101: ALU_control = 6'b001101;  // SEQ
            3'b110: ALU_control = 6'b001110;  // SLTU
            3'b111: ALU_control = 6'b001111;  // JR
            default: ALU_control = 6'b111111;
            endcase
        end
        4'b0010: begin //Shift / Rotate
            case (funct3)    
            3'b000: ALU_control = 6'b010000;  // SHR
            3'b001: ALU_control = 6'b010001;  // SHL
            3'b010: ALU_control = 6'b010010;  // ROR
            3'b011: ALU_control = 6'b010011;  // ROL
////            3'b100: ALU_control = 6'b010100;  
////            3'b101: ALU_control = 6'b010101;  
////            3'b110: ALU_control = 6'b010110;  
////            3'b111: ALU_control = 6'b010111;  
            default: ALU_control = 6'b111111;
            endcase
        end
        4'b0011: begin //Immidiate        
            ALU_control = 6'b001000;  // ADDI
        end
        
        4'b0100: begin
            ALU_control = 6'b001100;  // SLTI
        end   
//        4'b0101: begin  //Branch Compare           
//            ALU_control = 6'b011000;  // BNEQ
//        end
//        4'b0110: begin
//            ALU_control = 6'b011001;  // BGTZ
//        end
//        4'b0111: begin  //Jump           
//            ALU_control = 6'b011010;    // jump
//        end
        4'b1000: begin //Memory           
            ALU_control = 6'b011011;    // lh - sh
        end
//        4'b1001: begin //MFSR - MTSR
//            ALU_control = 6'b000000;    
//        end
        default: ALU_control = 6'b111111;  // Defautl: ADDU
        endcase
    end
endmodule*/

module ALU_control(
    input [1:0] alu_op,        // t? Control Unit
    input [2:0] funct3,        // t? instruction
    output reg [4:0] ALU_control   // xu?t sang ALU
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

            //ALU2: Shift / Rotate
            5'b10_000: ALU_control = 5'b10000;  // SHR
            5'b10_001: ALU_control = 5'b10001;  // SHL
            5'b10_010: ALU_control = 5'b10010;  // ROR
            5'b10_011: ALU_control = 5'b10011;  // ROL

            //Branch Compare
            5'b11_000: ALU_control = 5'b10100;  // EQ (BEQZ)
            5'b11_001: ALU_control = 5'b10101;  // LT
            5'b11_010: ALU_control = 5'b10110;  // GT

            default:   ALU_control = 5'b00000;  // M?c ??nh: ADDU
        endcase
    end
endmodule