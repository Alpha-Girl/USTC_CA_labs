`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Control Signal Seg Reg
// Tool Versions: Vivado 2017.4.1
// Description: Control signal seg reg for ID\EX
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    // ID\EX的控制信号段寄存�??
// 输入
    // clk                  时钟信号
    // jalr_ID              jalr跳转指令
    // ALU_func_ID          ALU执行的运算类�??
    // br_type_ID           branch的判断条件，可以是不进行branch
    // load_npc_ID          写回寄存器的值的来源（PC或�?�ALU计算结果�??
    // wb_select_ID         写回寄存器的值的来源（Cache内容或�?�ALU计算结果�??
    // load_type_ID         load类型
    // src_reg_en_ID        指令中src reg的地�??是否有效
    // reg_write_en_ID      通用寄存器写使能
    // cache_write_en_ID    按字节写入data cache
    // alu_src1_ID          alu操作�??1来源，alu_src1 == 0表示来自reg1，alu_src1 == 1表示来自PC
    // alu_src2_ID          alu操作�??2来源，alu_src2 == 2’b00表示来自reg2，alu_src2 == 2'b01表示来自reg2地址，alu_src2 == 2'b10表示来自立即�??
    // bubbleE              EX阶段的bubble信号
    // flushE               EX阶段的flush信号
// 输出
    // jalr_EX              传给下一流水段的jalr跳转指令
    // ALU_func_EX          传给下一流水段的ALU执行的运算类�??
    // br_type_EX           传给下一流水段的branch的判断条件，可以是不进行branch
    // load_npc_EX          传给下一流水段的写回寄存器的值的来源（PC或�?�ALU计算结果�??
    // wb_select_EX         传给下一流水段的写回寄存器的值的来源（Cache内容或�?�ALU计算结果�??
    // load_type_EX         传给下一流水段的load类型
    // src_reg_en_EX        传给下一流水段的指令中src reg的地�??是否有效
    // reg_write_en_EX      传给下一流水段的通用寄存器写使能
    // cache_write_en_EX    传给下一流水段的按字节写入data cache
    // alu_src1_EX          传给下一流水段的alu操作�??1来源
    // alu_src2_EX          传给下一流水段的alu操作�??2来源

// 实验要求  
    // 无需修改




module Ctrl_EX(
    input wire clk, bubbleE, flushE,
    input wire jalr_ID,
    input wire [3:0] ALU_func_ID,
    input wire [2:0] br_type_ID,
    input wire load_npc_ID,
    input wire wb_select_ID,
    input wire [2:0] load_type_ID,
    input wire [1:0] src_reg_en_ID,
    input wire reg_write_en_ID,
    input wire [3:0] cache_write_en_ID,
    input wire alu_src1_ID,
    input wire [1:0] alu_src2_ID,
    input wire csrreg_write_en_ID,
    input wire [2:0] csrALU_func_ID, 
    input wire csrwb_select_ID, 
    output reg jalr_EX,
    output reg [3:0] ALU_func_EX,
    output reg [2:0] br_type_EX,
    output reg load_npc_EX,
    output reg wb_select_EX,
    output reg [2:0] load_type_EX,
    output reg [1:0] src_reg_en_EX,
    output reg reg_write_en_EX,
    output reg [3:0] cache_write_en_EX,
    output reg alu_src1_EX,
    output reg [1:0] alu_src2_EX, 
    output reg csrreg_write_en_EX, 
    output reg [2:0] csrALU_func_EX, 
    output reg csrwb_select_EX, 
    input  wire [6:0] Opcode_ID, 
    output reg  [6:0] Opcode_EX, 
    input wire PredictD, 
    output reg PredictE
    );

    initial 
    begin
        jalr_EX = 0;
        ALU_func_EX = 4'h0;
        br_type_EX = 3'h0;
        load_npc_EX = 0;
        wb_select_EX = 0;
        load_type_EX = 2'h0;
        src_reg_en_EX = 2'h0;
        reg_write_en_EX = 0;
        cache_write_en_EX = 3'h0;
        alu_src1_EX = 0;
        alu_src2_EX = 2'b0;
        csrreg_write_en_EX = 0;
        csrALU_func_EX = 3'b0;
        csrwb_select_EX = 0;
        Opcode_EX = 7'b0; 
        PredictE = 1'b0; 
    end
    
    always@(posedge clk)
        if (!bubbleE) 
        begin
            if (flushE)
            begin
                jalr_EX <= 0;
                ALU_func_EX <= 4'h0;
                br_type_EX <= 3'h0;
                load_npc_EX <= 0;
                wb_select_EX <= 0;
                load_type_EX <= 2'h0;
                src_reg_en_EX <= 2'h0;
                reg_write_en_EX <= 0;
                cache_write_en_EX <= 3'h0;
                alu_src1_EX <= 0;
                alu_src2_EX <= 2'b0;
                csrreg_write_en_EX = 0;
                csrALU_func_EX = 3'b0;
                csrwb_select_EX = 0;
                Opcode_EX <= 6'b0; 
                PredictE <= 1'b0; 
            end
            else
            begin
                jalr_EX <= jalr_ID;
                ALU_func_EX <= ALU_func_ID;
                br_type_EX <= br_type_ID;
                load_npc_EX <= load_npc_ID;
                wb_select_EX <= wb_select_ID;
                load_type_EX <= load_type_ID;
                src_reg_en_EX <= src_reg_en_ID;
                reg_write_en_EX <= reg_write_en_ID;
                cache_write_en_EX <= cache_write_en_ID;
                alu_src1_EX <= alu_src1_ID;
                alu_src2_EX <= alu_src2_ID;
                csrreg_write_en_EX <= csrreg_write_en_ID;
                csrALU_func_EX <= csrALU_func_ID;
                csrwb_select_EX <= csrwb_select_ID;
                Opcode_EX <= Opcode_ID; 
                PredictE <= PredictD; 
            end
        end
    
endmodule