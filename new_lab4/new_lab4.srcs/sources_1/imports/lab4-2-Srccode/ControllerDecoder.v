`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Controller Decoder
// Tool Versions: Vivado 2017.4.1
// Description: Controller Decoder Module
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    //  对指令进行译码，将其翻译成控制信号，传输给各个部�??
// 输入
    // Inst              待译码指�??
// 输出
    // jal               jal跳转指令
    // jalr              jalr跳转指令
    // op2_src           ALU的第二个操作数来源�?�为1时，op2选择imm，为0时，op2选择reg2
    // ALU_func          ALU执行的运算类�??
    // br_type           branch的判断条件，可以是不进行branch
    // load_npc          写回寄存器的值的来源（PC或�?�ALU计算结果�??, load_npc == 1时�?�择PC
    // wb_select         写回寄存器的值的来源（Cache内容或�?�ALU计算结果），wb_select == 1时�?�择cache内容
    // load_type         load类型
    // src_reg_en        指令中src reg的地�??是否有效，src_reg_en[1] == 1表示reg1被使用到了，src_reg_en[0]==1表示reg2被使用到�??
    // reg_write_en      通用寄存器写使能，reg_write_en == 1表示�??要写回reg
    // cache_write_en    按字节写入data cache
    // imm_type          指令中立即数类型
    // alu_src1          alu操作�??1来源，alu_src1 == 0表示来自reg1，alu_src1 == 1表示来自PC
    // alu_src2          alu操作�??2来源，alu_src2 == 2’b00表示来自reg2，alu_src2 == 2'b01表示来自reg2地址，alu_src2 == 2'b10表示来自立即�??
// 实验要求
    // 补全模块


`include "Parameters.v"   
module ControllerDecoder(
    input wire [31:0] inst,
    output wire jal,
    output wire jalr,
    output wire op2_src,
    output reg [3:0] ALU_func,
    output reg [2:0] br_type,
    output wire load_npc,
    output wire wb_select,
    output reg [2:0] load_type,
    output reg [1:0] src_reg_en,
    output reg reg_write_en,
    output reg [3:0] cache_write_en,
    output wire alu_src1,
    output wire [1:0] alu_src2,
    output reg [2:0] imm_type, 
    output reg csrreg_write_en, 
    output reg [2:0] csrALU_func, 
    output wire csrwb_select
    );
    //======================================================================
    //指令分块
    //基本思路：Op + Fn3 + Fn7 确定�??条指�??
    wire [6:0] Op, Fn7;
    wire [2:0] Fn3;
    wire [4:0] Rs2, Rs1, RD;
    assign {Fn7, Rs2, Rs1, Fn3, RD, Op} = inst;
    // TODO: Complete this module
    localparam ALUR_OP = 7'b011_0011;//ADD、SUB、SLL、SRL、SRA、SLT、SLTU、XOR、OR、AND
    localparam ALUI_OP = 7'b001_0011;//SSLI、SRLI、SRAI、ADDI、SLTI、SLTIU、XORI、ORI、ANDI
    localparam LUI_OP = 7'b011_0111;//LUI
    localparam AUIPC_OP = 7'b001_0111;//AUIPC
    localparam JALR_OP = 7'b110_0111;//JALR
    localparam JAL_OP = 7'b110_1111;//JAL
    localparam BR_OP = 7'b110_0011;//BEQ、BNE、BLT、BGE、BLTU、BGEU
    localparam LOAD_OP = 7'b000_0011;//LB、LH、LW、LBU、LHU
    localparam STORE_OP = 7'b010_0011;//SB、SH、SW

    localparam CSR_OP = 7'b111_0011;
    //======================================================================
    //具体信号
    //移位指令
    wire SLLI, SRLI, SRAI, SLL;
    assign SLLI = (Op == ALUI_OP) && (Fn3 == 3'b001) && (Fn7 == 7'b000_0000);
    assign SRLI = (Op == ALUI_OP) && (Fn3 == 3'b101) && (Fn7 == 7'b000_0000);
    assign SRAI = (Op == ALUI_OP) && (Fn3 == 3'b101) && (Fn7 == 7'b010_0000);
    assign SLL = (Op == ALUR_OP) && (Fn3 == 3'b001) && (Fn7 == 7'b000_0000);
    assign SRL = (Op == ALUR_OP) && (Fn3 == 3'b101) && (Fn7 == 7'b000_0000);
    assign SRA = (Op == ALUR_OP) && (Fn3 == 3'b101) && (Fn7 == 7'b010_0000);
    //计算指令
    wire ADD, SUB, ADDI;
    assign ADD = (Op == ALUR_OP) && (Fn3 == 3'b000) && (Fn7 == 7'b000_0000);
    assign SUB = (Op == ALUR_OP) && (Fn3 == 3'b000) && (Fn7 == 7'b010_0000);
    assign ADDI = (Op == ALUI_OP) && (Fn3 == 3'b000);
    //比较指令
    wire SLT, SLTU, SLTI, SLTIU;
    assign SLT = (Op == ALUR_OP) && (Fn3 == 3'b010) && (Fn7 == 7'b000_0000);
    assign SLTU = (Op == ALUR_OP) && (Fn3 == 3'b011) && (Fn7 == 7'b000_0000);
    assign SLTI = (Op == ALUI_OP) && (Fn3 == 3'b010);
    assign SLTIU = (Op == ALUI_OP) && (Fn3 == 3'b011);
    //逻辑指令
    wire XOR, OR, AND, XORI, ORI, ANDI;
    assign XOR = (Op == ALUR_OP) && (Fn3 == 3'b100) && (Fn7 == 7'b000_0000);
    assign OR = (Op == ALUR_OP) && (Fn3 == 3'b110) && (Fn7 == 7'b000_0000);
    assign AND = (Op == ALUR_OP) && (Fn3 == 3'b111) && (Fn7 == 7'b000_0000);
    assign XORI = (Op == ALUI_OP) && (Fn3 == 3'b100);
    assign ORI = (Op == ALUI_OP) && (Fn3 == 3'b110);
    assign ANDI = (Op == ALUI_OP) && (Fn3 == 3'b111);
    //立即数指�??
    wire LUI, AUIPC;
    assign LUI = (Op == LUI_OP);
    assign AUIPC = (Op == AUIPC_OP);
    
    wire JALR, JAL, BEQ, BNE, BLT, BGE, BLTU, BGEU;
    assign JALR = (Op == JALR_OP);
    assign JAL = (Op == JAL_OP);
    assign BEQ = (Op == BR_OP) && (Fn3 == 3'b000);
    assign BNE = (Op == BR_OP) && (Fn3 == 3'b001);
    assign BLT = (Op == BR_OP) && (Fn3 == 3'b100);
    assign BGE = (Op == BR_OP) && (Fn3 == 3'b101);
    assign BLTU = (Op == BR_OP) && (Fn3 == 3'b110);
    assign BGEU = (Op == BR_OP) && (Fn3 == 3'b111);
    //Load指令
    wire LB, LH, LW, LBU, LHU;
    assign LB = (Op == LOAD_OP) && (Fn3 == 3'b000);
    assign LH = (Op == LOAD_OP) && (Fn3 == 3'b001);
    assign LW = (Op == LOAD_OP) && (Fn3 == 3'b010);
    assign LBU = (Op == LOAD_OP) && (Fn3 == 3'b100);
    assign LHU = (Op == LOAD_OP) && (Fn3 == 3'b101);
    //Store指令
    wire SB, SH, SW;
    assign SB = (Op == STORE_OP) && (Fn3 == 3'b000);
    assign SH = (Op == STORE_OP) && (Fn3 == 3'b001);
    assign SW = (Op == STORE_OP) && (Fn3 == 3'b010);
    //CSR指令
    wire CSRW, CSRS, CSRC, CSRWI, CSRSI, CSRCI; 
    assign CSRW = (Op == CSR_OP) && (Fn3 == 3'b001); 
    assign CSRS = (Op == CSR_OP) && (Fn3 == 3'b010); 
    assign CSRC = (Op == CSR_OP) && (Fn3 == 3'b011); 
    assign CSRWI = (Op == CSR_OP) && (Fn3 == 3'b101); 
    assign CSRSI = (Op == CSR_OP) && (Fn3 == 3'b110); 
    assign CSRCI = (Op == CSR_OP) && (Fn3 == 3'b111);

    //===============================================================================================
    // 各输出信号处�??
    //------------------- jal -------------------------
    assign jal = JAL;
    //------------------- jalr -------------------------
    assign jalr = JALR;
    //------------------- op2_src ----------------------
    assign op2_src = SLLI || SRLI || SRAI || ADDI || SLTI || SLTIU || XORI || ORI || ANDI || LUI || AUIPC || JALR || JAL || BEQ || BNE || BLT || BGE || BLTU || BGEU || LB || LH || LW || LBU || LHU || SB || SH || SW;
    //------------------- ALU_func -------------------------
    always @ (*)
        begin
            if (SLL || SLLI)        ALU_func <= `SLL;
            else if (SRL || SRLI)   ALU_func <= `SRL;
            else if (SRA || SRAI)   ALU_func <= `SRA;
            else if (ADD || ADDI || AUIPC || JALR || Op == LOAD_OP || Op == STORE_OP)   
                                    ALU_func <= `ADD;
            else if (SUB)           ALU_func <= `SUB;
            else if (XOR || XORI)   ALU_func <= `XOR;
            else if (OR || ORI)     ALU_func <= `OR;
            else if (AND || ANDI)   ALU_func <= `AND;
            else if (SLT || SLTI)   ALU_func <= `SLT;
            else if (SLTU || SLTIU) ALU_func <= `SLTU;
            else if (LUI)           ALU_func <= `LUI;
            else                    ALU_func <= 4'b1111;
        end
    //-------------------br_type-------------------------
    always @ (*)
        begin
            if (BEQ)        br_type <= `BEQ;
            else if (BNE)   br_type <= `BNE;
            else if (BLT)   br_type <= `BLT;
            else if (BLTU)  br_type <= `BLTU;
            else if (BGE)   br_type <= `BGE;
            else if (BGEU)  br_type <= `BGEU;
            else            br_type <= `NOBRANCH;  
        end
    //------------------- load_npc -------------------------
    assign load_npc = JAL || JALR;
    //------------------- wb_select -------------------------
    wire RegWD_NL = LUI || AUIPC || (Op == ALUR_OP) || (Op == ALUI_OP) || JAL || JALR;
    wire RegWD_L = LB || LH || LW || LBU || LHU;
    assign wb_select = RegWD_NL ? 1'b0 : (RegWD_L ? 1'b1 : 1'b0);
    //------------------- load_type -------------------------
    always @ (*)
        begin
            if (LB)         load_type <= `LB;
            else if (LH)    load_type <= `LH;
            else if (LW)    load_type <= `LW;
            else if (LBU)   load_type <= `LBU;
            else if (LHU)   load_type <= `LHU;
            else            load_type <= `NOREGWRITE;
        end
    //------------------- src_reg_en -------------------------
    always @ (*)
        begin
            src_reg_en[0] <= (Op == ALUR_OP) || (Op == BR_OP) || (Op == STORE_OP);
            src_reg_en[1] <= (Op == ALUI_OP) || (Op == ALUR_OP) || (Op == LOAD_OP) || (Op == STORE_OP) || (Op == BR_OP) || JALR;
        end
    //------------------- reg_write_en -------------------------
    always @ (*)
        begin 
            if(RegWD_NL || RegWD_L || CSRW || CSRS || CSRC || CSRWI || CSRSI || CSRCI) reg_write_en <= 1'b1;
            else reg_write_en <= 1'b0; 
        end
    //------------------- cache_write_en -------------------------
    always @ (*)
        begin
            if (SB)         cache_write_en <= 4'b0001;
            else if (SH)    cache_write_en <= 4'b0011;
            else if (SW)    cache_write_en <= 4'b1111;
            else            cache_write_en <= 4'b0000;
        end
    //------------------- imm_type -------------------------
    always @ (*)
        begin
            if (Op == ALUR_OP)          imm_type <= `RTYPE;
            else if (Op == ALUI_OP || Op == LOAD_OP || JALR)   imm_type <= `ITYPE;
            else if (LUI || AUIPC)      imm_type <= `UTYPE;
            else if (JAL)               imm_type <= `JTYPE;
            else if (Op == BR_OP)       imm_type <= `BTYPE;
            else if (Op == STORE_OP)    imm_type <= `STYPE;
            else                        imm_type <= 3'b111;
        end
    //------------------- alu_src1 -------------------------
    assign alu_src1 = AUIPC;
    //------------------- alu_src2 -------------------------
    assign alu_src2 = (SLLI || SRLI || SRAI) ? 2'b01 : ((Op == ALUR_OP || Op == BR_OP) ? 2'b00 : 2'b10);
    //------------------- csrreg_write_en -------------------------
    always @ (*)
        begin 
            if(CSRW || CSRS || CSRC || CSRWI || CSRCI || CSRSI ) csrreg_write_en <= 1'b1;
            else csrreg_write_en <= 1'b0; 
        end
    //------------------- csrALU_func ------------------------- 
    always @ (*)
        begin
            if (CSRW)       csrALU_func <= `CSRRW;
            else if (CSRS)  csrALU_func <= `CSRRS;
            else if (CSRC)  csrALU_func <= `CSRRC; 
            else if (CSRWI) csrALU_func <= `CSRRWI;
            else if (CSRSI) csrALU_func <= `CSRRSI;
            else if (CSRCI) csrALU_func <= `CSRRCI;
            else            csrALU_func <= 3'b111;
        end
    //------------------- csrwb_select -------------------------
    assign csrwb_select = (CSRW || CSRS || CSRC || CSRWI || CSRSI || CSRCI) ? 1'b1 : 1'b0;
endmodule
