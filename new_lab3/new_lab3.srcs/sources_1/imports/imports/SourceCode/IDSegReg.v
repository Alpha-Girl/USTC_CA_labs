`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Wu Yuzhang
//
// Design Name: RISCV-Pipline CPU
// Module Name: IDSegReg
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: IF-ID Segment Register
//////////////////////////////////////////////////////////////////////////////////
//����˵��
//IDSegReg��IF-ID�μĴ�����ͬʱ������һ��ͬ����д��Bram���˴�����Ե��������ṩ��InstructionRam��
//�������Զ��ۺ�Ϊblock memory����Ҳ��������Եĵ���xilinx��bram ip�ˣ���
//ͬ����memory �൱�� �첽��memory ��������D����������Ҫʱ�������ز��ܶ�ȡ���ݡ�
//��ʱ�����ͨ���μĴ������棬��ô��Ҫ����ʱ�������ز��ܽ����ݴ��ݵ�Ex��
//����ڶμĴ���ģ���е��ø�ͬ��memory��ֱ�ӽ�������ݵ�ID������߼�
//����memģ������ΪRD_raw��ͨ��assign RD = stall_ff ? RD_old : (clear_ff ? 32'b0 : RD_raw );
//�Ӷ�ʵ��RD�μĴ���stall��clear����
//ʵ��Ҫ��
//��ȫIDSegRegģ�飬�貹ȫ��Ƭ�ν�ȡ����
//InstructionRam InstructionRamInst (
//     .clk    (),                        //�����ƴ���
//     .addra  (),                        //�����ƴ���
//     .douta  ( RD_raw     ),
//     .web    ( |WE2       ),
//     .addrb  ( A2[31:2]   ),
//     .dinb   ( WD2        ),
//     .doutb  ( RD2        )
// );
//ע������
//���뵽DataRam��addra���ֵ�ַ��һ����32bit

module IDSegReg(
           input wire clk,
           input wire clear,
           input wire en,
           //Instrution Memory Access
           input wire [31: 0] A,
           output wire [31: 0] RD,
           //Instruction Memory Debug
           input wire [31: 0] A2,
           input wire [31: 0] WD2,
           input wire [3: 0] WE2,
           output wire [31: 0] RD2,
           //
           input wire [31: 0] PCF,
           output reg [31: 0] PCD
       );

initial
    PCD = 0;
always@(posedge clk)
    if (en)
        PCD <= clear ? 0 : PCF;

wire [31: 0] RD_raw;
InstructionCache InstructionRamInst (
                   .clk (clk),                          //�����ƴ���
                   .addra (A[31: 2]),                          //�����ƴ���
                   .douta ( RD_raw ),
                   .web ( WE2 ),
                   .addrb ( A2[31: 2] ),
                   .dinb ( WD2 ),
                   .doutb ( RD2 )
               );
// Add clear and stall support
// if chip not enabled, output output last read result
// else if chip clear, output 0
// else output values from bram
// ���²��������޸�
reg stall_ff = 1'b0;
reg clear_ff = 1'b0;
reg [31: 0] RD_old = 32'b0;
always @ (posedge clk)
begin
    stall_ff <= ~en;
    clear_ff <= clear;
    RD_old <= RD_raw;
end
assign RD = stall_ff ? RD_old : (clear_ff ? 32'b0 : RD_raw );

endmodule
