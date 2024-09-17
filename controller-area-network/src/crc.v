module can_crc(
    input wire clk,
    input wire reset,
    input wire crc_en,
    input wire data_bit,
    output reg [14:0] crc_out
);

    reg [14:0] crc_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc_reg <= 15'h0;
        end else if (crc_en) begin
            crc_reg <= next_crc(crc_reg, data_bit);
        end
    end

    assign crc_out = crc_reg;

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

endmodule