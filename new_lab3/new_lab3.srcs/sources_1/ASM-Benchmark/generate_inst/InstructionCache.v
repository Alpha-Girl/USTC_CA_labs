// asm file name: MatMul.S
module InstructionCache_MM(
    input wire clk,
    input wire web,
    input wire [31:2] addra, addrb,
    input wire [31:0] dinb,
    output reg [31:0] douta, doutb
);

    // local variable
    wire addr_valid = (addra[31:14] == 18'h0);
    wire debug_addr_valid = (addrb[31:14] == 18'h0);
    wire [11:0] dealt_addr = addra[13:2];
    wire [11:0] dealt_debug_addr = addrb[13:2];
    // cache content
    reg [31:0] inst_cache[0:4095];


    initial begin
        douta = 32'h0;
        doutb = 32'h0;
        inst_cache[       0] = 32'h00404713;
        inst_cache[       1] = 32'h00404693;
        inst_cache[       2] = 32'h00e696b3;
        inst_cache[       3] = 32'h00004633;
        inst_cache[       4] = 32'h00e69533;
        inst_cache[       5] = 32'h00a505b3;
        inst_cache[       6] = 32'h000042b3;
        inst_cache[       7] = 32'h00004333;
        inst_cache[       8] = 32'h00004e33;
        inst_cache[       9] = 32'h000043b3;
        inst_cache[      10] = 32'h00e29eb3;
        inst_cache[      11] = 32'h007e8eb3;
        inst_cache[      12] = 32'h00ae8eb3;
        inst_cache[      13] = 32'h000eae83;
        inst_cache[      14] = 32'h00e39f33;
        inst_cache[      15] = 32'h006f0f33;
        inst_cache[      16] = 32'h00bf0f33;
        inst_cache[      17] = 32'h000f2f03;
        inst_cache[      18] = 32'h01eefeb3;
        inst_cache[      19] = 32'h01de0e33;
        inst_cache[      20] = 32'h00438393;
        inst_cache[      21] = 32'hfcd3cae3;
        inst_cache[      22] = 32'h00e29eb3;
        inst_cache[      23] = 32'h006e8eb3;
        inst_cache[      24] = 32'h00ce8eb3;
        inst_cache[      25] = 32'h01cea023;
        inst_cache[      26] = 32'h00430313;
        inst_cache[      27] = 32'hfad34ae3;
        inst_cache[      28] = 32'h00428293;
        inst_cache[      29] = 32'hfad2c4e3;
        inst_cache[      30] = 32'h00100293;
        inst_cache[      31] = 32'h00e292b3;
        inst_cache[      32] = 32'h00e292b3;
        inst_cache[      33] = 32'h00229293;
        inst_cache[      34] = 32'h00000313;
        inst_cache[      35] = 32'h00032383;
        inst_cache[      36] = 32'h00430313;
        inst_cache[      37] = 32'hfe534ce3;
        inst_cache[      38] = 32'h0000006f;
end

    always@(posedge clk)
    begin
        douta <= addr_valid ? inst_cache[dealt_addr] : 32'h0;
        doutb <= debug_addr_valid ? inst_cache[dealt_debug_addr] : 32'h0;
        if(web & debug_addr_valid) 
            inst_cache[dealt_debug_addr] <= dinb;
    end

endmodule
