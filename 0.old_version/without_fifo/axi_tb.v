`timescale 1ns/1ps
module axi_tb();
	parameter DATA_WIDTH = 7;
	reg clk,rst,up_val,dn_rdy_next_stage;
	reg[DATA_WIDTH-1:0] up_bus;
	wire up_rdy,dn_val_slave;
	wire[DATA_WIDTH-1:0] dn_bus_slave;

 	always #10 clk = ~clk;

axi_top tb
(
.clk(clk),
.rst(rst),
.up_bus(up_bus),
.up_val(up_val),
.up_rdy(up_rdy),
.dn_rdy_next_stage(dn_rdy_next_stage),
.dn_val_slave(dn_val_slave),
.dn_bus_slave(dn_bus_slave)
);

  initial 
   begin
	clk = 1'b0;
	rst = 1'b1;
        #80 rst = 1'b0;
	#100 up_bus <= 1011001; up_val <= 1; dn_rdy_next_stage <= 1; //Start
	#100 up_bus <= 1110001; up_val <= 1; dn_rdy_next_stage <= 1;
	#100 up_bus <= 1011011; up_val <= 0; dn_rdy_next_stage <= 1;
	#100 up_bus <= 1111001; up_val <= 1; dn_rdy_next_stage <= 0;
	#100 up_bus <= 1010001; up_val <= 0; dn_rdy_next_stage <= 1;
	#100 up_bus <= 1000001; up_val <= 1; dn_rdy_next_stage <= 0;
	#100 up_bus <= 1111111; up_val <= 1; dn_rdy_next_stage <= 1;
	#100 $stop;
   end

endmodule

//  /*output reg*/  wire[DATA_WIDTH-1:0]    dn_bus;
//    /*output reg */     wire                dn_val;
//    /*input reg*/wire                     dn_rdy;
/*
module top
  #(parameter
    DATA_WIDTH = 32)
   (input  wire                     clk,
    input  wire                     rst,
    input  wire [DATA_WIDTH-1:0]    up_bus,
    input  wire                     up_val,
    output reg                      up_rdy,
    output reg  [DATA_WIDTH-1:0]    dn_bus,
    output reg                      dn_val,
    input  wire                     dn_rdy,

    output reg  [DATA_WIDTH-1:0]    dn_bus_slave,
    output reg                      dn_val_slave,
    input  wire                     dn_rdy_next_stage

*/