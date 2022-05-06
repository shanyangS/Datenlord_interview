module axi_top
  #(parameter
    DATA_WIDTH = 7)
   (input  wire                     clk,
    input  wire                     rst,
    input  wire [DATA_WIDTH-1:0]    up_bus,
    input  wire                     up_val,
    output wire                      up_rdy,
	
    output wire  [DATA_WIDTH-1:0]    dn_bus_slave,
    output wire                      dn_val_slave,
    input  wire                     dn_rdy_next_stage

);

	wire dn_val;
	wire dn_rdy;
	wire[DATA_WIDTH-1:0] dn_bus;
  


skid_register master(.clk(clk),.rst(rst),.up_bus(up_bus),.up_val(up_val),.up_rdy(up_rdy),.dn_bus(dn_bus),.dn_val(dn_val),.dn_rdy(dn_rdy));
skid_register slave(.clk(clk),.rst(rst),.up_bus(dn_bus),.up_val(dn_val),.up_rdy(dn_rdy),.dn_bus(dn_bus_slave),.dn_val(dn_val_slave),.dn_rdy(dn_rdy_next_stage));

endmodule

/*  (input  wire                     clk,
    input  wire                     rst,

    input  wire [DATA_WIDTH-1:0]    up_bus,
    input  wire                     up_val,
    output reg                      up_rdy,

    output reg  [DATA_WIDTH-1:0]    dn_bus,
    output reg                      dn_val,
    input  wire                     dn_rdy (next_stage)
);*/