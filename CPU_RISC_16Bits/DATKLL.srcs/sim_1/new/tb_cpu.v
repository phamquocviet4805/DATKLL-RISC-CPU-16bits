`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2025 01:22:01 PM
// Design Name: 
// Module Name: tb_cpu
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


`timescale 1ns/1ps

module tb_cpu;

    reg clk;
    reg reset;
    reg interrupt_pending;    // b?n có th? cho nó = 0
    reg [1:0] mux_clk;        // ch?n clock trong CPU

    wire [15:0] r3;

    // Instantiate TOP
    TOP uut (
        .clk(clk),
        .reset(reset),
        .interrupt_pending(interrupt_pending),
        .mux_clk(mux_clk),
        .r3(r3)
    );

    // Clock 10ns = 100 MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        $display("---- CPU Simulation Start ----");

        // Initialize
        reset = 0;
        interrupt_pending = 0;
        mux_clk = 2'b00;   // ch?n clock nhanh nh?t cho ch?y simulation

        #20;
        //reset = 0;

        // Ch?y CPU 2000ns
        #2000;

        $display("---- CPU Simulation End ----");
        $stop;
    end

endmodule
