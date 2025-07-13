module mux_4_32 (
    input [31:0] input_0, input_1, input_2, input_3,
    input [1:0] select,
    output reg [31:0] out
);

always @(select or input_0 or input_1 or input_2 or input_3) begin
    case (select)
        2'd0: out = input_0;
        2'd1: out = input_1;
        2'd2: out = input_2;
        2'd3: out = input_3;
    endcase
end


endmodule
