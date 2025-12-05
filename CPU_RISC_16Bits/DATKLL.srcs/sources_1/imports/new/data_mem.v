`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 04:00:13 PM
// Design Name: 
// Module Name: data_mem
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


module data_mem(                       
    input        clk,
    input        reset,

    // load/store b? nh?
    input        mem_write_en,
    input        mem_read_en,
    input [15:0] addr,           // ð?a ch? byte, ð? tính s?n ? ALU (start)

    input [15:0] write_data,     // d? li?u 16-bit t? GPR cho SH

    // STACK dùng cho lýu ð?a ch? tr? v? (n?u b?n c?n)
    input [15:0] sp_addr,        // thý?ng là PC hi?n t?i
    input        push,           // push vào stack
    input        pop,            // pop kh?i stack
    output reg   over_flow,
    output reg   under_flow,
    output reg [15:0] ret_addr,  // ð?a ch? tr? v? (PC) khi pop

    // D? li?u ð?c LH
    output reg [15:0] read_data
);

    // ===== RAM 4KB: 4096 byte t? 0x0000 t?i 0x0FFF =====
    reg [7:0] memory [0:4095];

    // STACK POINTER: dùng vùng trên cùng c?a RAM
    // stack ? vùng [0x0FF0 .. 0x0FFE], m?i ph?n t? 2 byte
    localparam [15:0] STACK_TOP    = 16'h0FFE; // stack r?ng: SP = 0x0FFE
    localparam [15:0] STACK_BOTTOM = 16'h0FF0; // full khi SP <= 0x0FF0

    reg [15:0] sp;

    wire [15:0] ret_addr_plus_2;
    assign ret_addr_plus_2 = sp_addr + 16'd2;

    integer i;

    // ===== Sequential logic =====
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sp         <= STACK_TOP;  // stack r?ng
            over_flow  <= 1'b0;
            under_flow <= 1'b0;
            ret_addr   <= 16'b0;

            // n?u mu?n clear RAM khi reset th? b? comment ðo?n dý?i,
            // nhýng synth s? t?n tài nguyên hõn:
            /*
            for (i = 0; i < 4096; i = i + 1)
                memory[i] <= 8'h00;
            */
        end else begin
            // m?c ð?nh m?i cycle: không báo l?i m?i
            over_flow  <= 1'b0;
            under_flow <= 1'b0;
            // ret_addr gi? nguyên n?u không pop

            // ====== STACK PUSH ======
            if (push) begin
                // full n?u sp ð? xu?ng t?i ðáy
                if (sp <= STACK_BOTTOM) begin
                    over_flow <= 1'b1;
                end else begin
                    // lýu (sp_addr + 2) lên stack t?i [sp-1 : sp]
                    // (lower byte ? sp, higher byte ? sp-1)
                    memory[sp]     <= ret_addr_plus_2[7:0];
                    memory[sp - 1] <= ret_addr_plus_2[15:8];
                    sp             <= sp - 16'd2;
                end
            end

            // ====== STACK POP ======
            else if (pop) begin
                // r?ng n?u sp ðang ? TOP
                if (sp >= STACK_TOP) begin
                    under_flow <= 1'b1;
                    ret_addr   <= 16'b0;
                end else begin
                    // ph?n t? trên cùng n?m ? [sp+1 : sp+2]
                    // (v? trý?c ðó khi push sp gi?m 2)
                    ret_addr[15:8] <= memory[sp + 16'd1];
                    ret_addr[7:0]  <= memory[sp + 16'd2];
                    sp             <= sp + 16'd2;
                end
            end

            // ====== MEMORY WRITE (SH) ======
            if (mem_write_en) begin
                // ghi 16-bit t?i addr (little-endian)
                // addr ph?i n?m trong [0 .. 4094]
                memory[addr]     <= write_data[7:0];   // byte th?p
                memory[addr + 1] <= write_data[15:8];  // byte cao
            end
        end
    end

    // ===== Combinational read (LH) =====
    always @(*) begin
        if (mem_read_en) begin
            // ð?c 16-bit t?i addr (little-endian)
            read_data = {memory[addr + 1], memory[addr]};
        end else begin
            read_data = 16'd0;
        end
    end

endmodule

