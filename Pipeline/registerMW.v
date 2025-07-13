module registerMW(clk, rst,
    RegWriteM, ResultSrcM, ALUResultM, ReadDataM, RdM, ExtImmM, PCPlus4M,
    RegWriteW, ResultSrcW, ALUResultW, ReadDataW, RdW, ExtImmW, PCPlus4W);

    input clk, rst, RegWriteM;
    input [1:0] ResultSrcM;
    input [4:0] RdM;
    input [31:0] ReadDataM, ALUResultM, ExtImmM, PCPlus4M;

    output reg RegWriteW;
    output reg [1:0] ResultSrcW;
    output reg [4:0] RdW;
    output reg [31:0] ReadDataW, ALUResultW, ExtImmW, PCPlus4W;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            RegWriteW <= 1'd0;
            ResultSrcW <= 2'd0;
            RdW <= 5'd0;
            ReadDataW <= 32'd0;
            ALUResultW <= 32'd0;
            ExtImmW <= 32'b0;
            PCPlus4W <= 32'd0;
        end
        else
            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;
            RdW <= RdM;
            ReadDataW <= ReadDataM;
            ALUResultW <= ALUResultM;
            ExtImmW <= ExtImmM;
            PCPlus4W <= PCPlus4M;
    end
endmodule