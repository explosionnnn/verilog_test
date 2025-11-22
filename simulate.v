`timescale 1ns/1ps

module Shift_Register_tb;

    reg  [7:0] i;    // parallel load input
    reg  [1:0] s;    // control
    reg        clk;
    reg        reset;
    reg        r;    // serial input
    wire [7:0] o;    // output

    // ========= Instantiate DUT (被測模組) =========
    Shift_Register UUT(
        .i(i),
        .s(s),
        .o(o),
        .clk(clk),
        .reset(reset),
        .r(r)
    );

    // ========= Clock =========
    always #5 clk = ~clk;  // 10ns clock

    initial begin
        $dumpfile("shift_register.vcd");
        $dumpvars(0, Shift_Register_tb);

        // 初始化
        clk = 0;
        reset = 1;
        s = 2'b00;
        i = 8'b0000_0000;
        r = 0;

        #12;
        reset = 0;    // Release reset

        // ===============================
        // 1. Parallel Load 測試
        // ===============================
        i = 8'b1011_0011;
        s = 2'b11;       // parallel load
        #10;             // 1 個 clock
        #10;

        // ===============================
        // 2. Shift Right 測試
        // ===============================
        s = 2'b01;       // shift right
        r = 1;           // serial input (從 MSB 進來)
        #10;
        #10;

        r = 0;
        #10;
        #10;

        // ===============================
        // 3. Shift Left 測試
        // ===============================
        s = 2'b10;       // shift left
        r = 1;           // serial input (從 LSB 進來)
        #10;
        #10;
        #10;

        // ===============================
        // 4. Hold 測試
        // ===============================
        s = 2'b00;       // hold
        #20;

        // 結束模擬
        $finish;
    end

endmodule