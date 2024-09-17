`timescale 1ns / 1ps
module single_pulse
    input wire clk,         // System clock
    input wire reset,       // System reset
    input wire trigger,     // Trigger input
    output reg pulse_out    // One-shot pulse output
);

    reg triggered;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse_out <= 0;
            triggered <= 0;
        end else if (trigger && !triggered) begin
            pulse_out <= 1;
            triggered <= 1;
        end else begin
            pulse_out <= 0;
            if (!trigger)
                triggered <= 0;
        end
    end

endmodule