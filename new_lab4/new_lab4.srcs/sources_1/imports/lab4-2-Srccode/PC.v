`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: PC
// Tool Versions: Vivado 2017.4.1
// Description: RV32I PC Module
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    // 存储当前流水线需要执行的指令地址
// 输入
    // clk               时钟信号
    // NPC               NPC_Generator生成的下�?条指令地�?
// 输出
    // PC                流水线需要处理的指令地址
// 实验要求  
    // 无需修改


module PC_IF(
    input wire clk, bubbleF, flushF,
    input wire [31:0] NPC,
    output reg [31:0] PC
    );

    initial PC = 0;
    
    always@(posedge clk)
        if (!bubbleF) 
        begin
            if (flushF)
                PC <= 0;
            else 
                PC <= NPC;
        end
    

endmodule