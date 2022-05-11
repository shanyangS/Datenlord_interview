# 这是一个老版本的文件夹
这里包含了三个代码，这三个代码描述如下。
1. 第一个代码first_version实现了流水线结构，但其性能较低，且无法应对burst的情况，没有引入skid_buffer;
2. 第二个代码second_version引入了fifo结构的skid_buffer,代码性能高，但占用面积和成本过大；
3. 第三个代码without_fifo引入了无fifo的skid_buffer,但是代码不易懂，且结构有缺陷。
