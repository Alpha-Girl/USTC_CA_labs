`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC 
// Engineer: Bingnan Chen (cbn990512@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: csrAex
// Tool Versions: Vivado 2017.4.1
// Description: write back CSR Register's address 
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    //  EX\MEM csr wirte back address
// 输入
    // clk               时钟信号
    //csrALU_out         csrALU的ex阶段算出写回csr寄存器的值
    // bubbleM           MEM阶段的bubble信号
    // flushM            MEM阶段的flush信号
// 输出
    // csrRegmem2       传给下一流水段的写回CSR寄存器值内容
// 实验要求
    // 自行设计

module csrAddrex(
    input wire clk, bubbleM, flushM,
    input wire [11:0] csrAex,
    output reg [11:0] csrAmem
    );

    initial csrAmem = 0;
    
    always@(posedge clk)
        if (!bubbleM) 
        begin
            if (flushM)
                csrAmem <= 0;
            else 
                csrAmem <= csrAex;
        end
    
endmodule