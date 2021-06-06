`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 00:04:01
// Design Name: 
// Module Name: bht
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bht (
    input clk, 
    input rst, 
    input [7:0] tag, 
    input [7:0] tagE, 
    input br, 
    input [6:0] Opcode_EX, 
    output PredictF //预测结果标志
);
//Branch Opcode
localparam BR_OP = 7'b110_0011; 

reg [1:0] Valid[255 : 0] ; 

assign PredictF = Valid[tag][1]; 

localparam SN = 2'b00; 
localparam WN = 2'b01; 
localparam WT = 2'b10; 
localparam ST = 2'b11; 

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        for (integer i = 0; i < 256; i++ ) begin
            Valid[i] <= WN; 
        end
    end
    else begin
        if (Opcode_EX == BR_OP) begin
            if (br) begin
                Valid[tagE] <= (Valid[tagE] == ST) ? ST : Valid[tagE] + 2'b01;
            end
            else begin
                Valid[tagE] <= (Valid[tagE] == SN) ? SN : Valid[tagE] - 2'b01; 
            end
        end
    end
end

endmodule