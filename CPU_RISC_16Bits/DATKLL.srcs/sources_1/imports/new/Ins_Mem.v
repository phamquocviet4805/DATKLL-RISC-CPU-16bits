`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2025 02:35:44 PM
// Design Name: 
// Module Name: Ins_Mem
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

// INSTRUCTION MEMORY + DECODE

module Ins_Mem(address,opcode,rd,rs,rt,funct3,instruction);
    input [15:0] address;
    output [3:0] opcode;
    output [2:0] rd;
    output [2:0] rs;
    output [2:0] rt;
    output [2:0] funct3;
    output [15:0] instruction; 

    wire [2:0] instr_type;
    reg [7:0] imem[0:2047];
    integer i;
    
    assign instruction = {imem[address],imem[address+1]};
    assign opcode = instruction[15:12];

    // phân lo?i opcode theo spec
    wire is_r_type = (opcode == 4'b0000 || // ALU0
                      opcode == 4'b0001 || // ALU1
                      opcode == 4'b0010 || // ALU2
                      opcode == 4'b1010 || // MFSR
                      opcode == 4'b1011 || // MTSR
                      opcode == 4'b1110);  // SYS-type (n?u có)

    wire is_i_type = (opcode == 4'b0011 || // ADDI
                      opcode == 4'b0100 || // SLTI
                      opcode == 4'b0101 || // BNEQ
                      opcode == 4'b0110 || // BGTZ
                      opcode == 4'b1000 || // LH
                      opcode == 4'b1001);  // SH

    wire is_j_type = (opcode == 4'b0111 || // JUMP
                      opcode == 4'b1111);  // HLT

    // rs, rt, rd, funct3 theo format:
    // [15:12] opcode
    // [11:9]  rs
    // [8:6]   rt
    // [5:3]   rd (ch? R-type)
    // [2:0]   funct3 (R-type, SYS-type)
    assign rs     = (is_r_type || is_i_type) ? instruction[11:9] : 3'b000;
    assign rt     = (is_r_type || is_i_type) ? instruction[8:6]  : 3'b000;
    assign rd     = (is_r_type)              ? instruction[5:3]  : 3'b000;
    assign funct3 = (is_r_type || opcode == 4'b1110) ? instruction[2:0] : 3'b000;
endmodule
