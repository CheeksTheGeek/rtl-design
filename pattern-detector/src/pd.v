module PD (
    input clk,
    input reset,
    input enable,
    input [3:0] din,
    output reg pattern1,
    output reg pattern2
    );
    // state parameters, set to localparam (module-only scope) as no need for using full parameters as all testing is done in this module (if required), via display
    localparam S0 = 4'b0000, 
               S1_0 = 4'b0001, 
               S2_5 = 4'b0010, 
               S3_3 = 4'b0011, 
               S4_1 = 4'b0100, 
               T1_0 = 4'b0101, 
               T2_6 = 4'b0110, 
               T3_1 = 4'b0111, 
               T4_9 = 4'b1000;
    /*
    patterns: 0531 & 0619, named as S and T respectively
    S0 - default state
    S1_0 - pattern 1 - state for digit 0
    S2_5 - pattern 1 - state for digit 5
    S3_3 - pattern 1 - state for digit 3
    S4_1 - pattern 1 - state for digit 1
    T1_0 - pattern 2 - state for digit 0
    T2_6 - pattern 2 - state for digit 6
    T3_1 - pattern 2 - state for digit 1
    T4_9 - pattern 2 - state for digit 9
    */
    
    reg [3:0] state, next_state;
    
    // state migration
    always @ (posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // state logic
    always @ (*) begin
        // default next state (no transition)
        next_state = state;
        // boolean output for detection of pattern 1 and pattern 2
        pattern1 = 0;
        pattern2 = 0;
        // $display("State: %d, DIN: %d, Enable: %b", state, din, enable);
        case (state)
            S0: begin
                if (enable) begin
                    if (din == 4'd0)
                        next_state = S1_0;
                    else
                        next_state = S0;
                end
            end
            S1_0: begin
                if (enable) begin
                    if (din == 4'd5)
                        next_state = S2_5;
                    else if (din == 4'd6)
                        next_state = T2_6;
                    else if (din == 4'd0)
                        next_state = S1_0;
                    else
                        next_state = S0;
                end
            end
            S2_5: begin
                if (enable) begin
                    if (din == 4'd3)
                        next_state = S3_3;
                    else if (din == 4'd0)
                        next_state = S1_0;
                    else
                        next_state = S0;
                end
            end
            S3_3: begin
                if (enable) begin
                    if (din == 4'd1)
                        next_state = S4_1;
                    else if (din == 4'd0)
                        next_state = S1_0;
                    else
                        next_state = S0;
                end
            end
            S4_1: begin
                pattern1 = 1;
                if (enable)
                    if (din == 4'd0)
                        next_state = S1_0;
                    else
                        next_state = S0;
            end
            T2_6: begin
                if (enable) begin
                    if (din == 4'd1)
                        next_state = T3_1;
                    else if (din == 4'd0)
                        next_state = S1_0;
                    else
                        next_state = S0;
                end
            end
            T3_1: begin
                if (enable) begin
                    if (din == 4'd9)
                        next_state = T4_9;
                    else if (din == 4'd0)
                        next_state = S1_0;
                    else
                        next_state = S0;
                end
            end
            T4_9: begin
                pattern2 = 1;
                pattern1 = 0;
                if (enable)
                    if (din == 4'd0)
                        next_state = S1_0;
                    else
                        next_state = S0;
            end
            default: next_state = S0;
        endcase
    end
endmodule