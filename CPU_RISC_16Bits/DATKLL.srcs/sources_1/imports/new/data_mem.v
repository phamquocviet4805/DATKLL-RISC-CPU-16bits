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

    // Memory load/store control
    input        mem_write_en,
    input        mem_read_en,
    input [15:0] addr,           // byte address, already computed by ALU

    input [15:0] write_data,     // 16-bit data from GPR for store-halfword (SH)

    // STACK used to store return addresses (if needed)
    input [15:0] sp_addr,        // usually the current PC
    input        push,           // push onto stack
    input        pop,            // pop from stack
    output reg   over_flow,      // stack overflow flag
    output reg   under_flow,     // stack underflow flag
    output reg [15:0] ret_addr,  // return address (PC) when popping

    // Data for load-halfword (LH)
    output reg [15:0] read_data
);

    // ===== 4KB RAM: 4096 bytes from 0x0000 to 0x0FFF =====
    reg [7:0] memory [0:4095];

    // STACK POINTER: use the top region of RAM
    // Stack region: [0x0FF0 .. 0x0FFE], each entry is 2 bytes
    localparam [15:0] STACK_TOP    = 16'h0FFE; // empty stack: SP = 0x0FFE
    localparam [15:0] STACK_BOTTOM = 16'h0FF0; // stack is full when SP <= 0x0FF0

    reg [15:0] sp;

    // Return address is PC + 2 (next instruction)
    wire [15:0] ret_addr_plus_2;
    assign ret_addr_plus_2 = sp_addr + 16'd2;

    integer i;

    // ===== Sequential logic =====
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sp         <= STACK_TOP;  // empty stack
            over_flow  <= 1'b0;
            under_flow <= 1'b0;
            ret_addr   <= 16'b0;

            // If you want to clear RAM on reset, uncomment the block below,
            // but synthesis will consume more resources:
            /*
            for (i = 0; i < 4096; i = i + 1)
                memory[i] <= 8'h00;
            */
        end else begin
            // By default every cycle: clear new error flags
            over_flow  <= 1'b0;
            under_flow <= 1'b0;
            // ret_addr keeps its previous value if there is no pop

            // ====== STACK PUSH ======
            if (push) begin
                // Overflow if SP has reached the bottom of stack
                if (sp <= STACK_BOTTOM) begin
                    over_flow <= 1'b1;
                end else begin
                    // Store (sp_addr + 2) on stack at [sp-1 : sp]
                    // (lower byte at sp, higher byte at sp-1)
                    memory[sp]     <= ret_addr_plus_2[7:0];
                    memory[sp - 1] <= ret_addr_plus_2[15:8];
                    sp             <= sp - 16'd2;
                end
            end

            // ====== STACK POP ======
            else if (pop) begin
                // Underflow if SP is at STACK_TOP (stack empty)
                if (sp >= STACK_TOP) begin
                    under_flow <= 1'b1;
                    ret_addr   <= 16'b0;
                end else begin
                    // Top element is stored at [sp+1 : sp+2]
                    // (because SP was decremented by 2 on push)
                    ret_addr[15:8] <= memory[sp + 16'd1];
                    ret_addr[7:0]  <= memory[sp + 16'd2];
                    sp             <= sp + 16'd2;
                end
            end

            // ====== MEMORY WRITE (SH) ======
            if (mem_write_en) begin
                // Write 16-bit word at addr (little-endian)
                // addr must be in range [0 .. 4094]
                memory[addr]     <= write_data[7:0];   // low byte
                memory[addr + 1] <= write_data[15:8];  // high byte
            end
        end
    end

    // ===== Combinational read (LH) =====
    always @(*) begin
        if (mem_read_en) begin
            // Read 16-bit word at addr (little-endian)
            read_data = {memory[addr + 1], memory[addr]};
        end else begin
            read_data = 16'd0;
        end
    end

endmodule
