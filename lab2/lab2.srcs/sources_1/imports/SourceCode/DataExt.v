`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Wu Yuzhang
//
// Design Name: RISCV-Pipline CPU
// Module Name: DataExt
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Data Extension module
//////////////////////////////////////////////////////////////////////////////////
//功能说明
//DataExt是用来处理非字对齐load的情形，同时根据load的不同模式对Data Mem中load的数进行符号或者无符号拓展，组合逻辑电路
//输入
//IN                    是从Data Memory中load的32bit字
//LoadedBytesSelect     等价于AluOutM[1:0]，是读Data Memory地址的低两位，
//因为DataMemory是按字（32bit）进行访问的，所以需要把字节地址转化为字地址传给DataMem
//DataMem一次返回一个字，低两位地址用来从32bit字中挑选出我们需要的字节
//RegWriteW             表示不同的 寄存器写入模式 ，所有模式定义在Parameters.v中
//输出
//OUT表示要写入寄存器的最终值
//实验要求
//补全模块

`include "Parameters.v"
module DataExt(
           input wire [31: 0] IN,
           input wire [1: 0] LoadedBytesSelect,
           input wire [2: 0] RegWriteW,
           output reg [31: 0] OUT
       );
wire [31: 0] LoadByte_IN = (IN >> (ADDR * 32'h8)) & 32'hff;
wire [31: 0] LoadHalfWord_IN = (IN >> (ADDR * 32'h8)) & 32'hffff;
always @( * ) begin
    case (RegWriteW)
        :
            `NOREGWRITE:
            begin

            end
        `LB:
        begin
            OUT <= {{24{LoadByte_IN[7]}}, LoadByte_IN[7: 0]};
        end
        `LH:
        begin
            OUT <= {{16{LoadHalfWord_IN[15]}}, LoadHalfWord_IN[15: 0]};
        end
        `LW:
        begin
            OUT <= IN;
        end
        `LBU:
        begin
            OUT <= {24'h0, LoadByte_IN[7: 0]};
        end
        `LHU:
        begin
            OUT <= {16'h0, LoadHalfWord_IN[15: 0]};
        end
        default:
        begin

        end
    endcase
end

endmodule

