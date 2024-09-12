`timescale 1ns / 1ps

/**
 * @brief Testbench For A Sorting Engine Module
 * 
 * @details This testbench is used to verify the functionality of the Sorting Engine module.
 * The testbench instantiates the Sorting Engine module and provides test vectors to the module.
 * The testbench then compares the output of the Sorting Engine module with the expected results.
 * The testbench also keeps track of the total score for passing the test cases.
 * The testbench uses the following test cases:
 * 1. 8-bit 8-element array : Passed 8 Such Test Cases
 * 2. 2-bit 3-element array : Passed 2 Such Test Cases
 * 3. 2-bit 4-element array : Passed 2 Such Test Cases
 * 4. 16-bit 4-element array : Passed
 * 5. 4-bit 10-element array : Passed
 * 6. 32-bit 5-element array : Passed
 * 7. 4-bit 3-element array : Passed
 * 8. 16-bit 6-element array : Passed
 * 9. 8-bit 3-element array : Passed
 * 10. 16-bit 8-element array : Passed 
 * 11. 8-bit 5-element array : Passed
 * 12. 4-bit 5-element array : Passed
 * 13. 32-bit 3-element array : Passed
 * 
 * @param NUM_TESTS : Number of Test Cases
**/
module top_module ();
    parameter NUM_TESTS=22; // Number of Test Cases
    reg clk = 0; // CLOCK SIGNAL
    reg valid_in = 0; // VALID_IN is used by the testbench to indicate that the input array is ready to be sorted, and to start the sorting process.
    wire valid_out = 0; // VALID_OUT is used by the testbench to indicate that the output array is ready to be read, and to read the sorted array.
    reg [7:0] total_score = 0; // TOTAL SCORE for passing the test cases

    // Test vectors for 8-bit data width
    reg [8*8-1:0] test_vectors_8bit8 [7:0], expected_results_8bit8 [7:0];
    reg [2*3-1:0] test_vectors_2bit3 [1:0],expected_results_2bit3 [1:0];
    reg [2*4-1:0] test_vectors_2bit4 [1:0], expected_results_2bit4 [1:0];
    reg [8*8-1:0] expected_results_8bit8_element;
    initial begin
        test_vectors_8bit8          [0] =   {   8'd3,      8'd1,       8'd4,      8'd6,       8'd5,    8'd9,       8'd2,      8'd1};
        expected_results_8bit8      [0] =   {   8'd1,      8'd1,       8'd2,      8'd3,       8'd4,    8'd5,       8'd6,      8'd9};
        test_vectors_8bit8          [1] =   {   8'd12,     8'd23,      8'd34,     8'd45,      8'd56,   8'd67,      8'd78,      8'd89};
        expected_results_8bit8      [1] =   {   8'd12,     8'd23,      8'd34,     8'd45,      8'd56,   8'd67,      8'd78,      8'd89};
        test_vectors_8bit8          [2] =   {   8'd89,     8'd78,      8'd67,     8'd56,      8'd45,   8'd34,      8'd23,      8'd12};
        expected_results_8bit8      [2] =   {   8'd12,     8'd23,      8'd34,     8'd45,      8'd56,   8'd67,      8'd78,      8'd89};
        test_vectors_8bit8          [3] =   {   8'd50,     8'd50,      8'd50,     8'd50,      8'd50,   8'd50,      8'd50,      8'd50};
        expected_results_8bit8      [3] =   {   8'd50,     8'd50,      8'd50,     8'd50,      8'd50,   8'd50,      8'd50,      8'd50};
        test_vectors_8bit8          [4] =   {   8'd12,     8'd12,      8'd34,     8'd34,      8'd56,   8'd56,      8'd78,      8'd78};
        expected_results_8bit8      [4] =   {   8'd12,     8'd12,      8'd34,     8'd34,      8'd56,   8'd56,      8'd78,      8'd78};
        test_vectors_8bit8          [5] =   {   8'd89,     8'd12,      8'd78,     8'd23,      8'd67,   8'd34,      8'd56,      8'd45};
        expected_results_8bit8      [5] =   {   8'd12,     8'd23,      8'd34,     8'd45,      8'd56,   8'd67,      8'd78,      8'd89};
        test_vectors_8bit8          [6] =   {   8'd5,      8'd2,       8'd8,      8'd3,       8'd6,    8'd1,       8'd4,       8'd7};
        expected_results_8bit8      [6] =   {   8'd1,      8'd2,       8'd3,      8'd4,       8'd5,    8'd6,       8'd7,       8'd8};
        test_vectors_8bit8          [7] =   {   8'd250,    8'd0,       8'd100,    8'd150,     8'd200,  8'd50,      8'd75,      8'd25};
        expected_results_8bit8      [7] =   {   8'd0,      8'd25,      8'd50,     8'd75,      8'd100,  8'd150,     8'd200,     8'd250};
        test_vectors_2bit3          [0] =   {   2'd2,      2'd3,       2'd1};
        expected_results_2bit3      [0] =   {   2'd1,      2'd2,       2'd3};
        test_vectors_2bit3          [1] =   {   2'd3,      2'd2,       2'd1};
        expected_results_2bit3      [1] =   {   2'd1,      2'd2,       2'd3};
        test_vectors_2bit4          [0] =   {   2'd2,      2'd3,       2'd0,      2'd1};
        expected_results_2bit4      [0] =   {   2'd0,      2'd1,       2'd2,      2'd3};
        test_vectors_2bit4          [1] =   {   2'd3,      2'd2,       2'd1,      2'd0};
        expected_results_2bit4      [1] =   {   2'd0,      2'd1,       2'd2,      2'd3};
    end

    reg [16*4-1:0] test_vectors_16bit4 = {16'd300, 16'd100, 16'd200, 16'd400};
    reg [16*4-1:0] expected_results_16bit4 = {16'd100, 16'd200, 16'd300, 16'd400};

    reg [4*10-1:0] test_vectors_4bit10 = {4'd3, 4'd7, 4'd2, 4'd9, 4'd5, 4'd8, 4'd1, 4'd6, 4'd4, 4'd0};
    reg [4*10-1:0] expected_results_4bit10 = {4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9};

    reg [32*5-1:0] test_vectors_32bit5 = {32'd60000, 32'd20000, 32'd40000, 32'd100000, 32'd80000};
    reg [32*5-1:0] expected_results_32bit5 = {32'd20000, 32'd40000, 32'd60000, 32'd80000, 32'd100000};

    reg [4*3-1:0] test_vectors_4bit3 = {4'd5, 4'd1, 4'd3};
    reg [4*3-1:0] expected_results_4bit3 = {4'd1, 4'd3, 4'd5};

    reg [16*6-1:0] test_vectors_16bit6 = {16'd500, 16'd150, 16'd250, 16'd450, 16'd100, 16'd300};
    reg [16*6-1:0] expected_results_16bit6 = {16'd100, 16'd150, 16'd250, 16'd300, 16'd450, 16'd500};

    reg [8*3-1:0] test_vectors_8bit3 = {8'd15, 8'd10, 8'd20};
    reg [8*3-1:0] expected_results_8bit3 = {8'd10, 8'd15, 8'd20};

    reg [16*8-1:0] test_vectors_16bit8 = {16'd600, 16'd150, 16'd250, 16'd450, 16'd100, 16'd300, 16'd200, 16'd500};
    reg [16*8-1:0] expected_results_16bit8 = {16'd100, 16'd150, 16'd200, 16'd250, 16'd300, 16'd450, 16'd500, 16'd600};

    reg [8*5-1:0] test_vectors_8bit5 = {8'd50, 8'd10, 8'd30, 8'd40, 8'd20};
    reg [8*5-1:0] expected_results_8bit5 = {8'd10, 8'd20, 8'd30, 8'd40, 8'd50};

    reg [32*3-1:0] test_vectors_32bit3 = {32'd80000, 32'd50000, 32'd60000};
    reg [32*3-1:0] expected_results_32bit3 = {32'd50000, 32'd60000, 32'd80000};

    reg [4*5-1:0] test_vectors_4bit5 = {4'd3, 4'd1, 4'd4, 4'd5, 4'd2};
    reg [4*5-1:0] expected_results_4bit5 = {4'd1, 4'd2, 4'd3, 4'd4, 4'd5};

    // CLOCK GENERATION
    always #5 clk = ~clk;
    
    reg [8*8-1:0] array_in_8bit8;
    reg [2*3-1:0] array_in_2bit3;
    reg [2*4-1:0] array_in_2bit4;
    reg [16*4-1:0] array_in_16bit4;
    reg [4*10-1:0] array_in_4bit10;
    reg [32*5-1:0] array_in_32bit5;
    reg [4*3-1:0] array_in_4bit3;
    reg [16*6-1:0] array_in_16bit6;
    reg [8*3-1:0] array_in_8bit3;
    reg [16*8-1:0] array_in_16bit8;
    reg [8*5-1:0] array_in_8bit5;
    reg [32*3-1:0] array_in_32bit3;
    reg [4*5-1:0] array_in_4bit5;
    wire [8*8-1:0] array_out_8bit8;
    wire [2*3-1:0] array_out_2bit3;
    wire [2*4-1:0] array_out_2bit4;
    wire [16*4-1:0] array_out_16bit4;
    wire [4*10-1:0] array_out_4bit10;
    wire [32*5-1:0] array_out_32bit5;
    wire [4*3-1:0] array_out_4bit3;
    wire [16*6-1:0] array_out_16bit6;
    wire [8*3-1:0] array_out_8bit3;
    wire [16*8-1:0] array_out_16bit8;
    wire [8*5-1:0] array_out_8bit5;
    wire [32*3-1:0] array_out_32bit3;
    wire [4*5-1:0] array_out_4bit5;

    initial begin
        $dumpfile("top_module.vcd");
        $dumpvars(0, top_module);
    end
    

    // SORTING ENGINE INSTANCES
    SE #(8,8)  uut8bit8    ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_8bit8),  .array_out(array_out_8bit8),    .valid_out() );
    SE #(2,3)   uut2bit3    ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_2bit3),  .array_out(array_out_2bit3),    .valid_out() );
    SE #(2,4)   uut2bit4    ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_2bit4),  .array_out(array_out_2bit4),    .valid_out() );
    SE #(16,4)  uut16bit4   ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_16bit4), .array_out(array_out_16bit4),   .valid_out() );
    SE #(4,10)  uut4bit10   ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_4bit10), .array_out(array_out_4bit10),   .valid_out() );
    SE #(32,5)  uut32bit5   ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_32bit5), .array_out(array_out_32bit5),   .valid_out() );
    SE #(4,3)   uut4bit3    ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_4bit3),  .array_out(array_out_4bit3),    .valid_out() );
    SE #(16,6)  uut16bit6   ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_16bit6), .array_out(array_out_16bit6),   .valid_out() );
    SE #(8,3)   uut8bit3    ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_8bit3),  .array_out(array_out_8bit3),    .valid_out() );
    SE #(16,8)  uut16bit8   ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_16bit8), .array_out(array_out_16bit8),   .valid_out() );
    SE #(8,5)   uut8bit5    ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_8bit5),  .array_out(array_out_8bit5),    .valid_out() );
    SE #(32,3)  uut32bit3   ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_32bit3), .array_out(array_out_32bit3),   .valid_out() );
    SE #(4,5)   uut4bit5    ( .clk(clk),    .valid_in(valid_in),    .array_in(array_in_4bit5),  .array_out(array_out_4bit5),    .valid_out() );
    // TEST CASE PROCEDURE
    initial begin
        // Initialize clock and signals
        // Test all 8-bit vectors
        for (integer i = 0; i < $size(test_vectors_8bit8); i = i + 1) begin
            array_in_8bit8 = test_vectors_8bit8[i];
            test_case_8bit8(i); #10;
        end

        // Test minimal 2-bit vectors
        for (integer i = 0; i < $size(test_vectors_2bit3); i = i + 1) begin
            array_in_2bit3 = test_vectors_2bit3[i];
            test_case_2bit3(i);#10;
        end

        for (integer i = 0; i < $size(test_vectors_2bit4); i = i + 1) begin
            array_in_2bit4 = test_vectors_2bit4[i];
            test_case_2bit4(i);#10;
        end

        // Test additional vectors
        array_in_16bit4 = test_vectors_16bit4;
        test_case_16bit4();#10;
        array_in_4bit10 = test_vectors_4bit10;
        test_case_4bit10();#10;
        array_in_32bit5 = test_vectors_32bit5;
        test_case_32bit5();#10;
        array_in_4bit3 = test_vectors_4bit3;
        test_case_4bit3();#10;
        array_in_16bit6 = test_vectors_16bit6;
        test_case_16bit6();#10;
        array_in_8bit3 = test_vectors_8bit3;
        test_case_8bit3();#10;
        array_in_16bit8 = test_vectors_16bit8;
        test_case_16bit8();#10;
        array_in_8bit5 = test_vectors_8bit5;
        test_case_8bit5();#10;
        array_in_4bit5 = test_vectors_4bit5;
        test_case_4bit5();#10;
        array_in_32bit3 = test_vectors_32bit3;
        test_case_32bit3();#10;
        $display("Total Score: %d / %d", total_score, NUM_TESTS);
        $finish;
    end

    task test_case_8bit8(input integer index);
        expected_results_8bit8_element = expected_results_8bit8[index];
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut8bit8.valid_out);
        if (uut8bit8.array_out == expected_results_8bit8[index]) begin
            $display("8-bit Test %0d Passed", index + 1);
            total_score = total_score + 1;
        end else begin
            $display("8-bit Test %0d Failed", index + 1);
            $display(" - Input: %d %d %d %d %d %d %d %d", test_vectors_8bit8[index][7:0], test_vectors_8bit8[index][15:8], test_vectors_8bit8[index][23:16], test_vectors_8bit8[index][31:24], test_vectors_8bit8[index][39:32], test_vectors_8bit8[index][47:40], test_vectors_8bit8[index][55:48], test_vectors_8bit8[index][63:56]);
            $display(" - Expected Results: %d %d %d %d %d %d %d %d", expected_results_8bit8[index][7:0], expected_results_8bit8[index][15:8], expected_results_8bit8[index][23:16], expected_results_8bit8[index][31:24], expected_results_8bit8[index][39:32], expected_results_8bit8[index][47:40], expected_results_8bit8[index][55:48], expected_results_8bit8[index][63:56]);
            $display(" - Actual Results: %d %d %d %d %d %d %d %d", uut8bit8.array_out[7:0], uut8bit8.array_out[15:8], uut8bit8.array_out[23:16], uut8bit8.array_out[31:24], uut8bit8.array_out[39:32], uut8bit8.array_out[47:40], uut8bit8.array_out[55:48], uut8bit8.array_out[63:56]);
        end
    endtask

    task test_case_2bit3(input integer index);
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut2bit3.valid_out);
        if (uut2bit3.array_out == expected_results_2bit3[index]) begin
            $display("2-bit 3-element Test Passed");
            total_score = total_score + 1;
        end else begin 
            $display("2-bit 3-element Test Failed");
            $display(" - Input: %d %d %d", test_vectors_2bit3[index][1:0], test_vectors_2bit3[index][3:2], test_vectors_2bit3[index][5:4]);
            $display(" - Expected Results: %d %d %d", expected_results_2bit3[index][1:0], expected_results_2bit3[index][3:2], expected_results_2bit3[index][5:4]);
            $display(" - Actual Results: %d %d %d", uut2bit3.array_out[1:0], uut2bit3.array_out[3:2], uut2bit3.array_out[5:4]);
        end
    endtask

    task test_case_2bit4(input integer index);
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut2bit4.valid_out);
        if (uut2bit4.array_out == expected_results_2bit4[index]) begin
            $display("2-bit 4-element Test Passed");
            total_score = total_score + 1;
        end else begin
            $display("2-bit 4-element Test Failed");
            $display(" - Expected Results: %d %d %d %d", expected_results_2bit4[index][1:0], expected_results_2bit4[index][3:2], expected_results_2bit4[index][5:4], expected_results_2bit4[index][7:6]);
            $display(" - Actual Results: %d %d %d %d", uut2bit4.array_out[1:0], uut2bit4.array_out[3:2], uut2bit4.array_out[5:4], uut2bit4.array_out[7:6]);
        end
    endtask
    task test_case_16bit4();
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut16bit4.valid_out);
        if (uut16bit4.array_out == expected_results_16bit4) begin
            $display("16-bit 4-element Test Passed");
            total_score = total_score + 1;
        end else begin
            $display("16-bit 4-element Test Failed");
            $display(" - Expected Results: %d %d %d %d", expected_results_16bit4[15:0], expected_results_16bit4[31:16], expected_results_16bit4[47:32], expected_results_16bit4[63:48]);
            $display(" - Actual Results: %d %d %d %d", uut16bit4.array_out[15:0], uut16bit4.array_out[31:16], uut16bit4.array_out[47:32], uut16bit4.array_out[63:48]);
        end
    endtask

    task test_case_4bit10();
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut4bit10.valid_out);
        if (uut4bit10.array_out == expected_results_4bit10) begin
            $display("4-bit 10-element Test Passed");
            total_score = total_score + 1;
        end else begin
            $display("4-bit 10-element Test Failed");
            $display(" - Expected Results: %d %d %d %d %d %d %d %d %d %d", expected_results_4bit10[3:0], expected_results_4bit10[7:4], expected_results_4bit10[11:8], expected_results_4bit10[15:12], expected_results_4bit10[19:16], expected_results_4bit10[23:20], expected_results_4bit10[27:24], expected_results_4bit10[31:28], expected_results_4bit10[35:32], expected_results_4bit10[39:36]);
            $display(" - Actual Results: %d %d %d %d %d %d %d %d %d %d", uut4bit10.array_out[3:0], uut4bit10.array_out[7:4], uut4bit10.array_out[11:8], uut4bit10.array_out[15:12], uut4bit10.array_out[19:16], uut4bit10.array_out[23:20], uut4bit10.array_out[27:24], uut4bit10.array_out[31:28], uut4bit10.array_out[35:32], uut4bit10.array_out[39:36]);
        end
    endtask

    task test_case_32bit5();
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut32bit5.valid_out);
        if (uut32bit5.array_out == expected_results_32bit5) begin
            $display("32-bit 5-element Test Passed");
            total_score = total_score + 1;
        end else begin
             $display("32-bit 5-element Test Failed");
            $display(" - Expected Results: %d %d %d %d %d", expected_results_32bit5[31:0], expected_results_32bit5[63:32], expected_results_32bit5[95:64], expected_results_32bit5[127:96], expected_results_32bit5[159:128]);
            $display(" - Actual Results: %d %d %d %d %d", uut32bit5.array_out[31:0], uut32bit5.array_out[63:32], uut32bit5.array_out[95:64], uut32bit5.array_out[127:96], uut32bit5.array_out[159:128]);
        end
    endtask

    task test_case_4bit3();
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut4bit3.valid_out);
        if (uut4bit3.array_out == expected_results_4bit3) begin
            $display("4-bit 3-element Test Passed");
            total_score = total_score + 1;
        end else begin 
            $display("4-bit 3-element Test Failed");
            $display(" - Expected Results: %d %d %d", expected_results_4bit3[3:0], expected_results_4bit3[7:4], expected_results_4bit3[11:8]);
            $display(" - Actual Results: %d %d %d", uut4bit3.array_out[3:0], uut4bit3.array_out[7:4], uut4bit3.array_out[11:8]);
        end
    endtask

    task test_case_16bit6();
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut16bit6.valid_out);
        if (uut16bit6.array_out == expected_results_16bit6) begin
            $display("16-bit 6-element Test Passed");
            total_score = total_score + 1;
        end else begin 
            $display("16-bit 6-element Test Failed");
            $display(" - Expected Results: %d %d %d %d %d %d", expected_results_16bit6[15:0], expected_results_16bit6[31:16], expected_results_16bit6[47:32], expected_results_16bit6[63:48], expected_results_16bit6[79:64], expected_results_16bit6[95:80]);
            $display(" - Actual Results: %d %d %d %d %d %d", uut16bit6.array_out[15:0], uut16bit6.array_out[31:16], uut16bit6.array_out[47:32], uut16bit6.array_out[63:48], uut16bit6.array_out[79:64], uut16bit6.array_out[95:80]);
        end
    endtask

    task test_case_8bit3();
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut8bit3.valid_out);
        if (uut8bit3.array_out == expected_results_8bit3) begin
            $display("8-bit 3-element Test Passed");
            total_score = total_score + 1;
        end else begin 
            $display("8-bit 3-element Test Failed");
            $display(" - Expected Results: %d %d %d", expected_results_8bit3[7:0], expected_results_8bit3[15:8], expected_results_8bit3[23:16]);
            $display(" - Actual Results: %d %d %d", uut8bit3.array_out[7:0], uut8bit3.array_out[15:8], uut8bit3.array_out[23:16]);
        end
    endtask

    task test_case_16bit8();
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut16bit8.valid_out);
        if (uut16bit8.array_out == expected_results_16bit8) begin
            $display("16-bit 8-element Test Passed");
            total_score = total_score + 1;
        end else begin
            $display("16-bit 8-element Test Failed");
            $display(" - Expected Results: %d %d %d %d %d %d %d %d", expected_results_16bit8[15:0], expected_results_16bit8[31:16], expected_results_16bit8[47:32], expected_results_16bit8[63:48], expected_results_16bit8[79:64], expected_results_16bit8[95:80], expected_results_16bit8[111:96], expected_results_16bit8[127:112]);
            $display(" - Actual Results: %d %d %d %d %d %d %d %d", uut16bit8.array_out[15:0], uut16bit8.array_out[31:16], uut16bit8.array_out[47:32], uut16bit8.array_out[63:48], uut16bit8.array_out[79:64], uut16bit8.array_out[95:80], uut16bit8.array_out[111:96], uut16bit8.array_out[127:112]);
        end
    endtask

    task test_case_8bit5();
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut8bit5.valid_out);
        if (uut8bit5.array_out == expected_results_8bit5) begin
            $display("8-bit 5-element Test Passed");
            total_score = total_score + 1;
        end else begin 
            $display("8-bit 5-element Test Failed");
            $display(" - Expected Results: %d %d %d %d %d", expected_results_8bit5[7:0], expected_results_8bit5[15:8], expected_results_8bit5[23:16], expected_results_8bit5[31:24], expected_results_8bit5[39:32]);
            $display(" - Actual Results: %d %d %d %d %d", uut8bit5.array_out[7:0], uut8bit5.array_out[15:8], uut8bit5.array_out[23:16], uut8bit5.array_out[31:24], uut8bit5.array_out[39:32]);
        end
    endtask
    task test_case_4bit5();
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut4bit5.valid_out);
        if (uut4bit5.array_out == expected_results_4bit5) begin
            $display("4-bit 5-element Test Passed");
            total_score = total_score + 1;
        end else begin
            $display("4-bit 5-element Test Failed");
            $display(" - Input: %d %d %d %d %d", test_vectors_4bit5[3:0], test_vectors_4bit5[7:4], test_vectors_4bit5[11:8], test_vectors_4bit5[15:12], test_vectors_4bit5[19:16]);
            $display(" - Expected Results: %d %d %d %d %d", expected_results_4bit5[3:0], expected_results_4bit5[7:4], expected_results_4bit5[11:8], expected_results_4bit5[15:12], expected_results_4bit5[19:16]);
            $display(" - Actual Results: %d %d %d %d %d", uut4bit5.array_out[3:0], uut4bit5.array_out[7:4], uut4bit5.array_out[11:8], uut4bit5.array_out[15:12], uut4bit5.array_out[19:16]);
        end
    endtask

    task test_case_32bit3();
        valid_in = 1;
        #10 valid_in = 0;
        wait (uut32bit3.valid_out);
        if (uut32bit3.array_out == expected_results_32bit3) begin
            $display("32-bit 3-element Test Passed");
            total_score = total_score + 1;
        end else begin 
            $display("32-bit 3-element Test Failed");
            $display(" - Expected Results: %d %d %d", expected_results_32bit3[31:0], expected_results_32bit3[63:32], expected_results_32bit3[95:64]);
            $display(" - Actual Results: %d %d %d", uut32bit3.array_out[31:0], uut32bit3.array_out[63:32], uut32bit3.array_out[95:64]);
        end
    endtask
endmodule