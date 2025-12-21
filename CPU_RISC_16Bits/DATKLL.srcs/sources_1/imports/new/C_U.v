`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2025 10:21:22 PM
// Design Name: 
// Module Name: C_U
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

module C_U( 
    input [3:0] opcode, input [2:0] funct3,
    output reg mem_read, memtoreg, reg_wrt, alu_src, mem_write, branch, reg_dst, hold_hlt, jump,
    output reg [2:0] immtype, mfsr_sel,
    output reg [3:0] alu_op,
    output reg fp_signal,
    output reg special_to_reg, ra_signal, at_signal, hi_signal, lo_signal, hi_from_alu_signal, lo_from_alu_signal
);

always @(*) begin
    // ======= Default values =======
    alu_src            = 1'b0;
    reg_wrt            = 1'b0;
    mem_read           = 1'b0;
    mem_write          = 1'b0;
    memtoreg           = 1'b1;   // 1: from ALU, 0: from MEM (when special_to_reg = 0)
    alu_op             = 4'b0000;
    jump               = 1'b0;
    branch             = 1'b0;   
    immtype            = 3'b000;       
    reg_dst            = 1'b0;   // 0: rt, 1: rd
    hold_hlt           = 1'b0;
    special_to_reg     = 1'b0;
    mfsr_sel           = 3'b000;

    ra_signal          = 1'b0;
    at_signal          = 1'b0;
    hi_signal          = 1'b0;
    lo_signal          = 1'b0;
    hi_from_alu_signal = 1'b0;
    lo_from_alu_signal = 1'b0;
    
    fp_signal          = 1'b0;

    // ======= Decode by opcode =======
    case (opcode)

        // 0000: ALU0 (unsigned R-type)
        4'b0000: begin
            reg_wrt = 1'b1;
            reg_dst = 1'b1;      // write to rd
            alu_op  = 4'b0000;

            // multu / divu write HI/LO from ALU
            if (funct3 == 3'b010 || funct3 == 3'b011) begin
                hi_from_alu_signal = 1'b1;
                lo_from_alu_signal = 1'b1;
                reg_wrt = 1'b0;
            end
        end

        // 0001: ALU1 (signed R-type)
        4'b0001: begin
            reg_wrt = 1'b1;
            reg_dst = 1'b1;      // write to rd
            alu_op  = 4'b0001;

            // mult / div write HI/LO from ALU
            if (funct3 == 3'b010 || funct3 == 3'b011) begin
                hi_from_alu_signal = 1'b1;
                lo_from_alu_signal = 1'b1;
                reg_wrt = 1'b0;
            end
        end

        // 0010: Shift / Rotate (R-type)
        4'b0010: begin
            reg_wrt = 1'b1;
            reg_dst = 1'b1;      // rd
            alu_op  = 4'b0010;
        end

        // 0011: ADDI (I-type)
        4'b0011: begin
            alu_src = 1'b1;      // use immediate
            reg_wrt = 1'b1;
            reg_dst = 1'b0;      // rt
            memtoreg = 1'b1;     // from ALU
            alu_op  = 4'b0011;
            immtype = 3'b001;    // signed immediate 
        end

        // 0100: SLTI (I-type)
        4'b0100: begin
            alu_src = 1'b1;
            reg_wrt = 1'b1;
            reg_dst = 1'b0;
            memtoreg = 1'b1;     // from ALU
            alu_op  = 4'b0100;
            immtype = 3'b001;    // signed immediate
        end

        // 0101: BNEQ (I-type branch)
        4'b0101: begin
            alu_src = 1'b0;      // compare rs, rt
            reg_wrt = 1'b0;
            mem_read  = 1'b0;
            mem_write = 1'b0;
            memtoreg  = 1'b0;
            alu_op    = 4'b0101; // != comparison
            branch    = 1'b1;
            immtype   = 3'b010;  // branch offset
        end

        // 0110: BGTZ (I-type branch)
        4'b0110: begin
            alu_src = 1'b0;      // A = rs, B = 0 (handled in datapath)
            reg_wrt = 1'b0;
            mem_read  = 1'b0;
            mem_write = 1'b0;
            memtoreg  = 1'b0;
            alu_op    = 4'b0110; // > comparison
            branch    = 1'b1;
            immtype   = 3'b011;  // custom offset type
        end

        // 0111: JUMP (J-type)
        4'b0111: begin
            jump    = 1'b1;
            reg_wrt = 1'b0;
            mem_read  = 1'b0;
            mem_write = 1'b0;
            memtoreg  = 1'b0;
        end

        // 1000: LH (I-type)
        4'b1000: begin
            alu_src   = 1'b1;    // rs + imm
            reg_wrt   = 1'b1;
            reg_dst   = 1'b0;    // rt
            mem_read  = 1'b1;
            mem_write = 1'b0;
            memtoreg  = 1'b0;    // WB from MEM
            alu_op    = 4'b1000; // address calculation for LH/SH
            immtype   = 3'b001;  // address immediate
        end

        // 1001: SH (I-type)
        4'b1001: begin
            alu_src   = 1'b1;
            reg_wrt   = 1'b0;
            mem_read  = 1'b0;
            mem_write = 1'b1;
            memtoreg  = 1'b0;
            alu_op    = 4'b1000; // shared with LH/SH
            immtype   = 3'b001;
        end

        // 1010: MFSR (special R-type: rd <- special register)
        4'b1010: begin
            reg_wrt        = 1'b1;
            reg_dst        = 1'b1;      // rd
            special_to_reg = 1'b1;      // write-back from special register
            mfsr_sel       = funct3;    // select ZERO/PC/RA/AT/HI/LO
            mem_read       = 1'b0;
            mem_write      = 1'b0;
        end

        // 1011: MTSR (special R-type: special register <- rt)
        4'b1011: begin
            reg_wrt   = 1'b0;     // no write to GPR
            mem_read  = 1'b0;
            mem_write = 1'b0;
            case (funct3)
                3'b010: ra_signal = 1'b1; // mtra
                3'b011: at_signal = 1'b1; // mtat
                3'b100: hi_signal = 1'b1; // mthi
                3'b101: lo_signal = 1'b1; // mtlo
                default: ;
            endcase
        end
        
        // 1100: FP16 (Foating Point)
        4'b1100: begin
            reg_wrt = 1'b1;
            reg_dst = 1'b1;      // rd  
            fp_signal = 1'b1;
        end
        
        // 1101: LUI (Load upper Imm)
        4'b1101: begin
            reg_wrt = 1'b1;
            reg_dst = 1'b0;      // rt
            immtype = 3'b100;
            alu_src   = 1'b1;
        end
        
        // 1110: Or Imm
        4'b1110: begin
            reg_wrt = 1'b1;
            reg_dst = 1'b0;      // rt
            immtype = 3'b101;
            alu_src   = 1'b1;
        end

        // 1111: HLT
        4'b1111: begin
            hold_hlt = 1'b1;
        end

        default: begin
            // Keep default values
        end
    endcase
end

endmodule

