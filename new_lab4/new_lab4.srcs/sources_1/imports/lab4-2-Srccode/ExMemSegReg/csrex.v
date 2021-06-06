`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC 
// Engineer: Bingnan Chen (cbn990512@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: csrex
// Tool Versions: Vivado 2017.4.1
// Description: CSR Register write back data for rd
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    //  EX\MEM csr value for rd
// 输入
    // clk               时钟信号
    //csrRegex           ex阶段写回rd的csr值
    // bubbleM           MEM阶段的bubble信号
    // flushM            MEM阶段的flush信号
// 输出
    // csrRegmem1       传给下一流水段的CSR寄存器值内容
// 实验要求
    // 自行设计

module csrex(
    input wire clk, bubbleM, flushM,
    input wire [31:0] csrRegex,
    output reg [31:0] csrRegmem1
    );

    initial csrRegmem1 = 0;
    
    always@(posedge clk)
        if (!bubbleM) 
        begin
            if (flushM)
                csrRegmem1 <= 0;
            else 
                csrRegmem1 <= csrRegex;
        end
    
endmodule