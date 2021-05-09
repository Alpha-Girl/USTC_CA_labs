module csrAddrwb(
    input wire clk, bubbleW, flushW,
    input wire [31:0] csrAmem,
    output reg [31:0] csrAwb
    );

    initial csrAwb = 0;
    
    always@(posedge clk)
        if (!bubbleW) 
        begin
            if (flushW)
                csrAwb <= 0;
            else 
                csrAwb <= csrAmem;
        end
    
endmodule