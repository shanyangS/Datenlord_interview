# Datenlord_interview
 A interview's code that handshake.

 本代码依照面试要求，完成了一个基于AXI总线握手协议的场景示例电路。

 仿真波形图总体体现了总线高性能传输，无气泡，逐级反压，传输未丢数据。

 实现了假定valid或ready信号不满足时序要求，用寄存器打一拍。

  另外，为了更好的描述设计思想，绘制了概念图加入到仓库中。



## 2022-5-21更新如下 

此次更新，将自己编写的代码更新到Final_version文件夹之中，并加入仿真及顶层模块，进行了仿真验证，结果表明符合要求，仿真截图存储在Final_version中的wave_example文件夹。



## 2022-5-11更新如下

此次更新将所有旧代码移动至old_version文件夹。并创建了四个新的文件夹，更新了四个新的代码结构，并添加了这四个结构的对比图，代码整理来源自https://jia.je/hardware/2021/01/26/skid-buffer/。



四个代码的对比截图自上述博客。



**ZipCPU版本没有使用FIFO，且性能出色，并且可以增加额外的寄存器确保输出为寄存器输出，采用此版本代码作为范例。**

### 1. ZipCPU版本

此代码来源于ZipCPU：https://zipcpu.com/blog/2019/05/22/skidbuffer.html，代码地址为：https://github.com/ZipCPU/wb2axip/blob/master/rtl/skidbuffer.v



这个结构的额外参数有两个：是否有额外的输出寄存器(outputreg)，以及是否低功耗(lowPower)。额外的输出寄存器可以确保输出由寄存器来输出，保证时序电路的要求。



### 2. FPGACPU版本

此代码来源于http://fpgacpu.ca/fpga/Pipeline_Skid_Buffer.html，引入了FIFO，并且将skid_buffer扩展为两个寄存器，有一个是备用的寄存器，来应对大量数据同时输入的情况



### 3. SpinalHDL S2M

SpinalHDL Library的s2mPipe，与ZipCPU不引入额外的输出寄存器的情况实现思想相同。



### 4. SpinalHDL M2S

SpinalHDL Library的m2sPipe，输入的ready为组合逻辑，输出为寄存器输出。

## 2022-5-3 更新如下
采取了目前行业内最广泛应用的解决方案：**skid_buffer**来设计代码，并编写顶层模块进行链接例化。
参考链接：http://fpgacpu.ca/fpga/Pipeline_Skid_Buffer.html
这是一个非常出色的行业标准解决方案，具体描述如下：
1. 定义了BUFFER和data_in寄存器，当data_in满了之后，采用BUFFER作为缓存，以应对burst的情景
2. 定义了一个状态机，使得丢失数据成为不可能（当BUFFER满了之后，将禁止插入数据）


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
