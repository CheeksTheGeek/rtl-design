
module mst(
    input clock, reset, enable,
    output [7:0] wra, wrd, rda,
    output reg [7:0] rdd,
    output [8:0] t1attempts, t1fails, t2attempts, t2fails,
    output we, done
);
    wire [7:0] rddmem, data;
    memory u2 (.clock(clock), .reset(reset), .we(we), .wra(wra), .wrd(wrd), .rda(rda), .rdd(rddmem));
    reg [7:0] addr;
    reg [1:0] doneflags, wrv_sr; // doneflags is for test completion, wrv_sr is a shift register for moving from write-read and read-verify stages
    reg [8:0] t1fails_reg, t2fails_reg;
    always @(negedge clock) begin
        rdd <= {8{rddmem!==8'bx}} & rddmem; 
        if (reset) begin 
            {wrv_sr, addr, doneflags, t1fails_reg, t2fails_reg} <= 0;
        end else if (enable) begin
            wrv_sr <= {wrv_sr[0] & (~&doneflags), !wrv_sr & ~&doneflags}; // shift left, turns on write stage if not done
            if (wrv_sr[1]) begin // verify stage
                t1fails_reg <= (rddmem & !doneflags[0]) ? t1fails_reg + 1 : t1fails_reg; // increment t1fails_reg if read value is not 0 and test 1 is not done
                t2fails_reg <= (~&rddmem & doneflags[0]) ? t2fails_reg + 1 : t2fails_reg; // increment t2fails_reg if read value is not full and test 1 is done
                doneflags <= (&addr) ? {doneflags, 1'b1} : doneflags; // left shift doneflags if addr is full
                addr <= addr + 1;
            end
        end 
    end
    assign t1attempts = {doneflags[0], ({8{~doneflags[0]}} & addr)}; // if test 1 is done, 256, else addr
    assign data = {8{doneflags[0]}} & 8'hFF; // if test 1 is done, 255, else 0
    assign t2attempts = {&doneflags, {8{doneflags[0]}} & addr}; // if test 2 is going on, then addr, 
    assign {done, wrd, t1fails, t2fails, we, rda, wra} = {&doneflags, data, t1fails_reg, t2fails_reg, wrv_sr[0], {2{addr}}}; // sync outputs
endmodule