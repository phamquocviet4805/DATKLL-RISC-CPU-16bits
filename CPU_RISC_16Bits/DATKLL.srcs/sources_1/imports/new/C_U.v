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
    output reg mem_read,memtoreg, reg_wrt, is_bnez, alu_src, mem_write, pc_sel, ei_set, di_clear, branch, push, pop,
    output reg [1:0] PCsel, bank_sel,
    output reg [2:0] immtype, 
    output reg [3:0] alu_op
);
always @(*)
begin
    case(opcode) 
    4'b0000:  // ALU0
    begin 
        alu_src = 1'b0;
        reg_wrt = 1'b1;
        mem_read = 1'b0;
        mem_write = 1'b0;
        memtoreg = 1'b1;
        is_bnez = 1'b0;
        alu_op = 3'b000;
        branch = 1'b0;   
        immtype = 3'b000;       
        PCsel = 2'b00;
        pop = 1'b0;
        push = 1'b0;
        pc_sel = 1'b0;
        ei_set = 1'b0;
        di_clear = 1'b0;
        bank_sel = 2'b00;
    end
    4'b0001:    // ALU1
    begin
        alu_src = 1'b0;
        reg_wrt = 1'b1;
        mem_read = 1'b0;
        mem_write = 1'b0;
        memtoreg = 1'b1;
        is_bnez = 1'b0;
        alu_op = 3'b001;
        branch = 1'b0;   
        immtype = 3'b000;   
        PCsel = 2'b00;
        pop = 1'b0;
        push = 1'b0;
        pc_sel = 1'b0;
        ei_set = 1'b0;
        di_clear = 1'b0;
        bank_sel = 2'b00;
    end
    4'b0010:    // SFT
    begin
        alu_src = 1'b0;
        reg_wrt = 1'b1;
        mem_read = 1'b0;
        mem_write = 1'b0;
        memtoreg = 1'b1;
        is_bnez = 1'b0;
        alu_op = 3'b010;
        branch = 1'b0;   
        immtype = 3'b000;    
        PCsel = 2'b00;
        pop = 1'b0;
        push = 1'b0;
        pc_sel = 1'b0;
        ei_set = 1'b0;
        di_clear = 1'b0;
        bank_sel = 2'b00;
    end
    4'b0011:    // ADDI
    begin
        alu_src = 1'b1;
        reg_wrt = 1'b1;
        mem_read = 1'b0;
        mem_write = 1'b0;
        memtoreg = 1'b1;
        is_bnez = 1'b0;
        alu_op = 3'b011;
        branch = 1'b0;   
        immtype = 3'b001;
        PCsel = 2'b00;
        pop = 1'b0;
        push = 1'b0;
        pc_sel = 1'b0;
        ei_set = 1'b0;
        di_clear = 1'b0;
        bank_sel = 2'b00;
    end
    4'b0100:    // SLTI
    begin
        alu_src = 1'b1;
        reg_wrt = 1'b1;
        mem_read = 1'b0;
        mem_write = 1'b0;
        memtoreg = 1'b1;
        is_bnez = 1'b0;
        alu_op = 3'b011;
        branch = 1'b0;   
        immtype = 3'b000;
        PCsel = 2'b00;
        pop = 1'b0;
        push = 1'b0;
        pc_sel = 1'b0;
        ei_set = 1'b0;
        di_clear = 1'b0;
        bank_sel = 2'b00;
    end
    4'b0101:  // BNEQ
    begin
        alu_src = 1'b0;
        reg_wrt = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        memtoreg = 1'b0;
        is_bnez = 1'b1;
        alu_op = 3'b100;
        branch = 1'b1;  
        immtype = 3'b000; 
        PCsel = 2'b10;
        pop = 1'b0;
        push = 1'b0;
        pc_sel = 1'b1;
        ei_set = 1'b0;
        di_clear = 1'b0;
        bank_sel = 2'b00;
    end
    4'b0110:  // BGTZ
    begin
        alu_src = 1'b0;
        reg_wrt = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        memtoreg = 1'b0;
        is_bnez = 1'b1; 
        alu_op = 3'b100;
        branch = 1'b1;  
        immtype = 3'b011; 
        PCsel = 2'b10;
        pop = 1'b0;
        push = 1'b0;
        pc_sel = 1'b1;
        ei_set = 1'b0;
        di_clear = 1'b0;
        bank_sel = 2'b00;
    end
    4'b0111:  // JUMP
    begin
        alu_src = 1'b0;
        reg_wrt = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        memtoreg = 1'b0;
        is_bnez = 1'b1;
        alu_op = 3'b101;
        branch = 1'b1;  
        immtype = 3'b001; 
        PCsel = 2'b10;
        pop = 1'b0;
        push = 1'b0;
        pc_sel = 1'b1;
        ei_set = 1'b0;
        di_clear = 1'b0;
        bank_sel = 2'b00;
    end
    4'b1000:  // LH
    begin
        alu_src = 1'b1;
        reg_wrt = 1'b1;
        mem_read = 1'b1;
        mem_write = 1'b0;
        memtoreg = 1'b0;
        is_bnez = 1'b0;
        alu_op = 3'b110;
        branch = 1'b0;  
        immtype = 3'b000; 
        PCsel = 2'b00;
        pop = 1'b0;
        push = 1'b0;
        pc_sel = 1'b0;
        ei_set = 1'b0;
        di_clear = 1'b0;
        bank_sel = 2'b00;
    end
    4'b1001:  // SH
    begin
        alu_src = 1'b1;
        reg_wrt = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b1;
        memtoreg = 1'b0;
        is_bnez = 1'b0;
        alu_op = 3'b110;
        branch = 1'b0;  
        immtype = 3'b000; 
        PCsel = 2'b00;
        pop = 1'b0;
        push = 1'b0;
        pc_sel = 1'b0;
        ei_set = 1'b0;
        di_clear = 1'b0;
        bank_sel = 2'b00;
    end
    4'b1010: // MFSR
    begin
        alu_src = 1'b1;
        reg_wrt = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b1;
        memtoreg = 1'b0;
        is_bnez = 1'b0;
        alu_op = 3'b111;
        branch = 1'b0;  
        immtype = 3'b000; 
        PCsel = 2'b00;
        pop = 1'b0;
        push = 1'b0;
        pc_sel = 1'b0;
        ei_set = 1'b0;
        di_clear = 1'b0;
        bank_sel = 2'b01;
    end 
        4'b1010: // MTSR
    begin
        alu_src = 1'b1;
        reg_wrt = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b1;
        memtoreg = 1'b0;
        is_bnez = 1'b0;
        alu_op = 3'b111;
        branch = 1'b0;  
        immtype = 3'b000; 
        PCsel = 2'b00;
        pop = 1'b0;
        push = 1'b0;
        pc_sel = 1'b0;
        ei_set = 1'b0;
        di_clear = 1'b0;
        bank_sel = 2'b10;
    end 
    4'b1110: // SYSTEM
    begin
        bank_sel = 2'b00;
        alu_op = 3'b000;
        case(funct3)
        3'b001:
            begin // RET
            alu_src = 1'b0;
            reg_wrt = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            memtoreg = 1'b0;
            is_bnez = 1'b0;
            branch = 1'b1;  
            immtype = 3'b111; 
            PCsel = 2'b01;
            pop = 1'b1;
            push = 1'b0;
            pc_sel = 1'b1;
            ei_set = 1'b0;
            di_clear = 1'b0;
        end
        3'b000: begin // NOP
            alu_src = 1'b0;
            reg_wrt = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            memtoreg = 1'b0;
            is_bnez = 1'b0;
            branch = 1'b0; 
            immtype = 3'b111; 
            PCsel = 2'b00;
            pop = 1'b0;
            push = 1'b0;
            ei_set = 1'b0;
            di_clear = 1'b0;
        end
        3'b010: begin // EI
            alu_src = 1'b0;
            reg_wrt = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            memtoreg = 1'b0;
            is_bnez = 1'b0;
            branch = 1'b0; 
            immtype = 3'b111; 
            PCsel = 2'b00;
            pop = 1'b0;
            push = 1'b0;
            pc_sel = 1'b0; 
            ei_set = 1'b1;
            di_clear = 1'b0;
        end
        3'b011: begin // DI
            alu_src = 1'b0;
            reg_wrt = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            memtoreg = 1'b0;
            is_bnez = 1'b0;
            branch = 1'b0; 
            immtype = 3'b111; 
            PCsel = 2'b00;
            pop = 1'b0;
            push = 1'b0;
            pc_sel = 1'b0; 
            ei_set = 1'b0;
            di_clear = 1'b1;
        end
        3'b100: begin // CALL
            alu_src   = 1'b0;
            reg_wrt   = 1'b0;
            mem_read  = 1'b0;
            mem_write = 1'b0;
            memtoreg  = 1'b0;
            is_bnez   = 1'b1;
            branch    = 1'b1;
            immtype   = 3'b001; 
            PCsel     = 2'b10;
            pop       = 1'b0;
            push      = 1'b1;
            pc_sel    = 1'b1;
            ei_set = 1'b0;
            di_clear = 1'b0;
        end
    endcase
    end
endcase
end
endmodule
