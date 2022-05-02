# Datenlord_interview
 A interview's code that handshake.
 本代码依照面试要求，完成了一个基于AXI总线握手协议的场景示例电路。
 ## 核心部分代码描述
 ```verilog
 always@(posedge clk or negedge rst) //This is master
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
		ready_reg <= 1'b0; //To fit the request that use register delay one beat
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


always@(posedge clk or negedge rst) //This is slave
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

## 示例图、波形图及文字描述
相关描述已经上传至本仓库，更具体的描述了所做的工作
