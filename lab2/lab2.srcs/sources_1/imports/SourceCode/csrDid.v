module csrDid(
    input wire clk, bubbleE, flushE, 
    input wire [31:0] csrRegid, 
    output reg [31:0] csrRegex    
);

initial csrRegex = 0;

always @ (posedge clk)
    if(!bubbleE)
    begin
        if(flushE)
            csrRegex <= 0;
        else 
            csrRegex <= csrRegid;
    end

endmodule