`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2025 03:03:58 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
input signed [15:0] A, B,
    input [4:0] alu_sel,          
    output reg [15:0] ALU_out,
    output reg [1:0] cmp
);
    reg [31:0] mult_result;
    reg [15:0] HI, LO;

always @(*) begin
    // Default Value
    ALU_out = 16'b0;
    cmp = 2'b00;
    HI = 16'b0;
    LO = 16'b0;
    mult_result = 32'b0;

    case (alu_sel)
        //ALU0: Unsigned
        5'b00000: ALU_out = A + B;                      // ADDU
        5'b00001: ALU_out = A - B;                      // SUBU
        5'b00010: begin                                 // MULTU
            mult_result = {16'b0, A} * {16'b0, B};
            HI = mult_result[31:16];
            LO = mult_result[15:0];
            ALU_out = LO;
        end
        5'b00011: begin                                 // DIVU
            if (B != 0) begin
                LO = A / B;
                HI = A % B;
            end
            ALU_out = LO;
        end
        5'b00100: ALU_out = A & B;                      // AND
        5'b00101: ALU_out = A | B;                      // OR
        5'b00110: ALU_out = ~(A | B);                   // NOR
        5'b00111: ALU_out = A ^ B;                      // XOR

        //ALU1: Signed
        5'b01000: ALU_out = $signed(A) + $signed(B);    // ADD
        5'b01001: ALU_out = $signed(A) - $signed(B);    // SUB
        5'b01010: begin                                 // MULT
            mult_result = $signed(A) * $signed(B);
            HI = mult_result[31:16];
            LO = mult_result[15:0];
            ALU_out = LO;
        end
        5'b01011: begin                                 // DIV
            if (B != 0) begin
                LO = $signed(A) / $signed(B);
                HI = $signed(A) % $signed(B);
            end
            ALU_out = LO;
        end
        5'b01100: ALU_out = ($signed(A) < $signed(B)) ? 16'd1 : 16'd0;  // SLT (signed)
        5'b01101: ALU_out = (A == B) ? 16'd1 : 16'd0;                   // SEQ
        5'b01110: ALU_out = (A < B) ? 16'd1 : 16'd0;                    // SLTU (unsigned)
        5'b01111: ALU_out = A;                                          // JR

        //ALU2: Shift / Rotate
        5'b10000: ALU_out = B >> A[3:0];                                // SHR
        5'b10001: ALU_out = B << A[3:0];                                // SHL
        5'b10010: ALU_out = (B >> A[3:0]) | (B << (16 - A[3:0]));       // ROR
        5'b10011: ALU_out = (B << A[3:0]) | (B >> (16 - A[3:0]));       // ROL

        //Comparation for branching
        5'b10100: cmp = (A == B) ? 2'b00 : 2'b01;                       // Equal
        5'b10101: cmp = (A > B)  ? 2'b01 : 2'b00;                       // Greater

        default: begin
            ALU_out = 16'b0;
            cmp = 2'b00;
        end
    endcase
end


endmodule
