module cy_skidbuffer_top_tb
#
(
parameter DW = 8
)();
	reg i_clk, i_reset, up_val, dn_rdy_next_stage;
	reg[DW-1:0] up_bus;
	wire[DW-1:0] dn_bus_slave;
	wire up_rdy, dn_val_slave;
	
always #5 i_clk = ~i_clk;
	
cy_skidbuffer_top t1
(
.i_clk(i_clk),
.i_reset(i_reset),
.up_bus(up_bus),
.up_val(up_val),
.up_rdy(up_rdy),
.dn_rdy_next_stage(dn_rdy_next_stage),
.dn_val_slave(dn_val_slave),
.dn_bus_slave(dn_bus_slave)
);

  initial 
   begin
	i_clk = 1'b0;
	i_reset = 1'b1;
        #80 i_reset = 1'b0;
	#100 up_bus <= 8'b10110011; up_val <= 1'b1; dn_rdy_next_stage <= 1'b1; //Start
	#100 up_bus <= 8'b11100011; up_val <= 1'b1; dn_rdy_next_stage <= 1'b1;
	#100 up_bus <= 8'b10110011; up_val <= 1'b1; dn_rdy_next_stage <= 1'b1;
	#100 up_bus <= 8'b11111001; up_val <= 1'b1; dn_rdy_next_stage <= 1'b0;
	#100 up_bus <= 8'b10110001; up_val <= 1'b1; dn_rdy_next_stage <= 1'b1;
	#100 up_bus <= 8'b10000101; up_val <= 1'b1; dn_rdy_next_stage <= 1'b0;
	#100 up_bus <= 8'b11101111; up_val <= 1'b1; dn_rdy_next_stage <= 1'b1;
	#100 $stop;
   end

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
