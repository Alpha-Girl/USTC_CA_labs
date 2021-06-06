`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC 
// Engineer: Bingnan Chen (cbn990512@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: csrDwb
// Tool Versions: Vivado 2017.4.1
// Description: write back CSR Register data
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    //  MEM\WB write back csr value
// 输入
    // clk               时钟信号
    //csrRegmem2         MEM阶段写回csr的�??
    // bubbleW           MEM阶段的bubble信号
    // flushW            MEM阶段的flush信号
// 输出
    // csrRegwb       传给下一流水段的CSR寄存器�?�内�?
// 实验要求
    // 自行设计

module csrDwb(
    input wire clk, bubbleW, flushW,
    input wire [31:0] csrRegmem2,
    output reg [31:0] csrRegwb
    );

    initial csrRegwb = 0;
    
    always@(posedge clk)
        if (!bubbleW) 
        begin
            if (flushW)
                csrRegwb <= 0;
            else 
                csrRegwb <= csrRegmem2;
        end
    
endmodule