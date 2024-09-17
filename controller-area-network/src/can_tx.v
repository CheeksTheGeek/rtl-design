module can_transmitter(
    input wire clk,
    input wire baud_clk,
    input wire reset,
    input wire [10:0] id,
    input wire [7:0] data_in,
    input wire tx_start,
    input wire arbitration_lost,
    input wire bus_idle,
    output reg CAN_TX,
    output reg tx_busy,
    output reg [14:0] crc_out
);

    // Transmitter FSM states
    parameter IDLE = 0,
              START_OF_FRAME = 1,
              TRANSMIT_ID = 2,
              RTR = 3,
              IDE = 4,
              RESERVED_BIT = 5,
              DLC = 6,
              TRANSMIT_DATA = 7,
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
            CAN_TX <= 1'b1; // Recessive
            tx_busy <= 0;
            bit_counter <= 0;
            crc_reg <= 15'h0;
        end else begin
            case (state)
                IDLE: begin
                    CAN_TX <= 1'b1;
                    tx_busy <= 0;
                    if (tx_start && bus_idle) begin
                        state <= START_OF_FRAME;
                        tx_busy <= 1;
                        id_buffer <= id;
                        data_buffer <= data_in;
                        crc_reg <= 15'h0;
                    end
                end
                START_OF_FRAME: begin
                    CAN_TX <= 1'b0; // Dominant SOF
                    state <= TRANSMIT_ID;
                    bit_counter <= 10;
                end
                TRANSMIT_ID: begin
                    CAN_TX <= id_buffer[bit_counter];
                    // Update CRC
                    crc_reg <= next_crc(crc_reg, id_buffer[bit_counter]);
                    if (bit_counter == 0)
                        state <= RTR;
                    else
                        bit_counter <= bit_counter - 1;
                end
                RTR: begin
                    CAN_TX <= 1'b0; // Data Frame
                    crc_reg <= next_crc(crc_reg, 1'b0);
                    state <= IDE;
                end
                IDE: begin
                    CAN_TX <= 1'b0; // Standard frame
                    crc_reg <= next_crc(crc_reg, 1'b0);
                    state <= RESERVED_BIT;
                end
                RESERVED_BIT: begin
                    CAN_TX <= 1'b0; // Reserved bit
                    crc_reg <= next_crc(crc_reg, 1'b0);
                    state <= DLC;
                    bit_counter <= 3;
                end
                DLC: begin
                    CAN_TX <= 1'b0; // Data length code = 8 bytes
                    crc_reg <= next_crc(crc_reg, 1'b0);
                    if (bit_counter == 0)
                        state <= TRANSMIT_DATA;
                    else
                        bit_counter <= bit_counter - 1;
                end
                TRANSMIT_DATA: begin
                    CAN_TX <= data_buffer[7];
                    crc_reg <= next_crc(crc_reg, data_buffer[7]);
                    data_buffer <= {data_buffer[6:0], 1'b0};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 7) begin
                        state <= CRC;
                        bit_counter <= 14;
                    end
                end
                CRC: begin
                    CAN_TX <= crc_reg[bit_counter];
                    if (bit_counter == 0)
                        state <= CRC_DELIMITER;
                    else
                        bit_counter <= bit_counter - 1;
                end
                CRC_DELIMITER: begin
                    CAN_TX <= 1'b1; // Recessive
                    state <= ACK_SLOT;
                end
                ACK_SLOT: begin
                    CAN_TX <= 1'b1; // Wait for ACK
                    state <= ACK_DELIMITER;
                end
                ACK_DELIMITER: begin
                    CAN_TX <= 1'b1; // Recessive
                    state <= END_OF_FRAME;
                    bit_counter <= 6;
                end
                END_OF_FRAME: begin
                    CAN_TX <= 1'b1; // Recessive
                    if (bit_counter == 0)
                        state <= INTERFRAME_SPACE;
                    else
                        bit_counter <= bit_counter -1;
                end
                INTERFRAME_SPACE: begin
                    CAN_TX <= 1'b1;
                    tx_busy <= 0;
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