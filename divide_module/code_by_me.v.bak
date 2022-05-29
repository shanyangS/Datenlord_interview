`default_nettype none

module cy_skidbuffer
#
(
	parameter	DW = 8
)
(
	input	wire	i_clk, i_reset, i_valid,i_ready,		
	output	wire	o_valid,
	output	wire	o_ready,


	input	wire[DW-1:0]	i_data,
	output	reg[DW-1:0]	o_data
);

reg[DW-1:0]		r_data;
wire	r_valid;

ready_dp r1
(
.i_clk(i_clk),
.i_reset(i_reset),
.i_valid(i_valid),
.i_ready(i_ready),
.o_valid(o_valid),
.o_ready(o_ready)
);

valid_dp v1
(
.i_clk(i_clk),
.i_reset(i_reset),
.i_valid(i_valid),
.i_ready(i_ready),
.o_valid(o_valid),
.o_ready(o_ready),
.r_valid(r_valid)
);

/* when the data come in,copy it. */
always@(posedge i_clk) 
if(i_valid && o_ready) 
	r_data <= i_data;

initial	o_data = 0;	//reg out
always @(posedge i_clk)
begin
	if (i_reset)
		o_data <= 0;
	else if (!o_valid || i_ready)	//reg_out //"!(o_valid && !i_ready)"
		begin
		if(r_valid)	
			o_data <= r_data;
		else
			o_data <= i_data;
		end
end

endmodule

