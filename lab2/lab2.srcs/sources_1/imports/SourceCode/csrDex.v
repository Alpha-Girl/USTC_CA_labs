module csrDex(
    input wire clk, bubbleM, flushM,
    input wire [31:0] csrALU_out,
    output reg [31:0] csrRegmem2
    );

    initial csrRegmem2 = 0;
    
    always@(posedge clk)
        if (!bubbleM) 
        begin
            if (flushM)
                csrRegmem2 <= 0;
            else 
                csrRegmem2 <= csrALU_out;
        end
    
endmodule