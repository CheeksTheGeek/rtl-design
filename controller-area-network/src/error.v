module error_handling(
    input wire clk,
    input wire reset,
    input wire error_detected,
    output reg error_flag
);

    reg [7:0] error_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            error_counter <= 0;
            error_flag <= 0;
        end else begin
            if (error_detected) begin
                error_counter <= error_counter + 1;
                error_flag <= 1;
            end else begin
                error_flag <= 0;
            end
            if (error_counter >= 255) begin
                // Enter bus-off state
                // TODO: Implementation-dependent actions
            end
        end
    end

endmodule