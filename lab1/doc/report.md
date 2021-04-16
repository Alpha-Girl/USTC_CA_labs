

1. 描述执行一条 XOR 指令的过程（数据通路、控制信号等）。

   

2. 描述执行一条 BEQ 指令的过程·（数据通路、控制信号等）。

   

3. 描述执行一条 LHU 指令的过程（数据通路、控制信号等）。

   

4. 如果要实现 CSR 指令（csrrw，csrrs，csrrc，csrrwi，csrrsi，csrrci），设计图中还需要增加什么部件和数据通路？给出详细说明。

   如果要实现CSR（Control Status Register）指令,需要增加regfile

5. Verilog 如何实现立即数的扩展？

   对于位数位`len`的立即数`imm[len-1:0]`扩展到`len_extend`位，只需根据立即数的最高位进行扩展，一个实现的例子如下：

   `assign ex_data=instruct[15]?{16'hffff,instruct[15:0]}:{16'h0000,instruct[15:0]};`

6. 如何实现 Data Memory 的非字对齐的 Load 和 Store？

   将

7. ALU 模块中，默认 wire 变量是有符号数还是无符号数？

   无符号数

8. 简述BranchE信号的作用。

9. NPC Generator 中对于不同跳转 target 的选择有没有优先级？

   有

10. Harzard 模块中，有哪几类冲突需要插入气泡，分别使流水线停顿几个周期？

11. Harzard 模块中采用静态分支预测器，即默认不跳转，遇到 branch 指令时，如何控制 flush 和 stall 信号？

12. 0 号寄存器值始终为 0，是否会对 forward 的处理产生影响？

    会，在forward中需要加入判断是否为0号寄存器，输出一个选择信号，若为0号寄存器，则输出0.