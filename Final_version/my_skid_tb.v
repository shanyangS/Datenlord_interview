module my_skid_tb
#
(
parameter DW = 8
)
();

	reg i_clk, i_reset, i_valid, i_ready;
	wire o_ready, o_valid,
	reg[DW-1:0] 



endmodule

/*
module my_skid
#
(
	parameter DW = 8,
	parameter OPT_OUTREG = 1 //REG OUT, NOT COMB OUT
)
(
	input wire i_clk, i_reset, i_valid, i_ready,
	output reg o_ready, o_valid,
	input wire [DW-1:0] i_data,
	output reg [DW-1:0] o_data
);

*/