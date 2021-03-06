module single_tb
#
(
parameter DW = 8
)();
	reg i_clk, i_reset, i_valid, i_ready;
	reg[DW-1:0] i_data;
	wire[DW-1:0] o_data;
	wire o_ready, o_valid;
	
always #5 i_clk = ~i_clk;
	
cy_skidbuffer t1
(
.i_clk(i_clk),
.i_reset(i_reset),
.i_valid(i_valid),
.i_ready(i_ready),
.i_data(i_data),
.o_data(o_data),
.o_ready(o_ready),
.o_valid(o_valid)
);

  initial 
   begin
	i_clk = 1'b0;
	i_reset = 1'b1;
        #80 i_reset = 1'b0;
	#100 i_data <= 8'b10110011; i_valid <= 1'b1; i_ready <= 1'b1; //Start
	#100 i_data <= 8'b11100011; i_valid <= 1'b1; i_ready <= 1'b1;
	#100 i_data <= 8'b10110011; i_valid <= 1'b1; i_ready <= 1'b1;
	#100 i_data <= 8'b11111001; i_valid <= 1'b1; i_ready <= 1'b0;
	#100 i_data <= 8'b10110001; i_valid <= 1'b1; i_ready <= 1'b1;
	#100 i_data <= 8'b10000101; i_valid <= 1'b1; i_ready <= 1'b0;
	#100 i_data <= 8'b11101111; i_valid <= 1'b1; i_ready <= 1'b1;
	#100 $stop;
   end

endmodule

