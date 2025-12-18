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
    
//initial begin
//    $readmemh("program.hex", imem);
//end
initial begin

//    imem[0]  = 8'b0011_0000; // 0x30  word0 hi  (addi r1, r0, 5)
//    imem[1]  = 8'b0100_0101; // 0x45  word0 lo

//    imem[2]  = 8'b0011_0000; // 0x30  word1 hi  (addi r2, r0, 3)
//    imem[3]  = 8'b1000_0011; // 0x83  word1 lo    

//    imem[4]  = 8'b0000_0010; // 0x02  word2 hi  (addu r3, r1, r2)
//    imem[5]  = 8'b1001_1000; // 0x98  word2 lo

//    imem[6]  = 8'b0010_0110; // 0x26  word3 hi  (shl r4, r3, r2)
//    imem[7]  = 8'b1010_0001; // 0xA1  word3 lo

//    imem[8]  = 8'b0000_0010; // 0x02  word4 hi  (multu r1, r2)
//    imem[9]  = 8'b1000_0010; // 0x82  word4 lo

//    imem[10] = 8'b1010_0000; // 0xA0  word5 hi  (mflo -> r5)
//    imem[11] = 8'b0010_1101; // 0x2D  word5 lo

//    imem[12] = 8'b1010_0000; // 0xA0  word6 hi  (mfhi -> r6)
//    imem[13] = 8'b0011_0100; // 0x34  word6 lo

//    imem[14] = 8'b1011_0001; // 0xB1  word7 hi  (mtra r5 -> RA)
//    imem[15] = 8'b0100_0010; // 0x42  word7 lo

//    imem[16] = 8'b1011_0001; // 0xB1  word8 hi  (mtat r6 -> AT)
//    imem[17] = 8'b1000_0011; // 0x83  word8 lo

//    imem[18] = 8'b1010_0000; // 0xA0  word9 hi  (mfra -> r7)
//    imem[19] = 8'b0011_1010; // 0x3A  word9 lo

//    imem[20] = 8'b1010_0000; // 0xA0  word10 hi (mfat -> r4)
//    imem[21] = 8'b0010_0011; // 0x23  word10 lo

//    imem[22] = 8'b1001_0000; // 0x90  word11 hi (sh r3, 0(r0))
//    imem[23] = 8'b1100_0000; // 0xC0  word11 lo

//    imem[24] = 8'b1000_0001; // 0x81  word12 hi (lh r6, 0(r0))
//    imem[25] = 8'b1000_0000; // 0x80  word12 lo

//    imem[26] = 8'b0101_1100; // 0x5C  word13 hi (bneq r6, r3, 1)
//    imem[27] = 8'b1100_0001; // 0xC1  word13 lo

//    imem[28] = 8'b0011_0001; // 0x31  word14 hi (addi r7, r0, 1)
//    imem[29] = 8'b1100_0001; // 0xC1  word14 lo

//    imem[30] = 8'b0110_1110; // 0x6E  word15 hi (bgtz r7, 1)
//    imem[31] = 8'b0000_0001; // 0x01  word15 lo

//    imem[32] = 8'b0011_0001; // 0x31  word16 hi (addi r7, r0, 2)  ; skipped by bgtz imem[30]
//    imem[33] = 8'b1100_0010; // 0xC2  word16 lo

//    imem[34] = 8'b0011_0001; // 0x31  word17 hi (addi r7, r0, 3)
//    imem[35] = 8'b1100_0011; // 0xC3  word17 lo

//    imem[36] = 8'b0111_0000; // 0x70  word18 hi (j 20)
//    imem[37] = 8'b0001_0100; // 0x14  word18 lo

//    imem[38] = 8'b0011_0000; // 0x30  word19 hi (addi r1, r0, 9)  ; skipped by jump imem[36]
//    imem[39] = 8'b0100_1001; // 0x49  word19 lo

//    imem[40] = 8'b0011_0000; // 0x30  word20 hi (addi r1, r0, 4)
//    imem[41] = 8'b0100_0100; // 0x44  word20 lo

