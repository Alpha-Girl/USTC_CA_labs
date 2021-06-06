`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC 
// Engineer: Bingnan Chen (cbn990512@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: csrDid
// Tool Versions: Vivado 2017.4.1
// Description: CSR Register File output for ID\EX
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    //  ID\EX寄存器文件取出数�?
// 输入
    // clk               时钟信号
    //csrRegid           CSR Register File读取的寄存器内容
    // bubbleE           EX阶段的bubble信号
    // flushE            EX阶段的flush信号
// 输出
    // csrRegex          传给下一流水段的CSR寄存器内�?
// 实验要求
    // 自行设计

module csrDid(
    input wire clk, bubbleE, flushE, 
    input wire [31:0] csrRegid, 
    output reg [31:0] csrRegex    
);

initial csrRegex = 0;

always @ (posedge clk)
    if(!bubbleE)
    begin
        if(flushE)
            csrRegex <= 0;
        else 
            csrRegex <= csrRegid;
    end

endmodule