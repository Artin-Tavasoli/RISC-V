module riscv(input clk, rst);
    // Wires between DataPath and Control Unit
    wire [2:0]  funct3D;
    wire [6:0]  funct7D, opD;
    wire JumpD, BranchD, bne_selD, lui_selD, jalr_selD, MemWriteD, ALUSrcD, RegWriteD;
    wire [1:0]  ResultSrcD;
    wire [2:0]  ALUControlD, ImmSrcD;

    // Wires between DataPath and Hazard Unit
    wire        PCSrcE, StallF, StallD, FlushD, FlushE, RegWriteM, RegWriteW;
    wire [4:0]  Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW;
    wire [1:0] ResultSrcE, ForwardAE, ForwardBE;

    datapath dp (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .StallF(StallF),
        .FlushD(FlushD),
        .StallD(StallD),
        .RegWriteW(RegWriteW),
        .RdW(RdW),
        .ImmSrcD(ImmSrcD),
        .funct3D(funct3D),
        .funct7D(funct7D),
        .opD(opD),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .FlushE(FlushE),
        .bne_selD(bne_selD),
        .RegWriteD(RegWriteD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUSrcD(ALUSrcD),
        .jalr_selD(jalr_selD),
        .lui_selD(lui_selD),
        .ResultSrcD(ResultSrcD),
        .ALUControlD(ALUControlD),
        .ResultSrcE(ResultSrcE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .RegWriteM(RegWriteM),
        .RdM(RdM)
    );

    control_unit cu (
        .op(opD),
        .funct3(funct3D),
        .funct7(funct7D),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .bne_selD(bne_selD),
        .lui_selD(lui_selD),
        .jalr_selD(jalr_selD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD)
    );

    hazard_unit hu (
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .PCSrcE(PCSrcE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .ResultSrcE(ResultSrcE),
        .RdM(RdM),
        .RegWriteM(RegWriteM),
        .RdW(RdW),
        .RegWriteW(RegWriteW),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );

endmodule