//    imem[42] = 8'b1111_0000; // 0xF0  word21 hi (hlt)
//    imem[43] = 8'b0000_0000; // 0x00  word21 lo

// =====================================================

imem[0]  = 8'b0011_0000; // 0x30 hi         addi r1, r0, 3
imem[1]  = 8'b0100_0011; // 0x43 lo

imem[2]  = 8'b0011_0000; // 0x30 hi         addi r2, r0, -8  
imem[3]  = 8'b1011_1000; // 0xB8 lo

imem[4]  = 8'b0000_0010; // 0x02 hi         shra r3, r2, r1
imem[5]  = 8'b1001_1100; // 0x9C lo         EXPECT: r3 = 0xFFFF

imem[6]  = 8'b1101_0001; // 0xD1 hi         lui r4, 1
imem[7]  = 8'b0000_0001; // 0x01 lo

imem[8]  = 8'b0000_0001; // 0x01 hi         bitrev r5, r4 
imem[9]  = 8'b0010_1101; // 0x2D lo         EXPECT: bitrev(0x0400)=0x0020

imem[10] = 8'b0000_0001; // 0x01 hi         clz r6, r4 
imem[11] = 8'b0011_0110; // 0x36 lo         EXPECT: clz(0x0400)=5

imem[12] = 8'b0000_0001; // 0x01 hi         ctz r7, r4 
imem[13] = 8'b0011_1111; // 0x3F lo         EXPECT: ctz(0x0400)=1

imem[14] = 8'b1101_0000; // 0xD0 hi         lui r2, 63
imem[15] = 8'b1011_1111; // 0xBF lo

imem[16] = 8'b1110_0100; // 0xE4 hi         ori r2, r2, 11
imem[17] = 8'b1000_1011; // 0x8B lo

imem[18] = 8'b0000_0000; // 0x00 hi         clz r6, r2 
imem[19] = 8'b1011_0110; // 0xB6 lo

imem[20] = 8'b0000_0000; // 0x00 hi         ctz r7, r2
imem[21] = 8'b1011_1111; // 0xBF lo

imem[22] = 8'b1111_0000; // 0xF0 hi         (hlt)
imem[23] = 8'b0000_0000; // 0x00 lo
end

    integer i;
    
    assign instruction = {imem[address],imem[address+1]};
    assign opcode = instruction[15:12];

    // Seperate opcode by spec
    wire is_r_type = (opcode == 4'b0000 || // ALU0
                      opcode == 4'b0001 || // ALU1
                      opcode == 4'b0010 || // ALU2
                      opcode == 4'b1010 || // MFSR
                      opcode == 4'b1011 || // MTSR
                      opcode == 4'b1100);  // FP16
              

    wire is_i_type = (opcode == 4'b0011 || // ADDI
                      opcode == 4'b0100 || // SLTI
                      opcode == 4'b0101 || // BNEQ
                      opcode == 4'b0110 || // BGTZ
                      opcode == 4'b1000 || // LH
                      opcode == 4'b1001 || // SH
                      opcode == 4'b1101 || // LUI
                      opcode == 4'b1110);  // ORI

    wire is_j_type = (opcode == 4'b0111 || // JUMP
                      opcode == 4'b1111);  // HLT

    // rs, rt, rd, funct3 theo format:
    // [15:12] opcode
    // [11:9]  rs
    // [8:6]   rt
    // [5:3]   rd (only R-type)
    // [2:0]   funct3 (R-type, SYS-type)
    assign rs     = (is_r_type || is_i_type) ? instruction[11:9] : 3'b000;
    assign rt     = (is_r_type || is_i_type) ? instruction[8:6]  : 3'b000;
    assign rd     = (is_r_type)              ? instruction[5:3]  : 3'b000;
    assign funct3 = (is_r_type || opcode == 4'b1110) ? instruction[2:0] : 3'b000;
endmodule
