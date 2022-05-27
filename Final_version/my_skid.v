module my_skid
#
(
	parameter DW = 8
)
(
	input wire i_clk, i_reset, i_valid, i_ready,
	output reg o_ready, o_valid,
	input wire [DW-1:0] i_data,
	output reg [DW-1:0] o_data
);

	reg r_valid, r_ready;
	reg [DW-1:0] r_data;

initial r_valid = 0;

always@(posedge i_clk)
begin
if(i_reset)
	r_valid <= 0;
else if((i_valid && o_ready) && (o_valid && !i_ready)) //There is a data, but next-stage is stalled
	r_valid <= 1;
else if(i_ready)
	r_valid <= !i_ready;
end

always@(*)
	o_ready = !r_valid; //A great concise code

always@(posedge i_clk)
begin
if(o_ready)
	r_data <= i_data;
end


initial o_valid = 0;
always@(posedge i_clk)
	if(i_reset)
		o_valid <= 0;
	else if(!o_valid || i_ready) // "!(o_valid && !i_ready)"
		o_valid <= (i_valid || r_valid);
	////////////////////////////////////////

initial o_data = 0;
always@(posedge i_clk)
	if(i_reset)
		o_data <= 0;
	else if(!o_valid || i_ready) 
	begin
		if(r_valid)
			o_data <= r_data;
		else if(i_valid)
			o_data <= i_data;
		else
			o_data <= 0;
	end
	///////////////////////////////////////
	

endmodule

