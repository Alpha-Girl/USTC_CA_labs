`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC 
// Engineer: Bingnan Chen (cbn990512@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: csrDwb
// Tool Versions: Vivado 2017.4.1
// Description: write back CSR Register address
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    //  MEM\WB write back csr address
// 输入
    // clk               时钟信号
    //csrAmem            MEM阶段写回csr的�??
    // bubbleW           MEM阶段的bubble信号
    // flushW            MEM阶段的flush信号
// 输出
    // csrAwb       传给下一流水段的CSR寄存器�?�内�?
// 实验要求
    // 自行设计

module csrAddrwb(
    input wire clk, bubbleW, flushW,
    input wire [31:0] csrAmem,
    output reg [31:0] csrAwb
    );

    initial csrAwb = 0;
    
    always@(posedge clk)
        if (!bubbleW) 
        begin
            if (flushW)
                csrAwb <= 0;
            else 
                csrAwb <= csrAmem;
        end
    
endmodule