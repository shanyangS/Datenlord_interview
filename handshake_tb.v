`timescale 1ns/1ps
module handshake_tb();
	reg clk,rst,valid_i,ready_next;
	reg[0:6] data_i;
	wire[0:6] data_master,data_slave;
	wire valid_o_slave,ready_o_master,valid_o_master,ready_o_slave;

handshake m1(
.clk(clk),
.rst(rst),
.data_i(data_i),
.valid_i(valid_i),
.ready_next(ready_next),
.valid_o_slave(valid_o_slave),
.ready_o_master(ready_o_master),
.valid_o_master(valid_o_master),
.ready_o_slave(ready_o_slave),
.data_master(data_master),
.data_slave(data_slave)
); 

 always #10 clk = ~clk;

  initial 
   begin
	clk = 1'b0;
	rst = 1'b0;
        #80 rst = 1'b1;
	#100 data_i <= 1011001; valid_i <= 1; ready_next <= 1; //Start
	#100 data_i <= 1110001; valid_i <= 1; ready_next <= 1;
	#100 data_i <= 1011011; valid_i <= 1; ready_next <= 1;
	#100 data_i <= 1111001; valid_i <= 1; ready_next <= 1;
	#100 data_i <= 1010001; valid_i <= 1; ready_next <= 1;
	#100 data_i <= 1000001; valid_i <= 1; ready_next <= 1;
	#100 data_i <= 1111111; valid_i <= 1; ready_next <= 1;
	#100 $stop;
   end

endmodule