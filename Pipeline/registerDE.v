module registerDE(clk, rst, CLR,
    bne_selD, RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, lui_selD, jalr_selD, RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ExtImmD, PCPlus4D,
    bne_selE, RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcE, lui_selE, jalr_selE, RD1E, RD2E , PCE, Rs1E, Rs2E, RdE, ExtImmE, PCPlus4E);

    input clk, rst, CLR, bne_selD, RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, lui_selD, jalr_selD;
    input [1:0] ResultSrcD;
    input [2:0] ALUControlD;
    input [4:0] Rs1D, Rs2D, RdD;
    input [31:0] RD1D, RD2D, PCD, ExtImmD, PCPlus4D;

    output reg bne_selE, RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, lui_selE, jalr_selE;
    output reg [1:0] ResultSrcE;
    output reg [2:0] ALUControlE;
    output reg [4:0] Rs1E, Rs2E, RdE;
    output reg [31:0] RD1E, RD2E, PCE, ExtImmE, PCPlus4E;

    always @(posedge clk or posedge rst) begin
        if(rst || CLR) begin

            bne_selE <= 1'b0;
            RegWriteE <= 1'b0;
            MemWriteE <= 1'b0;
            JumpE <= 1'b0;
            BranchE <= 1'b0;
            ALUSrcE <= 1'b0;
            jalr_selE <= 1'b0;
            lui_selE <= 1'b0;
            
            ResultSrcE <= 2'b0;

            ALUControlE <= 3'b0;

            Rs1E <= 5'd0;
            Rs2E <= 5'd0;
            RdE <= 5'd0;

            RD1E <= 32'd0;
            RD2E <= 32'd0;
            PCE <= 32'd0;
            ExtImmE <= 32'd0;
            PCPlus4E <= 32'd0;
        end
        else begin
            bne_selE <= bne_selD;
            RegWriteE <= RegWriteD;
            MemWriteE <= MemWriteD;
            JumpE <= JumpD;
            BranchE <= BranchD;
            ALUSrcE <= ALUSrcD;
            jalr_selE <= jalr_selD;
            lui_selE <= lui_selD;

            ResultSrcE <= ResultSrcD;

            ALUControlE <= ALUControlD;

            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE <= RdD;

            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            ExtImmE <= ExtImmD;
            PCPlus4E <= PCPlus4D;
        end
    end
endmodule