module handshake(
	input clk, 
	input rst,
	input [0:6] data_i, //from pre-stage
	input valid_i, //from pre-stage
	input ready_next, //The next-stage after slave(Not describe in this circut)
	output reg valid_o_slave,
	output reg ready_o_master, //ready out from master to pre-stage
	output reg valid_o_master, //master out valid
	output reg ready_o_slave, //ready out from slave to master
	output reg[0:6] data_master,
	output reg[0:6] data_slave //from slave
);

reg ready_reg;
reg valid_reg;
always@(posedge clk or negedge rst) //Master
begin
	if(!rst)
		begin
		ready_o_master <= 1'b1;
		valid_o_master <= 1'b0;
		data_master <= 7'b0;
		ready_reg <= 1;
		valid_reg <= 0;
		end
	else if(valid_i & ready_o_master)
		begin
		data_master <= data_i;
		valid_reg <= 1'b1; //To tell the slave that master have already to transfer the information
		valid_o_master <= valid_reg;
		ready_reg <= 1'b0;
		ready_o_master <= ready_reg; 
		end
	else if(valid_o_master & ready_o_slave)
		begin
		ready_reg <= 1'b1;
		ready_o_master <= ready_reg; //Ready to receive data
		valid_reg <= 1'b0;
		valid_o_master <= valid_reg; //The data has already transfer to slave
		end
end


always@(posedge clk or negedge rst) //slave
begin
	if(!rst)
	begin
	ready_o_slave <= 1'b1;
	data_slave <= 7'b0;
	end
	else if(valid_o_master & ready_o_slave)
	begin
	data_slave <= data_master;
	valid_o_slave <= 1'b1; 
	ready_o_slave <= 1'b0;
	end
	else if(valid_o_slave & ready_next)
	begin
	ready_o_slave <= 1'b1;
	valid_o_slave <= 1'b0;
	end
end


endmodule