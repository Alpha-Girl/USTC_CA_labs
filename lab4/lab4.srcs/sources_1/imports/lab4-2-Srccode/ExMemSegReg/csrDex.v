`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC 
// Engineer: Bingnan Chen (cbn990512@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: csrDex
// Tool Versions: Vivado 2017.4.1
// Description: CSR Register write back data for rd
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    //  EX\MEM wirte back value for csr
// 输入
    // clk               时钟信号
    //csrALU_out         csrALU的ex阶段算出写回csr寄存器的值
    // bubbleM           MEM阶段的bubble信号
    // flushM            MEM阶段的flush信号
// 输出
    // csrRegmem2       传给下一流水段的写回CSR寄存器值内容
// 实验要求
    // 自行设计

module csrDex(
    input wire clk, bubbleM, flushM,
    input wire [31:0] csrALU_out,
    output reg [31:0] csrRegmem2
    );

    initial csrRegmem2 = 0;
    
    always@(posedge clk)
        if (!bubbleM) 
        begin
            if (flushM)
                csrRegmem2 <= 0;
            else 
                csrRegmem2 <= csrALU_out;
        end
    
endmodule