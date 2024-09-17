module bit_stuffing(
    input wire clk,
    input wire rst,
    input wire data_in,
    input wire data_valid,
    output reg data_out,
    output reg data_out_valid
);

    reg [2:0] bit_counter;
    reg last_bit;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_counter <= 0;
            last_bit <= 1'b1;
            data_out <= 0;
            data_out_valid <= 0;
        end else if (data_valid) begin
            if (data_in == last_bit) begin
                bit_counter <= bit_counter + 1;
                if (bit_counter == 5) begin
                    // Insert stuff bit (opposite of last_bit)
                    data_out <= ~last_bit;
                    data_out_valid <= 1;
                    bit_counter <= 0;
                end else begin
                    data_out <= data_in;
                    data_out_valid <= 1;
                end
            end else begin
                bit_counter <= 1;
                data_out <= data_in;
                data_out_valid <= 1;
            end
            last_bit <= data_in;
        end else begin
            data_out_valid <= 0;
        end
    end

endmodule