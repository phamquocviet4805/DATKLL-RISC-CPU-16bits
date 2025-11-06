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
    input [5:0] alu_sel,          
    output reg [15:0] ALU_out, hi_from_alu, lo_from_alu,
    output reg cmp
);
reg [31:0] mult_result;

always @(*) begin
    // Default Value
    ALU_out = 16'b0;
    cmp = 1'b0;


    case (alu_sel)
        //ALU0: Unsigned
        6'b000000: ALU_out = A + B;                      // ADDU
        6'b000001: ALU_out = A - B;                      // SUBU
        6'b000010: begin                                 // MULTU
             mult_result = A * B;
             hi_from_alu = mult_result[31:16];
             lo_from_alu = mult_result[15:0];
        end
        6'b000011: begin                                 // DIVU
            if (B == 16'h0000) begin
                  hi_from_alu = 16'h0000;
                  lo_from_alu = 16'h0000;
            end else begin
                  hi_from_alu = A % B;
                  lo_from_alu = A / B;
            end
        end
        6'b000100: ALU_out = A & B;                      // AND
        6'b000101: ALU_out = A | B;                      // OR
        6'b000110: ALU_out = ~(A | B);                   // NOR
        6'b000111: ALU_out = A ^ B;                      // XOR

        //ALU1: Signed
        6'b001000: ALU_out = $signed(A) + $signed(B);    // ADD
        6'b001001: ALU_out = $signed(A) - $signed(B);    // SUB
        6'b001010: begin                                 // MULT
               mult_result = $signed(A) * $signed(B);
               hi_from_alu = mult_result[31:16];
               lo_from_alu = mult_result[15:0];
        end
        6'b001011: begin                                 // DIV
              if (B == 16'h0000) begin
                  hi_from_alu = 16'h0000;
                  lo_from_alu = 16'h0000;
              end else begin
                  hi_from_alu = $signed(A) % $signed(B);
                  lo_from_alu = $signed(A) / $signed(B);
              end
        end
        6'b001100: ALU_out = ($signed(A) < $signed(B)) ? 16'd1 : 16'd0;  // SLT (signed)
        6'b001101: ALU_out = (A == B) ? 16'd1 : 16'd0;                   // SEQ
        6'b001110: ALU_out = (A < B) ? 16'd1 : 16'd0;                    // SLTU (unsigned)
        6'b001111: ALU_out = A;                                          // JR

        //Shift / Rotate
        6'b010000: ALU_out = B >> A[3:0];                                // SHR
        6'b010001: ALU_out = B << A[3:0];                                // SHL
        6'b010010: ALU_out = (B >> A[3:0]) | (B << (16 - A[3:0]));       // ROR
        6'b010011: ALU_out = (B << A[3:0]) | (B >> (16 - A[3:0]));       // ROL

        //Comparation for branching
        6'b011000: cmp = (A == B) ? 1'b0 : 1'b1;                       // Not Equal
        6'b011001: cmp = (A > B)  ? 1'b1 : 1'b0;                       // Greater than

        //Memory instruction
        6'b011011: ALU_out = (A & 16'hFFFE) + (B << 1);                  //lh - sh

        default: begin
            ALU_out = A | B; 
            cmp = 1'b0;
        end
    endcase
end


endmodule
