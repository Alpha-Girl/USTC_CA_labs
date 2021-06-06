`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: Op2_EX
// Module Name: Operator 2 Seg Reg
// Tool Versions: Vivado 2017.4.1
// Description: Operator 2 Seg Reg for ID\EX
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    // ID\EX的操作数1段寄存器
// 输入
    // clk               时钟信号
    // op2               General Register File读取的寄存器2内容，或者是立即数
    // bubbleE           EX阶段的bubble信号
    // flushE            EX阶段的flush信号
// 输出
    // reg_or_imm       传给下一流水段的操作数2内容（寄存器2或者是立即数）
// 实验要求  
    // 无需修改


module Op2_EX(
    input wire clk, bubbleE, flushE,
    input wire [31:0] op2,
    output reg [31:0] reg_or_imm
    );

    initial reg_or_imm = 0;
    
    always@(posedge clk)
        if (!bubbleE) 
        begin
            if (flushE)
                reg_or_imm <= 0;
            else 
                reg_or_imm <= op2;
        end
    
endmodule