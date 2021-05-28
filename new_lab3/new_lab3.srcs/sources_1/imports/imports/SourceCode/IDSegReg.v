//IDSegReg是指译码阶段的段寄存器，存储�???前一阶段取到的指令，供译码段使用
module IDSegReg(
    input wire clk,
    input wire rst,
    input wire clear,
    input wire en,
    //Instrution Memory Access
    input wire [31:0] A,
    output wire [31:0] RD,
    //
    input wire [31:0] PCF,
    output reg [31:0] PCD 
    );
    
    // if chip not enable, output instruction ram read result
    // else if chip clear, output 0
    // else output last read result
    reg stall_or_clear = 1'b0;
    reg  [31:0] stall_or_clear_data = 0;
    wire [31:0] RD_raw;
    assign RD = stall_or_clear ? stall_or_clear_data : RD_raw;
    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            stall_or_clear <= 1'b0;
            stall_or_clear_data <= 0;
        end else begin
            if(~en) begin
                stall_or_clear <= 1'b1;
                stall_or_clear_data <= RD;
            end else if(clear) begin
                stall_or_clear <= 1'b1;
                stall_or_clear_data <= 0;
            end else begin
                stall_or_clear <= 1'b0;
                stall_or_clear_data <= 0;
            end
        end
    end

    always@(posedge clk or posedge rst)
        if(rst)
            PCD <= 0;
        else if(en)
            PCD <= clear ? 0: PCF;
    wire [31:0] tmp;
    InstructionCache_MM InstructionRam (
         .clk    ( clk        ),
         .web    (1'b0),
         .addra(A[31:2]),
         .addrb(30'b0),
         .dinb(32'b0),
         .douta(RD_raw),
         .doutb(tmp)
     );

    
endmodule