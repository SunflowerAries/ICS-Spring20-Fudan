/**
 * en         : en in cache module
 * cw_en      : cache writing enable signal, from w_en in cache module
 * hit, dirty : from set module
 *
 * w_en       : writing enable signal to cache line
 * mw_en      : writing enable signal to memory , controls whether to write to memory
 * set_valid  : control signal for cache line
 * set_dirty  : control signal for cache line
 * offset_sel : control signal for cache line and this may be used in other places
 */
module cache_controller #(
	parameter OFFSET_WIDTH = `CACHE_B
)(
	input  clk, reset, en, cw_en, hit, dirty, // mready,
	output w_en, set_valid, set_dirty, mw_en,
	output [OFFSET_WIDTH - 3:0] block_offset,
	output strategy_en,
	output reg offset_sel
);

/**
 * TODO: Your code here
 */

endmodule
