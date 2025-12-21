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
    output reg mem_read, memtoreg, reg_wrt, alu_src, mem_write, branch, push, pop, reg_dst, hold_hlt, jump,
    output reg [2:0] immtype, 
    output reg [3:0] alu_op
);
always @(*)
begin
    alu_src = 1'b0;
    reg_wrt = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    memtoreg = 1'b1;
    alu_op = 4'b0000;
    jump = 1'b0;
    branch = 1'b0;   
    immtype = 3'b000;       
    pop = 1'b0;
    push = 1'b0;
    reg_dst = 1'b0;
    hold_hlt = 1'b0;
    case(opcode) 
    4'b0000:  // ALU0
    begin 
        reg_wrt = 1'b1;
        reg_dst = 1'b1; 
    end
    4'b0001:    // ALU1
    begin
//        alu_src = 1'b0;
//        reg_wrt = 1'b1;
//        mem_read = 1'b0;
//        mem_write = 1'b0;
//        memtoreg = 1'b1;
//        alu_op = 4'b0001;
//        branch = 1'b0;   
//        immtype = 3'b000;   
//        PCsel = 2'b00;
//        pop = 1'b0;
//        push = 1'b0;
//        pc_sel = 1'b0;
    end
    4'b0010:    // SFT
    begin
//        alu_src = 1'b0;
//        reg_wrt = 1'b1;
//        mem_read = 1'b0;
//        mem_write = 1'b0;
//        memtoreg = 1'b1;
//        alu_op = 4'b0010;
//        branch = 1'b0;   
//        immtype = 3'b000;    
//        PCsel = 2'b00;
//        pop = 1'b0;
//        push = 1'b0;
//        pc_sel = 1'b0;
    end
    4'b0011:    // ADDI
    begin
//        alu_src = 1'b1;
//        reg_wrt = 1'b1;
//        mem_read = 1'b0;
//        mem_write = 1'b0;
//        memtoreg = 1'b1;
//        alu_op = 4'b0011;
//        branch = 1'b0;   
//        immtype = 3'b001;
//        PCsel = 2'b00;
//        pop = 1'b0;
//        push = 1'b0;
//        pc_sel = 1'b0;
    end
    4'b0100:    // SLTI
    begin
//        alu_src = 1'b1;
//        reg_wrt = 1'b1;
//        mem_read = 1'b0;
//        mem_write = 1'b0;
//        memtoreg = 1'b1;
//        alu_op = 4'b0100;
//        branch = 1'b0;   
//        immtype = 3'b000;
//        PCsel = 2'b00;
//        pop = 1'b0;
//        push = 1'b0;
//        pc_sel = 1'b0;
    end
    4'b0101:  // BNEQ
    begin
//        alu_src = 1'b0;
//        reg_wrt = 1'b0;
//        mem_read = 1'b0;
//        mem_write = 1'b0;
//        memtoreg = 1'b0;
//        alu_op = 4'b0101;
//        branch = 1'b1;  
//        immtype = 3'b000; 
//        PCsel = 2'b10;
//        pop = 1'b0;
//        push = 1'b0;
//        pc_sel = 1'b1;
    end
    4'b0110:  // BGTZ
    begin
//        alu_src = 1'b0;
//        reg_wrt = 1'b0;
//        mem_read = 1'b0;
//        mem_write = 1'b0;
//        memtoreg = 1'b0;
//        alu_op = 4'b0110;
//        branch = 1'b1;  
//        immtype = 3'b011; 
//        PCsel = 2'b10;
//        pop = 1'b0;
//        push = 1'b0;
//        pc_sel = 1'b1;
    end
    4'b0111:  // JUMP
    begin
//        alu_src = 1'b0;
//        reg_wrt = 1'b0;
//        mem_read = 1'b0;
//        mem_write = 1'b0;
//        memtoreg = 1'b0;
//        alu_op = 4'b0111;
//        branch = 1'b1;  
//        immtype = 3'b001; 
//        PCsel = 2'b10;
//        pop = 1'b0;
//        push = 1'b0;
//        pc_sel = 1'b1;
    end
    4'b1000:  // LH
    begin
//        alu_src = 1'b1;
//        reg_wrt = 1'b1;
//        mem_read = 1'b1;
//        mem_write = 1'b0;
//        memtoreg = 1'b0;
//        alu_op = 4'b1000;
//        branch = 1'b0;  
//        immtype = 3'b000; 
//        PCsel = 2'b00;
//        pop = 1'b0;
//        push = 1'b0;
    end
    4'b1001:  // SH
    begin
//        alu_src = 1'b1;
//        reg_wrt = 1'b0;
//        mem_read = 1'b0;
//        mem_write = 1'b1;
//        memtoreg = 1'b0;
//        alu_op = 4'b1000;
//        branch = 1'b0;  
//        immtype = 3'b000; 
//        PCsel = 2'b00;
//        pop = 1'b0;
//        push = 1'b0;
    end
    4'b1010: // MFSR
    begin
//        alu_src = 1'b1;
//        reg_wrt = 1'b0;
//        mem_read = 1'b0;
//        mem_write = 1'b1;
//        memtoreg = 1'b0;
//        alu_op = 4'b1001;
//        branch = 1'b0;  
//        immtype = 3'b000; 
//        PCsel = 2'b00;
//        pop = 1'b0;
//        push = 1'b0;
    end 
        4'b1010: // MTSR
    begin
//        alu_src = 1'b1;
//        reg_wrt = 1'b0;
//        mem_read = 1'b0;
//        mem_write = 1'b1;
//        memtoreg = 1'b0;
//        alu_op = 4'b1001;
//        branch = 1'b0;  
//        immtype = 3'b000; 
//        PCsel = 2'b00;
//        pop = 1'b0;
//        push = 1'b0;
    end 
        4'b1010: // HLT
    begin
        hold_hlt = 1'b1;
    end
    endcase

end
endmodule
