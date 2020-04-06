`include "cache.vh"
/**
 * w_en: write enable
 */
module line #(
	parameter TAG_WIDTH    = `CACHE_T,
		      OFFSET_WIDTH = `CACHE_B
)(
	input                        clk, reset,
	input  [OFFSET_WIDTH - 3:0]  offset,
	input                        w_en, set_valid, set_dirty,
	input  [TAG_WIDTH - 1:0]     set_tag,
	input  [31:0]                write_data,
	output reg                   valid,
	output                       dirty,
	output reg [TAG_WIDTH - 1:0] tag,
	output [31:0]                read_data
);

/**
 * TODO: Your code here
 */

endmodule
