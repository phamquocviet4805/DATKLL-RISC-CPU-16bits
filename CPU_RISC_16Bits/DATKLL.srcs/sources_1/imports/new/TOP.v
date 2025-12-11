`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2025 11:07:04 AM
// Design Name: 
// Module Name: TOP
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

module TOP( 
    input clk, reset, interrupt_pending,
    output [15:0] r0, r1, r2, r3, r4, r5, r6, r7,
    input [1:0] mux_clk
);

localparam CONST = 2;
wire is_bnez, mem_read_en, branch_out;
wire /*clk_1hz ,clk_4hz,clk_100hz,*/ clk_8hz;
wire reg_wrt, mem_write_en, push, pop, pc_sel, alu_src;
wire mux_pc_sel, branch, memtoreg, reg_dst, hold_hlt, jump;
wire ra_signal, at_signal, hi_signal, lo_signal, special_to_reg, hi_from_alu_signal, lo_from_alu_signal;
wire cmp;
wire [2:0] rs, rt, rd, rd_raw, funct3, immtype, mfsr_sel;
wire [3:0] opcode, alu_op;
wire [5:0] alu_sel;
wire [15:0] instruction;
wire [15:0] ALU_out, imm_out, outmux, read_data, mfsr_data, wb_mux_out, hi_from_alu_data, lo_from_alu_data;
wire [15:0] data_reg, readA_out, readB_out;
wire [15:0] pc_out, pc, pc_plus2, next_pc, jump_out, pc_branch;

// ========================= PROGRAM COUNTER =========================
program_counter ic11 (
    .clk(clk),
    .reset(reset),
    .pc_in(next_pc),
    .pc_out(pc),
    .hold_hlt(hold_hlt));

// ========================= INSTRUCTION MEMOORY =========================
Ins_Mem ic1 (
    .address(pc),
    .opcode(opcode),
    .rd(rd_raw),
    .rs(rs),
    .rt(rt),
    .funct3(funct3),
    .instruction(instruction));
    
// ========================= REGISTER FILE =========================
reg_file ic2 (
    .reg_wrt(reg_wrt),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .readA_out(readA_out),
    .readB_out(readB_out),
    .data(data_reg),
    .r0(r0),
    .r1(r1),
    .r2(r2),
    .r3(r3),
    .r4(r4),
    .r5(r5),
    .r6(r6),
    .r7(r7),
    .clk(clk));

// ========================= ALU MUX =========================
MUX_alu_2_1 ic3 (
    .B(readB_out),
    .imm(imm_out),
    .alu_src(alu_src),
    .outmux(outmux));
    
// ========================= ALU  =========================
ALU ic4 (
    .A(readA_out),
    .B(outmux),
    .alu_sel(alu_sel),
    .ALU_out(ALU_out),
    .hi_from_alu(hi_from_alu_data),
    .lo_from_alu(lo_from_alu_data),
    .cmp(cmp)
);
    
// ========================= BRANCH  =========================
branch ic14 (
    .cmp(cmp),
    .branch(branch),
    .branch_out(branch_out));

// ========================= ALU CONTROLLER =========================
ALU_control ic5 (
    .funct3(funct3),
    .alu_op(alu_op),
    .ALU_control(alu_sel));

// ========================= IMMIDATE GENERATION =========================
Imm_gen ic6 (
    .instruction(instruction),
    .imm_type(immtype),
    .imm_out(imm_out));

// ========================= DATA MEMORY =========================
data_mem ic7 (
    .mem_write_en(mem_write_en),
    .sp_addr(pc),
    .ret_addr(ret_addr),
    .clk(clk),
    .mem_read_en(mem_read_en),
    .addr(ALU_out),
    .write_data(readB_out),
    .read_data(read_data),
    .reset(reset));

// ========================= MUX 2 to 1 =========================
MUX_2_1 ic20 (
    .A(rt),
    .B(rd_raw),
    .mux(reg_dst),
    .outmux(rd));

//writeback mux
MUX_2_1 ic8 (
    .A(read_data),
    .B(ALU_out),
    .mux(memtoreg),
    .outmux(wb_mux_out));

//this ic12 is branch_mux
MUX_2_1_PC ic12 (
    .B(pc_out),
    .A(pc_plus2),   
    .mux(branch_out),
    .outmux(pc_branch));
    
mux_mtsr_wb ic23(
    .A(wb_mux_out),
    .B(mfsr_data),
    .mux(special_to_reg),
    .outmux(data_reg));

// ========================= MUX jump =========================

Jump ic24(
    .pc(pc_plus2),
    .instruction(instruction),
    .jump_target(jump_out)
    );

MUX_jump ic21(
    .pc_jump(jump_out),
    .pc_branch(pc_branch),
    .jump_signal(jump),
    .next_pc(next_pc)
    );
    
//MUX_3_1_RET ic16 (
//    .A(in_mux),
//    .B(ret_addr),
//    .C(pc_mux),
//    .PC_sel(PCsel),
//    .outmux(muxicr_in));

// ========================= ADD_PC (PC + IMM) =========================
//ic9 for add branch
add_pc ic9 (
    .pc(pc_plus2),
    .imm(imm_out),
    .pc_out(pc_out));
    
//ic10 for increase pc
pc_add_2 ic10 (
    .pc(pc),
    .imm(CONST),
    .pc_out(pc_plus2));

// ========================= C_U =========================   
C_U ic17 (
    .opcode(opcode),
    .funct3(funct3),

    .mem_read(mem_read_en),
    .memtoreg(memtoreg),
    .reg_wrt(reg_wrt),
    .alu_src(alu_src),
    .mem_write(mem_write_en),
    .branch(branch),
    .reg_dst(reg_dst),
    .hold_hlt(hold_hlt),
    .jump(jump),

    .immtype(immtype),
    .mfsr_sel(mfsr_sel),
    .alu_op(alu_op),

    .special_to_reg(special_to_reg),
    .ra_signal(ra_signal),
    .at_signal(at_signal),
    .hi_signal(hi_signal),
    .lo_signal(lo_signal),
    .hi_from_alu_signal(hi_from_alu_signal),
    .lo_from_alu_signal(lo_from_alu_signal)
);

// ========================= SPECIAL REGISTER =========================
special_register ic22 (
    .clk(clk),
    .rst(reset),
    .ra_signal(ra_signal),
    .at_signal(at_signal),
    .hi_signal(hi_signal),
    .lo_signal(lo_signal),
    .hi_from_alu_signal(hi_from_alu_signal),
    .lo_from_alu_signal(lo_from_alu_signal),

    .ra_data(readB_out),
    .at_data(readB_out),
    .hi_data(readB_out),          // mthi: HI <- rt
    .lo_data(readB_out),          // mtlo: LO <- rt
    .pc(pc_plus2),
    .hi_from_alu_data(hi_from_alu_data),   // t? ALU
    .lo_from_alu_data(lo_from_alu_data),   // t? ALU

    .mfsr_sel(mfsr_sel),
    .mfsr_data(mfsr_data)
);

// ========================= CLOCK =========================  
Clock_div ic18 (
    .clk(clk),.rst(reset)/*,.clk_1hz(clk_1hz),.clk_4hz(clk_4hz)*/,.clk_8hz(clk_8hz)/*,.clk_100hz(clk_100hz)*/);

MUX_clk ic19 (
    /*.clk_1hz(clk_1hz),.clk_4hz(clk_4hz),*/.clk_8hz(clk_8hz)/*,.clk_100hz(clk_100hz)*/,.mux_clk(mux_clk),.clk_out(clk_out));

endmodule