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
endmodule
