`timescale 1ns / 1ps

module baud_gen(
    input wire clk,        // System clock
    input wire reset,      // System reset
    output reg baud_clk,   // Baud clock output
    output reg sample_point // Sampling point signal
);

    // Baud rate parameters
    parameter BAUD_RATE = 500_000;        // 500 Kbps
    parameter CLOCK_FREQ = 100_000_000;   // 100 MHz system clock

    // Time quanta parameters (simplified)
    parameter TQ_NUM = 10;                // Number of time quanta per bit
    parameter TQ = CLOCK_FREQ / (BAUD_RATE * TQ_NUM);

    reg [31:0] counter;
    reg [3:0] tq_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            baud_clk <= 0;
            tq_counter <= 0;
            sample_point <= 0;
        end else begin
            if (counter >= (TQ - 1)) begin
                counter <= 0;
                baud_clk <= ~baud_clk;
                tq_counter <= tq_counter + 1;
                if (tq_counter == (TQ_NUM / 2)) begin
                    sample_point <= 1;
                end else begin
                    sample_point <= 0;
                end
                if (tq_counter >= (TQ_NUM - 1)) begin
                    tq_counter <= 0;
                end
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule