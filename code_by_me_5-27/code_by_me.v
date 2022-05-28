`default_nettype none

module cy_skidbuffer
#
(
	parameter	DW = 8
)
(
	input	wire	i_clk, i_reset, i_valid,i_ready,		
	output	reg	o_valid,
	output	reg	o_ready,


	input	wire[DW-1:0]	i_data,
	output	reg[DW-1:0]	o_data
);

reg			r_valid;
reg[DW-1:0]		r_data;
reg			r_ready;

/* valid sequential section */
initial	r_valid = 0;
always@(posedge i_clk)
begin
if(i_reset)
	r_valid <= 0;
else if((i_valid && o_ready) && (o_valid && !i_ready))	//have incoming data, but the output is stalled
	r_valid <= 1;
else if(i_ready)	//data has already go
	r_valid <= 0;
end

/* ready sequential section */
always@(posedge i_clk)
begin
if(i_reset)
	r_ready <= 0;
if((i_valid && o_ready) && (o_valid && !i_ready))
	r_ready <= 1;
else if(i_ready)
	r_ready	= 0;
	o_ready = !r_ready;
end

/*always@(*)
	o_ready = !r_valid;  //o_ready to make the i_ready fit the sequence
*/
////////////////////////////////////////////////////////////////////////////////

/* when the data come in,copy it. */
always@(posedge i_clk) 
if(i_valid && o_ready) 
	r_data <= i_data;

initial	o_valid = 0;	//reg out
always@(posedge i_clk)
begin
if(i_reset)
	o_valid <= 0;
else if (!o_valid || i_ready)
	o_valid <= (i_valid || r_valid);
end

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

