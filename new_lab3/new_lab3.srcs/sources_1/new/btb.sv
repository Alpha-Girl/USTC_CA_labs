
module btb # (
    parameter ENTRY_NUM = 64//BTB大小
)(
    input clk, 
    input rst, 
    input [31:0] PC_IF, 
    input [31:0] PC_EX, 
    input [31:0] br_target, 
    input br, 
    input [6:0] Opcode_EX, 
    output reg [31:0] PredictPC, //PC预测结果
    output reg PredictPCValid      //预测结果有效
);
//分支Opcode
localparam BR_OP = 7'b110_0011; 
//Buffer define
reg [31:0] BranchTagAddress[ENTRY_NUM - 1 : 0]; 
reg [31:0] BranchTargetAddress[ENTRY_NUM - 1 : 0]; 
reg Valid[ENTRY_NUM - 1 : 0]; 
//FIFO Index
reg [15 : 0] Index; 
//Produce PredictPC
always @ (*) begin
    if (rst) begin
        PredictPC <= 32'b0; 
        PredictPCValid <= 1'b0; 
    end
    else begin
        PredictPC <= 32'b0; 
        PredictPCValid <= 1'b0; 
        for (integer i = 0; i < ENTRY_NUM ; i++ ) begin
            if ((PC_IF == BranchTagAddress[i]) && Valid[i]) begin
                PredictPCValid <= 1'b1; 
                PredictPC <= BranchTargetAddress[i]; 
            end
        end
    end
end 
//Renew Buffer
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        for (integer i = 0; i < ENTRY_NUM ; i++ ) begin
            Valid[i] <= 1'b0; 
            BranchTagAddress[i] <= 32'd0; 
            BranchTargetAddress[i] <= 32'd0; 
        end
        Index <= 16'd0; 
    end
    else begin
        if (Opcode_EX == BR_OP) begin
            integer i; 
            for (i = 0; i < ENTRY_NUM; i++) begin
                if (PC_EX == BranchTagAddress[i]) begin
                    BranchTargetAddress[i] <= br_target; 
                    Valid[i] <= br; 
                    break; 
                end
            end
            if (i == ENTRY_NUM) begin
                BranchTargetAddress[Index] <= br_target; 
                Valid[Index] <= br; 
                BranchTagAddress[Index] <= PC_EX; 
                Index = Index + 1; 
            end
        end
    end
end
endmodule