module pc (
    input clk, reset,
    input [31:0] PCNext,
    output reg [31:0] PC
);

always @(posedge clk or posedge reset) begin
    if (reset)
        PC <= 32'b0;
    else
        PC <= PCNext;
end

endmodule