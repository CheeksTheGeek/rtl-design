`timescale 1ns / 1ps

module top_module;
    reg clk;
    reg rst;
    reg transmit_request;
    reg [10:0] msg_id;
    reg [7:0] data_length;
    reg [63:0] data_in;
    wire tx_complete;
    wire frame_received;
    wire [10:0] received_id;
    wire [7:0] received_data_length;
    wire [63:0] received_data;
    wire CAN_bus;

    // Instantiate the CAN controller
    can uut (
        .clk(clk),
        .rst(rst),
        .transmit_request(transmit_request),
        .msg_id(msg_id),
        .data_length(data_length),
        .data_in(data_in),
        .tx_complete(tx_complete),
        .frame_received(frame_received),
        .received_id(received_id),
        .received_data_length(received_data_length),
        .received_data(received_data),
        .CAN_bus(CAN_bus)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz clock

    initial begin
        // Initialize inputs
        rst = 1;
        transmit_request = 0;
        msg_id = 11'h7FF; // Highest priority message
        data_length = 8;
        data_in = 64'hDEADBEEFCAFEBABE;
        #20;
        rst = 0;
        #20;
        // Start transmission
        transmit_request = 1;
        #10;
        transmit_request = 0;
        // Wait for transmission to complete
        wait(tx_complete);
        // Wait for frame to be received
        wait(frame_received);
        // Display received data
        $display("Received ID: %h", received_id);
        $display("Received Data Length: %d", received_data_length);
        $display("Received Data: %h", received_data);
        #100;
        $stop;
    end

endmodule