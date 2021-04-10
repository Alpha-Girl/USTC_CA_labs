# Lab1 实验文档

## 实验说明 
本次实验是 RV32I Core 设计的铺垫。我们提供了一个样例 RV32I Core 的设计图，参考设计图，理解每条指令需要的数据通路，以及相应的控制信号，并回答相应问题。

## 主要内容
提交一个**设计报告**。参考 Design_Figure 文件夹中提供的 RV32I Core 设计图，思考每条指令的数据通路，如何用 verilog 简洁高效的表达这些逻辑电路。 
Lab2 会给出 RV32I Core 的 Verilog 代码框架，大家只需要完成部分模块的代码即可。

## 待实现指令
RISC-V 32bit 整型指令集（除去FENCE,FENCE.I,CSR,ECALL 和 EBREAK 指令） 
* 可参考官方提供的 RISCV 用户指令集手册（中文版或者英文版）
* Reference 文件夹下的 [inst.md](https://git.ustc.edu.cn/Ithaqua/ustc_ca2021_lab/-/blob/master/References/insts.md) 文档提供了指令描述（存在的问题欢迎大家指正）

## 设计原则 
* 你可以完全按照我们提供的设计图，补全模块内部逻辑完成 CPU 设计； 
* 也可以根据你的个人理解对设计模块图做出相应修改，并在报告中提出你自己的改进方 案并给出修改原因（报告内容的问题基于你修改后的设计图进行回答）。

## 报告内容
请在报告中回答下述问题： 
1. 描述执行一条 XOR 指令的过程（数据通路、控制信号等）。 
2. 描述执行一条 BEQ 指令的过程·（数据通路、控制信号等）。 
3. 描述执行一条 LHU 指令的过程（数据通路、控制信号等）。 
4. 如果要实现 CSR 指令（csrrw，csrrs，csrrc，csrrwi，csrrsi，csrrci），设计图中还需要增 加什么部件和数据通路？给出详细说明。 
5. Verilog 如何实现立即数的扩展？ 
6. 如何实现 Data Memory 的非字对齐的 Load 和 Store？ 
7. ALU 模块中，默认 wire 变量是有符号数还是无符号数？ 
8. 简述BranchE信号的作用。 
9. NPC Generator 中对于不同跳转 target 的选择有没有优先级？ 
10. Harzard 模块中，有哪几类冲突需要插入气泡，分别使流水线停顿几个周期？ 
11. Harzard 模块中采用静态分支预测器，即默认不跳转，遇到 branch 指令时，如何控制 flush 和 stall 信 号？ 
12. 0 号寄存器值始终为 0，是否会对 forward 的处理产生影响？
