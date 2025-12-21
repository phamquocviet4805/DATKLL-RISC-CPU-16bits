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
    output [15:0] r3, 
    input [1:0] mux_clk
);

localparam CONST = 2;
wire is_bnez, mem_read_en, branch_out;
wire /*clk_1hz ,clk_4hz,clk_100hz,*/ clk_8hz;
wire reg_wrt, mem_write_en, push, pop, pc_sel, alu_src;
wire mux_pc_sel, branch, memtoreg, reg_dst, hold_hlt, jump;
wire cmp;
wire [1:0] PCsel;
wire [2:0] rs, rt, rd, rd_raw, funct3, immtype;
wire [3:0] opcode, alu_op;
wire [5:0] alu_sel, ALU_control;
wire [15:0] in_mux, instruction;
wire [15:0] pc_in, muxicr_in;
wire [15:0] ALU_out, imm_out, outmux, read_data;
wire [15:0] data_reg, readA_out, readB_out;
wire [15:0] pc_out, pc_mux, ret_addr, pc, pc_add_2, next_pc;

// ========================= PROGRAM COUNTER =========================
program_counter ic11 (
    .clk(clk_out),
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
    .r3(r3),
    .clk(clk_out),
    .bank_sel(bank_sel));

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
    .cmp(cmp));
    
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
    .push(push),
    .pop(pop),
    .ret_addr(ret_addr),
    .clk(clk_out),
    .mem_read_en(mem_read_en),
    .addr(ALU_out),
    .write_data(readB_out),
    .read_data(read_data),
    .reset(reset),
    .icr_sel(icr_sel));

// ========================= MUX 2 to 1 =========================
MUX_2_1 ic20 (
    .A(rs),
    .B(rd_raw),
    .mux(reg_dst),
    .outmux(rd));

MUX_2_1 ic8 (
    .A(read_data),
    .B(ALU_out),
    .mux(memtoreg),
    .outmux(data_reg));

//this ic12 is branch_mux
MUX_2_1_PC ic12 (
    .B(pc_out),
    .A(pc_add_2),   
    .mux(branch_out),
    .outmux(pc_mux));
// ========================= MUX jump =========================
MUX_jump ic21(
    .pc_add_2(pc_add_2),
    .pc_branch_mux(pc_mux),
    .jump_signal(jump),
    .instruction(instruction),
    .jump_target(next_pc)
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
    .pc(pc_add_2),
    .imm(imm_out),
    .pc_out(pc_out));
    
//ic10 for increase pc
pc_add_2 ic10 (
    .pc(pc_add_2),
    .imm(CONST),
    .pc_out(pc_add_2));

// ========================= C_U =========================   
C_U ic17 (
    .opcode(opcode),    .funct3(funct3),    .mem_read(mem_read_en),     .reg_wrt(reg_wrt),
    .alu_src(alu_src),  .pc_sel(pc_sel),    .mem_write(mem_write_en),   .branch(branch),    
    .push(push),        .pop(pop),          .alu_op(alu_op),            .memtoreg(memtoreg),
    .PCsel(PCsel),      .immtype(immtype),   .jump(jump)
);

// ========================= CLOCK =========================  
Clock_div ic18 (
    .clk(clk),.rst(reset)/*,.clk_1hz(clk_1hz),.clk_4hz(clk_4hz)*/,.clk_8hz(clk_8hz)/*,.clk_100hz(clk_100hz)*/);

MUX_clk ic19 (
    /*.clk_1hz(clk_1hz),.clk_4hz(clk_4hz),*/.clk_8hz(clk_8hz)/*,.clk_100hz(clk_100hz)*/,.mux_clk(mux_clk),.clk_out(clk_out));

endmodule