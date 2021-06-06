`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC 
// Engineer: Bingnan Chen (cbn990512@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: CSRRegister
// Tool Versions: Vivado 2017.4.1
// Description: CSRRegister File
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    //  CSR寄存器，提供读写端口（同步写，异步读）
    //  时钟下降沿写入
// 输入
    // clk               时钟信号
    // rst               寄存器重置信号
    // write_en          寄存器写使能
    // addr              csrreg读地址
    // wb_addr           写回地址
    // wb_data           写回数据
// 输出
    // reg               csrreg读数据
// 实验要求
    // 自行设计

module CSRRegisterFile(
    input wire clk, 
    input wire rst, 
    input wire write_en, 
    input wire [11:0] addr, wb_addr, 
    input wire [31:0] wb_data, 
    output wire [31:0] csrreg
);

reg [31:0] csr_reg_file[4095:0];
integer i;

    // init register file
    initial
    begin
        for(i = 0; i < 4096; i = i + 1) 
            csr_reg_file[i][31:0] <= 32'b0;
    end

    // write in clk negedge, reset in rst posedge
    // if write register in clk posedge,
    // new wb data also write in clk posedge,
    // so old wb data will be written to register
    always@(negedge clk or posedge rst) 
    begin 
        if (rst)
            for (i = 0; i < 4096; i = i + 1) 
                csr_reg_file[i][31:0] <= 32'b0;
        else if(write_en)
            csr_reg_file[wb_addr] <= wb_data;   
    end

    // read data changes when address changes
    assign csrreg = csr_reg_file[addr];




endmodule