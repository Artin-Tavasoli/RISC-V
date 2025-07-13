module register_file (
    input clk, WE3,
    input [4:0] A1, A2, A3,
    input [31:0] WD3,
    output reg [31:0] RD1, RD2
);

reg [31:0] registers[0:31];
integer i;
    initial begin
    for (i = 0; i < 32; i = i + 1) begin
        registers[i] = 0;
    end
end


always @(negedge clk) begin
    if (WE3 == 1 && A3 != 0)
        registers[A3] <= WD3;
end

always @(negedge clk) begin
    RD1 <= registers[A1];
    RD2 <= registers[A2];
end

endmodule




