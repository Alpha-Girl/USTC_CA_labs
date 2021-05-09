`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Wu Yuzhang
//
// Design Name: RISCV-Pipline CPU
// Module Name: MEMSegReg
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: EX-MEM Segment Register
//////////////////////////////////////////////////////////////////////////////////
//功能说明
//MEMSegReg是EX-MEM段寄存器
//实验要求
//无需修改

module MEMSegReg(
           input wire clk,
           input wire en,
           input wire clear,
           //Data Signals
           input wire [31: 0] AluOutE,
           output reg [31: 0] AluOutM,
           input wire [31: 0] ForwardData2,
           output reg [31: 0] StoreDataM,
           input wire [4: 0] RdE,
           output reg [4: 0] RdM,
           input wire [31: 0] PCE,
           output reg [31: 0] PCM,
           //Control Signals
           input wire [2: 0] RegWriteE,
           output reg [2: 0] RegWriteM,
           input wire MemToRegE,
           output reg MemToRegM,
           input wire [3: 0] MemWriteE,
           output reg [3: 0] MemWriteM,
           input wire LoadNpcE,
           output reg LoadNpcM,
           //CSR Part
           input wire CSRreg_write_enE,
           input wire [31: 0] CSRregOutE,
           input wire [11: 0] CSRSrcE,
           output reg [11: 0] CSRSrcM,
           output reg CSRreg_write_enM,
           input wire [31: 0]CSRALU_out,
           output reg [31: 0] CSRreg_write_dataM
       );
initial
begin
    AluOutM = 0;
    StoreDataM = 0;
    RdM = 5'h0;
    PCM = 0;
    RegWriteM = 3'h0;
    MemToRegM = 1'b0;
    MemWriteM = 4'b0;
    LoadNpcM = 0;
    CSRSrcM = 12'b0;
    CSRreg_write_enM = 1'b0;
    CSRreg_write_dataM = 32'b0;
end

always@(posedge clk)
    if (en)
    begin
        if (clear)
            AluOutM <= 32'b0;
        else if (CSRreg_write_enE)
            AluOutM <= CSRregOutE;
        else
        begin
            AluOutM <= AluOutE;
        end
        StoreDataM <= clear ? 0 : ForwardData2;
        RdM <= clear ? 5'h0 : RdE;
        PCM <= clear ? 0 : PCE;
        RegWriteM <= clear ? 3'h0 : RegWriteE;
        MemToRegM <= clear ? 1'b0 : MemToRegE;
        MemWriteM <= clear ? 4'b0 : MemWriteE;
        LoadNpcM <= clear ? 0 : LoadNpcE;
        CSRSrcM <= clear ? 12'b0 : CSRSrcE;
        CSRreg_write_enM <= clear ? 0 : CSRreg_write_enE;
        CSRreg_write_dataM <= clear ? 32'b0 : CSRALU_out;
    end

endmodule
