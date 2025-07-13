module riscv(input clk, reset);

    wire [6:0]  op;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire Zero;

    wire [1:0]  PCSrc, ResultSrc;
    wire MemWrite, ALUSrc, RegWrite;
    wire [2:0]  ALUControl, ImmSrc;

    data_path datapath_inst (
        .clk        (clk),
        .reset      (reset),
        .op         (op),
        .funct3     (funct3),
        .funct7     (funct7),
        .Zero       (Zero),
        .PCSrc      (PCSrc),
        .MemWrite   (MemWrite),
        .ALUSrc     (ALUSrc),
        .RegWrite   (RegWrite),
        .ResultSrc  (ResultSrc),
        .ALUControl (ALUControl),
        .ImmSrc     (ImmSrc)
    );

    control_unit control_inst (
        .op         (op),
        .funct3     (funct3),
        .funct7     (funct7),
        .Zero       (Zero),
        .PCSrc      (PCSrc),
        .MemWrite   (MemWrite),
        .ALUSrc     (ALUSrc),
        .RegWrite   (RegWrite),
        .ResultSrc  (ResultSrc),
        .ALUControl (ALUControl),
        .ImmSrc     (ImmSrc)
    );

endmodule
