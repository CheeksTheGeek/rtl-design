
module arbitration(
    input wire clk,                  // System clock
    input wire reset,                // System reset
    input wire [10:0] id,            // Identifier for arbitration
    input wire start_arbitration,    // Signal to start arbitration
    output reg arbitration_grant,    // Grant signal after winning arbitration
    input wire can_rx,               // CAN bus receive line
    output wire can_tx               // CAN bus transmit line (open-drain)
);

    reg [10:0] id_buffer;
    reg [3:0] bit_counter;
    reg arbitration_in_progress;

    assign can_tx = arbitration_in_progress ? id_buffer[10 - bit_counter] : 1'b1; // Open-drain behavior

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            arbitration_grant <= 0;
            bit_counter <= 0;
            arbitration_in_progress <= 0;
        end else if (start_arbitration) begin
            arbitration_in_progress <= 1;
            id_buffer <= id;
            bit_counter <= 0;
            arbitration_grant <= 0;
        end else if (arbitration_in_progress) begin
            if (bit_counter < 11) begin
                if (can_rx != id_buffer[10 - bit_counter]) begin
                    arbitration_in_progress <= 0; // Lost arbitration
                    arbitration_grant <= 0;
                end else begin
                    bit_counter <= bit_counter + 1;
                end
            end else begin
                arbitration_in_progress <= 0; // Won arbitration
                arbitration_grant <= 1;
            end
        end else begin
            arbitration_grant <= 0;
        end
    end

endmodule