`timescale 1ns / 1ps

module can(
    input wire clk,            // System clock
    input wire reset,          // System reset
    input wire can_rx,         // CAN bus receive line
    output wire can_tx,        // CAN bus transmit line
    input wire [10:0] id,      // Identifier for arbitration
    input wire [63:0] data_in, // Data to be transmitted
    input wire send_request    // Signal to initiate transmission
);

    wire baud_clk;
    wire tx_ready;
    wire [14:0] crc_out;
    wire one_shot_pulse;
    wire arbitration_grant;
    wire tx_busy;
    wire rx_busy;
    wire [63:0] data_out;

    // Baud Rate Generator
    baud_gen baud_gen_inst(
        .clk(clk),
        .reset(reset),
        .baud_clk(baud_clk)
    );

    // One-Shot Pulse Generator
    one_shot one_shot_inst(
        .clk(clk),
        .reset(reset),
        .trigger(send_request),
        .pulse_out(one_shot_pulse)
    );

    // Arbitration Module
    arbitration arbitration_inst(
        .clk(clk),
        .reset(reset),
        .id(id),
        .start_arbitration(one_shot_pulse),
        .arbitration_grant(arbitration_grant),
        .can_rx(can_rx),
        .can_tx(can_tx)
    );

    // Transmitter Module
    can_tx can_tx_inst(
        .clk(clk),
        .reset(reset),
        .baud_clk(baud_clk),
        .id(id),
        .data_in(data_in),
        .send(arbitration_grant),
        .can_tx(can_tx),
        .busy(tx_busy),
        .crc_out(crc_out)
    );

    // Receiver Module
    can_rx can_rx_inst(
        .clk(clk),
        .reset(reset),
        .baud_clk(baud_clk),
        .can_rx(can_rx),
        .data_out(data_out),
        .busy(rx_busy)
    );

    // CRC Module
    crc crc_inst(
        .clk(clk),
        .reset(reset),
        .data_in({id, data_in}),
        .crc_out(crc_out)
    );

endmodule