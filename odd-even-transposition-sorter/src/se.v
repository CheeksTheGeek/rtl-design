`timescale 1ns / 1ps
/**
 * Macros
 * - CAS(a, b) : Conditional Assignment : as we're building a sorting engine with largest value at smallest index, 
 *                                        if a is less than b, swap, otherwise same
 * - IDXCHUNKS(x) : Indexing Chunks, returns DATAWIDTH bits of Data From Array 
 * - IDX_PAIRS(x) : Indexing Pairs, returns i'th and i+1'th element of the given array
 * - HALF(n) : Half Value : for 10, it will return 5, for 11, it will return 6
**/

`define CAS(a, b) a < b ? {b, a} : {a, b}
`define IDXCHUNKS(x) x[(i+1)*DATAWIDTH-1:i*DATAWIDTH]
`define IDX_PAIRS(x) x[i], x[i+1]
`define HALF(n) (n+1)/2// (n+1)/2 Works completely fine on Icarus Verilog but on Synopsis VCS, it gives an error, so I had to use (n)/2 + 1
/**
 * @brief Sorting Engine Module
 * 
 * @param DATAWIDTH : Width of the data bus
 * @param ARRAYLENGTH : Number of elements in the array
 * 
 * @param clk : Clock Signal
 * @param valid_in : Valid Input Signal
 * @param array_in : Input Array
 * @param array_out : Output Array
 * @param valid_out : Valid Output Signal
 * NOTE FOR EXPECTED CYCLES: - the sorting is done in is done in n/2 + 1 cycles, but holds the valid_out signal for an additional clock cycle
 *     - (n+1)/2 Works completely fine on Icarus Verilog but on Synopsis VCS, it gives an error, so I had to use (n)/2 + 1
 */
module SE #(parameter DATAWIDTH=8, ARRAYLENGTH=10)( 
    input clk, valid_in, 
    input  [DATAWIDTH*ARRAYLENGTH-1:0] array_in, 
    output reg [DATAWIDTH*ARRAYLENGTH-1:0] array_out, 
    output valid_out
);
    reg [DATAWIDTH-1:0] data [ARRAYLENGTH-1:0]; // DATAWIDTH bit wide array with depth ARRAYLENGTH : Array To Be Sorted
    reg [`HALF(ARRAYLENGTH):0] shift_reg = 0; // Shift Register to keep track of the number of iterations
    // since the 0th index is taken up by the valid_in initial value, we require (n)/2 + 1 spots
    
    generate for(genvar i=0; i < ARRAYLENGTH; i=i+1) begin : sorting_engine
        always @(posedge (clk & valid_in)) 
            data[i] <= `IDXCHUNKS(array_in); // Assign the input array to the data array
        // Sorting Logic : Even And Odd Stages
        if (i+1 < ARRAYLENGTH) 
            if (i%2) 
                always @(`IDX_PAIRS(data)) 
                    {`IDX_PAIRS(data)} = `CAS(data[i], data[i+1]);
            else always @(posedge clk) 
                {`IDX_PAIRS(data)} <= `CAS(data[i], data[i+1]);
        always @(data[i]) `IDXCHUNKS(array_out) = data[i]; // Assigning The Output Array
    end
    endgenerate
    // Shift Register : replaces the iteration counter, by taking in the valid_in signal as a left shift value, 
    //                  and is paired with an assign statement which syncs the highest index of the shift 
    //                  register with the valid_out signal
    always @(posedge clk) 
        shift_reg <= valid_in ? {1'b1} : {shift_reg, 1'b0};  // As long as valid_in is off, the shift register will keep shifting left
    assign valid_out = shift_reg[`HALF(ARRAYLENGTH)]; // Assigning the valid_out signal by syncing the highest index of the shift register
endmodule