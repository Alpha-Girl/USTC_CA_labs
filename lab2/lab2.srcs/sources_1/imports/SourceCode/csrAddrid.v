module csrAddrid(
    input wire clk, bubbleE, flushE, 
    input wire [11:0] csrAid, 
    output reg [11:0] csrAex    
);

initial csrAex = 0;

always @ (posedge clk)
    if(!bubbleE)
    begin
        if(flushE)
            csrAex <= 0;
        else 
            csrAex <= csrAid;
    end

endmodule