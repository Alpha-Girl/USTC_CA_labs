`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Bingnan Chen (cbn990512@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: csrALU
// Tool Versions: Vivado 2017.4.1
// Description: Arithmetic and logic computation module for csr
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    //  算数运算和�?�辑运算功能部件
// 输入
    // op1               第一个操作数, rs1的�??:写入CSR的�??/说明CSR哪些位被置位
    // op2               第二个操作数, csr�?
    // op3               第三个操�?, 5位的rs1位置对应的�??
    // csrALU_func          运算类型
// 输出
    // ALU_out           运算结果
// 实验要求
    // 自行设计

`include "Parameters.v"   
module csrALU(
    input wire [31:0] op1,
    input wire [31:0] op2,
    input wire [4:0] op3,
    input wire [2:0] csrALU_func,
    output reg [31:0] ALU_out
    );
    //wire [31:0] op3_extend;
    //assign op3_extend = {27'd0, op3};
    // TODO: Complete this module
    always @ (*)
        begin
            case (csrALU_func)
                `CSRRW:     ALU_out <= op1 ;
                `CSRRS:     ALU_out <= op1 | op2;
                `CSRRC:     ALU_out <= (~op1) & op2;
                `CSRRWI:    ALU_out <= {27'd0, op3};
                `CSRRSI:    ALU_out <= op2 | {27'd0, op3};
                `CSRRCI:    ALU_out <= op2 & ~{27'd0, op3};
                default:    ALU_out <= 32'd0;
            endcase
        end
endmodule

