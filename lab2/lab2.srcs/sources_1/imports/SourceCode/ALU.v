`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Wu Yuzhang
//
// Design Name: RISCV-Pipline CPU
// Module Name: ALU
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: ALU unit of RISCV CPU
//////////////////////////////////////////////////////////////////////////////////

//功能和接口说明
//ALU接受两个操作数，根据AluContrl的不同，进行不同的计算操作，将计算结果输出到AluOut
//AluContrl的类型定义在Parameters.v中
//推荐格式：
//case()
//    `ADD:        AluOut<=Operand1 + Operand2;
//   	.......
//    default:    AluOut <= 32'hxxxxxxxx;
//endcase
//实验要求
//补全模块

`include "Parameters.v"
module ALU(
           input wire [31: 0] Operand1,
           input wire [31: 0] Operand2,
           input wire [3: 0] AluContrl,
           output reg [31: 0] AluOut
       );
wire signed [31: 0] Operand1_S = $signed(Operand1);
wire signed [31: 0] Operand2_S = $signed(Operand2);
always @( * ) begin
    case (AluContrl)
        `SLL:
            AluOut <= Operand1 << Operand2[4: 0];
        `SRL:
            AluOut <= Operand1 >> Operand2[4: 0];
        `SRA:
            AluOut <= Operand1_S >>> Operand2[4: 0];
        `ADD:
            AluOut <= Operand1 + Operand2;
        `SUB:
            AluOut <= Operand1 - Operand2;
        `XOR:
            AluOut <= Operand1 ^ Operand2;
        `OR:
            AluOut <= Operand1 | Operand2;
        `AND:
            AluOut <= Operand1 & Operand2;
        `SLT:
            AluOut <= (Operand1_S < Operand2_S) ? 32'h1 : 32'h0;
        `SLTU:
            AluOut <= (Operand1 < Operand2) ? 32'h1 : 32'h0;
        `LUI:
            AluOut <= (Operand2) & 32'hfffff000;
        default:
            AluOut <= 32'hxxxxxxxx;
    endcase
end


endmodule

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