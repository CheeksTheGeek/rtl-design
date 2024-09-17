module can_receiver(
    input wire clk,
    input wire baud_clk,
    input wire reset,
    input wire CAN_RX,
    output reg [7:0] data_out,
    output reg rx_busy
);

    // Receiver FSM states
    parameter IDLE = 0,
              START_OF_FRAME = 1,
              RECEIVE_ID = 2,
              RTR = 3,
              IDE = 4,
              RESERVED_BIT = 5,
              DLC = 6,
              RECEIVE_DATA = 7,
              CRC = 8,
              CRC_DELIMITER = 9,
              ACK_SLOT = 10,
              ACK_DELIMITER = 11,
              END_OF_FRAME = 12,
              INTERFRAME_SPACE = 13;

    reg [3:0] state;
    reg [3:0] bit_counter;
    reg [7:0] data_buffer;
    reg [10:0] id_buffer;
    reg [14:0] crc_reg;

    always @(posedge baud_clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            rx_busy <= 0;
            bit_counter <= 0;
            crc_reg <= 15'h0;
            data_out <= 8'h00;
        end else begin
            case (state)
                IDLE: begin
                    rx_busy <= 0;
                    if (CAN_RX == 1'b0) begin // Start of Frame detected
                        state <= START_OF_FRAME;
                        rx_busy <= 1;
                    end
                end
                START_OF_FRAME: begin
                    state <= RECEIVE_ID;
                    bit_counter <= 10;
                end
                RECEIVE_ID: begin
                    id_buffer[bit_counter] <= CAN_RX;
                    // Update CRC
                    crc_reg <= next_crc(crc_reg, CAN_RX);
                    if (bit_counter == 0)
                        state <= RTR;
                    else
                        bit_counter <= bit_counter - 1;
                end
                RTR: begin
                    // Save RTR bit
                    // Update CRC
                    crc_reg <= next_crc(crc_reg, CAN_RX);
                    state <= IDE;
                end
                IDE: begin
                    // Save IDE bit
                    // Update CRC
                    crc_reg <= next_crc(crc_reg, CAN_RX);
                    state <= RESERVED_BIT;
                end
                RESERVED_BIT: begin
                    // Save reserved bit
                    // Update CRC
                    crc_reg <= next_crc(crc_reg, CAN_RX);
                    state <= DLC;
                    bit_counter <= 3;
                end
                DLC: begin
                    // Read DLC bits
                    // Update CRC
                    crc_reg <= next_crc(crc_reg, CAN_RX);
                    if (bit_counter == 0)
                        state <= RECEIVE_DATA;
                    else
                        bit_counter <= bit_counter - 1;
                end
                RECEIVE_DATA: begin
                    data_buffer[7] <= CAN_RX;
                    data_buffer <= {data_buffer[6:0], 1'b0};
                    crc_reg <= next_crc(crc_reg, CAN_RX);
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 7) begin
                        data_out <= data_buffer;
                        state <= CRC;
                        bit_counter <= 14;
                    end
                end
                CRC: begin
                    // Read CRC bits
                    if (bit_counter == 0)
                        state <= CRC_DELIMITER;
                    else
                        bit_counter <= bit_counter - 1;
                end
                CRC_DELIMITER: begin
                    state <= ACK_SLOT;
                end
                ACK_SLOT: begin
                    // Transmitter will send recessive bit
                    state <= ACK_DELIMITER;
                end
                ACK_DELIMITER: begin
                    state <= END_OF_FRAME;
                    bit_counter <= 6;
                end
                END_OF_FRAME: begin
                    if (bit_counter == 0)
                        state <= INTERFRAME_SPACE;
                    else
                        bit_counter <= bit_counter -1;
                end
                INTERFRAME_SPACE: begin
                    rx_busy <= 0;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    // CRC Calculation Function
    function [14:0] next_crc;
        input [14:0] crc;
        input data_bit;
        reg [14:0] crc_next;
        begin
            crc_next[14] = crc[13] ^ data_bit;
            crc_next[13] = crc[12];
            crc_next[12] = crc[11];
            crc_next[11] = crc[10];
            crc_next[10] = crc[9];
            crc_next[9]  = crc[8];
            crc_next[8]  = crc[7];
            crc_next[7]  = crc[6];
            crc_next[6]  = crc[5];
            crc_next[5]  = crc[4];
            crc_next[4]  = crc[3] ^ crc[13] ^ data_bit;
            crc_next[3]  = crc[2];
            crc_next[2]  = crc[1];
            crc_next[1]  = crc[0];
            crc_next[0]  = crc[13] ^ data_bit;
            next_crc = crc_next;
        end
    endfunction
    // TODO: move crc to separate module

endmodule