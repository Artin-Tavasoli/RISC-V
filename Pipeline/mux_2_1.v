module mux_2_1 (
    input input_0, input_1,
    input select,
    output reg out
);

always @(select or input_0 or input_1) begin
    if (select)
        out = input_1;
    else
        out = input_0;
end

endmodule
