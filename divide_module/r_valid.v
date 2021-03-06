module valid_dp
(
	input	wire	i_clk, i_reset, i_valid, i_ready, o_ready,
	output	reg	o_valid, r_valid
);

initial r_valid = 0;
always@(posedge i_clk)
begin
	if(i_reset)
		r_valid <= 0;
	else if((i_valid && o_ready) && (o_valid && !i_ready))	//have incoming data, but the output is stalled
		r_valid <= 1;
	else if(i_ready)	//data has already go
		r_valid <= 0;
end



initial	o_valid = 0;	//reg out
always@(posedge i_clk)
	begin
		if(i_reset)
			o_valid <= 0;
		else if (!o_valid || i_ready)
			o_valid <= (i_valid || r_valid);
	end

endmodule