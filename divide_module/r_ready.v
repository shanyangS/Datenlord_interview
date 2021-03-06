module ready_dp
(
	input	wire	i_clk, i_reset, i_valid, i_ready, o_valid,
	output	reg	o_ready
);

reg r_ready;


always@(posedge i_clk)
begin
	if(i_reset)
		r_ready <= 0;
	else if((i_valid && o_ready) && (o_valid && !i_ready))
		r_ready <= 1;
	else if(i_ready)
		r_ready <= 0;
end

always@(*)
	o_ready <= !r_ready;

endmodule
