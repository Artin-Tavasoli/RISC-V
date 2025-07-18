module mux_2_32 (
    input [31:0] input_0, input_1,
    input select,
    output reg [31:0] out
);

always @(select or input_0 or input_1) begin
    if (select)
        out = input_1;
    else
        out = input_0;
end

endmodule
