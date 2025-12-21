`timescale 1ns/1ps

module tb_fp16_unit;

    reg         clk;
    reg  [15:0] a, b;
    reg  [2:0]  funct3;
    wire [15:0] fp_out;

    fp16_unit uut (
        .a(a),
        .b(b),
        .funct3(funct3),
        .fp_out(fp_out)
    );

    // Clock 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor
    initial begin
        $display("---- FP16 DECIMAL TEST START ----");
        $monitor("t=%0t | f3=%b | a=%h | b=%h | out=%h",
                 $time, funct3, a, b, fp_out);
    end

    initial begin
        // init
        funct3 = 3'b000;
        a = 16'h0000;
        b = 16'h0000;
        #20;

// =====================================================
        // FADDH (001): add  (a + b)
        // =====================================================
        @(negedge clk);
        funct3 = 3'b001; a = 16'h4580; b = 16'h3000; // 5.5 + 0.125 = 5.625  -> 0x45A0
        @(negedge clk);
        funct3 = 3'b001; a = 16'h3A00; b = 16'h3800; // 0.75 + 0.5 = 1.25   -> 0x3D00
        @(negedge clk);
        funct3 = 3'b001; a = 16'h3D00; b = 16'hBC00; // 1.25 + (-1.0) = 0.25 -> 0x3400
        @(negedge clk);
        funct3 = 3'b001; a = 16'h0000; b = 16'hC580; // 0 + (-5.5) = -5.5    -> 0xC580
        @(negedge clk);
        funct3 = 3'b001; a = 16'h3C00; b = 16'hBC00; // 1.0 + (-1.0) = 0      -> 0x0000

        // =====================================================
        // FSUBH (010): sub  (a - b)
        // =====================================================
        @(negedge clk);
        funct3 = 3'b010; a = 16'h4580; b = 16'h3000; // 5.5 - 0.125 = 5.375   -> 0x4560
        @(negedge clk);
        funct3 = 3'b010; a = 16'h3A00; b = 16'h3800; // 0.75 - 0.5 = 0.25     -> 0x3400
        @(negedge clk);
        funct3 = 3'b010; a = 16'h3D00; b = 16'h3E00; // 1.25 - 1.5 = -0.25    -> 0xB400
        @(negedge clk);
        funct3 = 3'b010; a = 16'h0000; b = 16'h4580; // 0 - 5.5 = -5.5        -> 0xC580
        @(negedge clk);
        funct3 = 3'b010; a = 16'hC580; b = 16'hC580; // (-5.5) - (-5.5) = 0   -> 0x0000

        // =====================================================
        // ITOFH (100): int -> fp
        // =====================================================
        @(negedge clk);
        funct3 = 3'b100; a = 16'd5;     // 5 -> 5.0
        @(negedge clk);
        funct3 = 3'b100; a = 16'd11;    // 11 -> 11.0
        @(negedge clk);
        funct3 = 3'b100; a = -16'd5;    // -5 -> -5.0

        // =====================================================
        // FTOHI (101): fp -> int (truncate)
        // =====================================================
        @(negedge clk);
        funct3 = 3'b101; a = 16'h3000;  // 0.125 -> 0
        @(negedge clk);
        funct3 = 3'b101; a = 16'h3D00;  // 1.25 -> 1
        @(negedge clk);
        funct3 = 3'b101; a = 16'h4580;  // 5.5 -> 5
        @(negedge clk);
        funct3 = 3'b101; a = 16'hC580;  // -5.5 -> -5

        // =====================================================
        // FCMPH (011): compare
        // =====================================================
        @(negedge clk);
        funct3 = 3'b011; a = 16'h3000; b = 16'h3400; // 0.125 < 0.25 => 1
        @(negedge clk);
        funct3 = 3'b011; a = 16'h3A00; b = 16'h3800; // 0.75 < 0.5 => 0
        @(negedge clk);
        funct3 = 3'b011; a = 16'hC580; b = 16'h4580; // -5.5 < 5.5 => 1
        @(negedge clk);
        funct3 = 3'b011; a = 16'h3D00; b = 16'h3E00; // 1.25 < 1.5 => 1

        // =====================================================
        // FMULH (010): multiply
        // =====================================================
        @(negedge clk);
        funct3 = 3'b010; a = 16'h3000; b = 16'h4000; // 0.125 * 2.0 = 0.25 (0x3400)
        @(negedge clk);
        funct3 = 3'b010; a = 16'h3D00; b = 16'h3800; // 1.25 * 0.5 = 0.625
        @(negedge clk);
        funct3 = 3'b010; a = 16'h4580; b = 16'h3800; // 5.5 * 0.5 = 2.75
        @(negedge clk);
        funct3 = 3'b010; a = 16'hC580; b = 16'h3E00; // -5.5 * 1.5 = -8.25

        #50;
        $display("---- FP16 DECIMAL TEST END ----");
        $stop;
    end

endmodule
