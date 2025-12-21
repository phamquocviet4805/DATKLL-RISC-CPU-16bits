`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 07:32:04 PM
// Design Name: 
// Module Name: fp16_unit
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


module fp16_unit (
    input  [15:0] a,        // rs
    input  [15:0] b,        // rt
    input  [2:0]  funct3,   // FP operation selector
    output reg [15:0] fp_out
);

    // ===================== constants =====================
    localparam [4:0] FP16_EXP_BIAS = 5'd15;
    localparam [4:0] FP16_EXP_MAX  = 5'd30;

    // ===================== decode fields =====================
    wire sign_a, sign_b;
    wire [4:0] exp_a, exp_b;
    wire [9:0] frac_a, frac_b;

    assign sign_a = a[15];
    assign sign_b = b[15];
    assign exp_a  = a[14:10];
    assign exp_b  = b[14:10];
    assign frac_a = a[9:0];
    assign frac_b = b[9:0];

    // zero detect (subset)
    wire a_zero, b_zero;
    assign a_zero = (a[14:0] == 15'b0);
    assign b_zero = (b[14:0] == 15'b0);

    // mantissa with implicit 1 (ignore subnormal in subset)
    wire [10:0] mant_a, mant_b;
    assign mant_a = (exp_a == 5'd0) ? 11'b0 : {1'b1, frac_a};
    assign mant_b = (exp_b == 5'd0) ? 11'b0 : {1'b1, frac_b};

    // multiply mantissas
    wire [21:0] mant_mul;
    assign mant_mul = mant_a * mant_b;

    // ===================== temps (declared OUTSIDE always) =====================
    integer exp_tmp;             // intermediate exponent for mul
    reg [10:0] mant_norm;
    reg [4:0]  exp_norm;

    // for ITOFH
    integer i;
    reg        found;
    reg [15:0] abs_a;
    reg        sign_int;
    reg [4:0]  exp_int;
    reg [15:0] frac_shifted;     // hold shifting result safely

    // for FTOHI
    integer e_unbias;
    reg [15:0] value_int;

// ====== ADD/SUB temps ======
    reg        sign_b_eff;      // sign of b after SUB flipping
    reg        sign_big, sign_small;
    reg [4:0]  exp_big, exp_small;
    reg [10:0] mant_big, mant_small;

    integer    shift_amt;
    reg [10:0] mant_small_shifted;

    reg        sign_out;
    reg [4:0]  exp_out;
    reg [11:0] mant_res;        // 12-bit to hold carry/borrow result

    // ===================== always =====================
    always @(*) begin
        // defaults
        fp_out = 16'h0000;

        // default temp resets (avoid inferred latches)
        exp_tmp = 0;
        mant_norm = 11'd0;
        exp_norm = 5'd0;

        abs_a = 16'd0;
        sign_int = 1'b0;
        exp_int = 5'd0;
        frac_shifted = 16'd0;
        found = 1'b0;

        e_unbias = 0;
        value_int = 16'd0;

        case (funct3)

            // =====================================================
            // FADDH : FP16 add (subset: normal+zero, truncate)
            // =====================================================
            3'b001: begin
                // a + b
                // handle zeros
                if (a_zero && b_zero) begin
                    fp_out = 16'h0000;
                end else if (a_zero) begin
                    fp_out = b;  // +0 + b = b (includes -0 subset ok)
                end else if (b_zero) begin
                    fp_out = a;
                end else begin
                    sign_b_eff = sign_b; // no flip for ADD

                    // choose bigger magnitude by exponent then mantissa
                    if (exp_a > exp_b || (exp_a == exp_b && mant_a >= mant_b)) begin
                        sign_big = sign_a;   exp_big = exp_a;   mant_big = mant_a;
                        sign_small = sign_b_eff; exp_small = exp_b; mant_small = mant_b;
                    end else begin
                        sign_big = sign_b_eff; exp_big = exp_b; mant_big = mant_b;
                        sign_small = sign_a;   exp_small = exp_a; mant_small = mant_a;
                    end

                    // align mant_small to exp_big
                    shift_amt = exp_big - exp_small;
                    if (shift_amt >= 12)
                        mant_small_shifted = 11'd0;
                    else
                        mant_small_shifted = mant_small >> shift_amt;

                    exp_out = exp_big;

                    // add/sub mantissas depending on signs
                    if (sign_big == sign_small) begin
                        // same sign => add
                        mant_res = {1'b0, mant_big} + {1'b0, mant_small_shifted};
                        sign_out = sign_big;
                    end else begin
                        // different signs => subtract smaller magnitude from bigger
                        mant_res = {1'b0, mant_big} - {1'b0, mant_small_shifted};
                        sign_out = sign_big;
                    end

                    // if result is zero
                    if (mant_res == 12'd0) begin
                        fp_out = 16'h0000;
                    end else begin
                        // normalize:
                        // if carry at bit11 (>=2.0), shift right 1 and exp++
                        if (mant_res[11]) begin
                            mant_res = mant_res >> 1;
                            exp_out  = exp_out + 1;
                        end else begin
                            // ensure leading 1 at bit10 for normal
                            while ((mant_res[10] == 1'b0) && (exp_out > 0)) begin
                                mant_res = mant_res << 1;
                                exp_out  = exp_out - 1;
                            end
                        end

                        // overflow / underflow handling (subset)
                        if (exp_out >= FP16_EXP_MAX) begin
                            fp_out = {sign_out, FP16_EXP_MAX, 10'h3FF}; // clamp max normal
                        end else if (exp_out <= 0) begin
                            fp_out = 16'h0000; // underflow -> 0
                        end else begin
                            fp_out = {sign_out, exp_out, mant_res[9:0]}; // truncate
                        end
                    end
                end
            end

            // =====================================================
            // FSUBH : FP16 sub (subset) => a - b = a + (-b)
            // =====================================================
            3'b010: begin
                // handle zeros
                if (a_zero && b_zero) begin
                    fp_out = 16'h0000;
                end else if (b_zero) begin
                    fp_out = a; // a - 0 = a
                end else if (a_zero) begin
                    // 0 - b = -b
                    fp_out = {~b[15], b[14:0]};
                end else begin
                    // flip sign of b
                    sign_b_eff = ~sign_b;

                    // choose bigger magnitude by exponent then mantissa (magnitude compare ignores sign)
                    if (exp_a > exp_b || (exp_a == exp_b && mant_a >= mant_b)) begin
                        sign_big = sign_a;   exp_big = exp_a;   mant_big = mant_a;
                        sign_small = sign_b_eff; exp_small = exp_b; mant_small = mant_b;
                    end else begin
                        sign_big = sign_b_eff; exp_big = exp_b; mant_big = mant_b;
                        sign_small = sign_a;   exp_small = exp_a; mant_small = mant_a;
                    end

                    // align mant_small to exp_big
                    shift_amt = exp_big - exp_small;
                    if (shift_amt >= 12)
                        mant_small_shifted = 11'd0;
                    else
                        mant_small_shifted = mant_small >> shift_amt;

                    exp_out = exp_big;

                    // add/sub mantissas depending on signs (after flip)
                    if (sign_big == sign_small) begin
                        mant_res = {1'b0, mant_big} + {1'b0, mant_small_shifted};
                        sign_out = sign_big;
                    end else begin
                        mant_res = {1'b0, mant_big} - {1'b0, mant_small_shifted};
                        sign_out = sign_big;
                    end

                    if (mant_res == 12'd0) begin
                        fp_out = 16'h0000;
                    end else begin
                        if (mant_res[11]) begin
                            mant_res = mant_res >> 1;
                            exp_out  = exp_out + 1;
                        end else begin
                            while ((mant_res[10] == 1'b0) && (exp_out > 0)) begin
                                mant_res = mant_res << 1;
                                exp_out  = exp_out - 1;
                            end
                        end

                        if (exp_out >= FP16_EXP_MAX) begin
                            fp_out = {sign_out, FP16_EXP_MAX, 10'h3FF};
                        end else if (exp_out <= 0) begin
                            fp_out = 16'h0000;
                        end else begin
                            fp_out = {sign_out, exp_out, mant_res[9:0]};
                        end
                    end
                end
            end

            // =====================================================
            // FMULH : FP16 multiply (subset)
            // =====================================================
            3'b011: begin
                if (a_zero || b_zero) begin
                    fp_out = 16'h0000;
                end else begin
                    exp_tmp = exp_a + exp_b - FP16_EXP_BIAS;

                    // normalize mantissa: mant_mul is 22-bit
                    if (mant_mul[21]) begin
                        mant_norm = mant_mul[21:11]; // (shift right 1)
                        exp_tmp   = exp_tmp + 1;
                    end else begin
                        mant_norm = mant_mul[20:10];
                    end

                    // overflow / underflow handling
                    if (exp_tmp >= FP16_EXP_MAX) begin
                        fp_out = { (sign_a ^ sign_b), FP16_EXP_MAX, 10'h3FF }; // max normal
                    end
                    else if (exp_tmp <= 0) begin
                        fp_out = 16'h0000; // underflow -> 0
                    end
                    else begin
                        exp_norm = exp_tmp[4:0];
                        fp_out = { (sign_a ^ sign_b), exp_norm, mant_norm[9:0] }; // truncate
                    end
                end
            end

            // =====================================================
            // FCMPH : (a < b) for FP16 subset (normal + zero only)
            // Return 1 or 0 as integer in fp_out
            // =====================================================
            3'b100: begin
                if (a_zero && b_zero) begin
                    fp_out = 16'd0;
                end
                else if (sign_a != sign_b) begin
                    // negative < positive
                    fp_out = (sign_a) ? 16'd1 : 16'd0;
                end
                else if (exp_a != exp_b) begin
                    // if both positive: smaller exp -> smaller
                    // if both negative: larger exp -> smaller (inverted)
                    fp_out = (((exp_a < exp_b) ? 1'b1 : 1'b0) ^ sign_a) ? 16'd1 : 16'd0;
                end
                else begin
                    fp_out = (((frac_a < frac_b) ? 1'b1 : 1'b0) ^ sign_a) ? 16'd1 : 16'd0;
                end
            end

            // =====================================================
            // ITOFH : int16 -> FP16 (subset, truncate)
            // =====================================================
            3'b101: begin
                if (a == 16'd0) begin
                    fp_out = 16'h0000;
                end else begin
                    sign_int = a[15];
                    abs_a    = sign_int ? (~a + 16'd1) : a;

                    // find MSB index (0..15) - FIX: stop at first hit from MSB
                    exp_int = 5'd0;
                    found = 1'b0;
                    for (i = 15; i >= 0; i = i - 1) begin
                        if (!found && abs_a[i]) begin
                            exp_int = i;
                            found = 1'b1;
                        end
                    end

                    // Build fraction: align abs_a so that MSB goes to bit10 (implicit 1)
                    if (exp_int <= 5'd10)
                        frac_shifted = abs_a << (10 - exp_int);
                    else
                        frac_shifted = abs_a >> (exp_int - 10);

                    fp_out = {
                        sign_int,
                        (exp_int + FP16_EXP_BIAS),
                        frac_shifted[9:0]   // truncate
                    };
                end
            end

            // =====================================================
            // FTOHI : FP16 -> int16 (subset, truncate)
            // NOTE: FIX scale: value = mant_a * 2^(exp-bias-10)
            // =====================================================
            3'b110: begin
                if (a_zero) begin
                    fp_out = 16'd0;
                end else begin
                    e_unbias = exp_a - FP16_EXP_BIAS;

                    // integer = mant_a * 2^(e_unbias - 10)
                    if (e_unbias < 0) begin
                        value_int = 16'd0; // |x| < 1 => trunc toward 0
                    end else if (e_unbias > 25) begin
                        // too large for int16 anyway
                        value_int = 16'h7FFF; // saturate dýõng (tu? policy)
                    end else begin
                        if (e_unbias >= 10) begin
                            // shift left (could overflow int16 -> saturate)
                            if ((e_unbias - 10) > 15)
                                value_int = 16'h7FFF;
                            else
                                value_int = mant_a << (e_unbias - 10);
                        end else begin
                            // shift right
                            value_int = mant_a >> (10 - e_unbias);
                        end
                    end

                    fp_out = sign_a ? (~value_int + 16'd1) : value_int;
                end
            end

            default: begin
                fp_out = 16'h0000;
            end

        endcase
    end

endmodule



