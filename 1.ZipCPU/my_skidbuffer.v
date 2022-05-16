module my_skidbuffer
#(
	parameter DW = 8;
	parameter [0:0] OPT_INITIAL = 1'b1
)
(
	input	wire			i_clk, i_reset,
	input	wire			i_valid,
	output	reg			o_ready,
	input	wire	[DW-1:0]	i_data,
	output	reg			o_valid,
	input	wire			i_ready,
	output	reg	[DW-1:0]	o_data
);

wire[DW-1:0] w_data;
reg r_valid;
reg [DW-1:0] r_data;

initial r_valid = 0;

always@(posedge i_clk)
if(i_reset)
	r_valid <= 0;
else if((i_valid && o_ready) && (o_valid && !i_ready))
	r_valid <= 1;
else if(i_ready)
	r_valid <= 0;

always@(posedge i_clk)
if(o_ready)
	r_data <= i_data;

always@(*)
	o_ready = !r_valid; //main point:equal


endmodule
