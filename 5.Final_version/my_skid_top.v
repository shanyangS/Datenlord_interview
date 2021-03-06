module my_skid_top
#
(
parameter DW = 8
)
(
	input  wire	i_clk,
	input  wire	i_reset,
	input  wire[DW-1:0]	up_bus,
	input  wire	up_val,
	input  wire	dn_rdy_next_stage,

	output wire	up_rdy,
	output wire[DW-1:0]	dn_bus_slave,
	output wire	dn_val_slave


);

	wire	dn_val;
	wire	dn_rdy;
	wire[DW-1:0]	dn_bus;
  

my_skid master
(
.i_clk(i_clk),
.i_reset(i_reset),
.i_valid(up_val),
.i_ready(dn_rdy),
.o_ready(up_rdy),
.o_valid(dn_val),
.i_data(up_bus),
.o_data(dn_bus_slave)
);

my_skid slave
(
.i_clk(i_clk),
.i_reset(i_reset),
.i_valid(dn_val),
.i_ready(dn_rdy_next_stage),
.o_ready(dn_rdy),
.o_valid(dn_val_slave),
.i_data(dn_bus),
.o_data(dn_bus_slave)
);

endmodule
