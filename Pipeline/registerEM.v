module registerEM(clk, rst,
     RegWriteE, ResultSrcE, MemWriteE, lui_selE,  ALUResultE, WriteDataE, RdE, ExtImmE, PCPlus4E,
     RegWriteM, ResultSrcM, MemWriteM, lui_selM, ALUResultM, WriteDataM, RdM, ExtImmM, PCPlus4M);

    input clk, rst, RegWriteE, MemWriteE, lui_selE;
    input [1:0] ResultSrcE;
    input [4:0] RdE;
    input [31:0] ALUResultE, WriteDataE, ExtImmE, PCPlus4E;

    output reg RegWriteM, MemWriteM, lui_selM;
    output reg [1:0] ResultSrcM;
    output reg [4:0] RdM;
    output reg [31:0] ALUResultM, WriteDataM, ExtImmM, PCPlus4M;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            RegWriteM <= 1'd0;
            MemWriteM <= 1'd0;
            lui_selM <= 1'd0;
            ResultSrcM <= 2'd0;
            RdM <= 5'd0;
            ALUResultM <= 32'd0;
            WriteDataM <= 32'd0;
            ExtImmM <= 32'd0;
            PCPlus4M <= 32'd0;

        end
        else
            RegWriteM <= RegWriteE;
            MemWriteM <= MemWriteE;
            lui_selM <= lui_selE;
            ResultSrcM <= ResultSrcE;
            RdM <= RdE;
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            ExtImmM <= ExtImmE;
            PCPlus4M <= PCPlus4E;
    end
endmodule