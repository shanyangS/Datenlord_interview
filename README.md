# Datenlord_interview
 A interview's code that handshake.
 
 本代码依照面试要求，完成了一个基于AXI总线握手协议的场景示例电路。
 
 仿真波形图总体体现了总线高性能传输，无气泡，逐级反压，传输未丢数据。
 
 实现了假定valid或ready信号不满足时序要求，用寄存器打一拍。
 
  **另外，为了更好的描述设计思想，绘制了概念图加入到仓库中。**
 
## 2022-5-3 更新如下
采取了目前行业内最广泛应用的解决方案：**skid_buffer**来设计代码，并编写顶层模块进行链接例化。
参考链接：http://fpgacpu.ca/fpga/Pipeline_Skid_Buffer.html
 

 


### **(旧)**核心部分代码描述(2022-5-2，实现了一个流水线结构，但会丢失数据，打拍时产生数据丢失严重)
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
