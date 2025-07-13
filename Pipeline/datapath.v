module datapath(clk, rst, PCSrcE, StallF, FlushD, StallD, RegWriteW, RdW, ImmSrcD,funct3D,funct7D, opD,  Rs1D, Rs2D,
 FlushE, bne_selD, RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, jalr_selD, lui_selD, ResultSrcD, ALUControlD,
  ResultSrcE, Rs1E, Rs2E, RdE, ForwardAE, ForwardBE, RegWriteM, RdM  );
    
    input clk, rst;

    // Instruction Fetch
    wire [31:0] PCPlus4F, PCTargetE, PCF0;
    output PCSrcE;
    mux_2_32 pc_src(.input_0(PCPlus4F), .input_1(PCTargetE), .select(PCSrcE), .out(PCF0));

    wire [31:0] PCF;
    input StallF;
    pc pc_reg(.clk(clk), .reset(rst), .EN(StallF), .PCNext(PCF0), .PC(PCF));

    wire [31:0] InstrF;
    instruction_memory instruction_memory_instance(.A(PCF), .RD(InstrF));

    add pc_adder(.A(PCF), .B(32'd4), .Result(PCPlus4F));


    input FlushD, StallD;
    wire [31:0] InstrD, PCD, PCPlus4D;
    registerFD registerFD_instance(.clk(clk), .rst(rst), .EN(StallD), .CLR(FlushD), .InstrF(InstrF), .PCF(PCF),
        .PCPlus4F(PCPlus4F), .InstrD(InstrD), .PCD(PCD), .PCPlus4D(PCPlus4D));

    // Instruction Decode
    output RegWriteW;
    output [4:0] RdW;
    wire [31:0] ResultW, RD1D, RD2D;
    register_file rf_instance(.clk(clk), .WE3(RegWriteW) , .A1(InstrD[19:15]), .A2(InstrD[24:20]), .A3(RdW), .WD3(ResultW), .RD1(RD1D), .RD2(RD2D));


    input [2:0] ImmSrcD;
    wire [31:0] ExtImmD;
    imm_extend extend_instance(.instr(InstrD[31:7]), .ImmSrc(ImmSrcD), .ImmExt(ExtImmD)); 

    output [2:0] funct3D;
    output [6:0] funct7D, opD;
    assign funct3D = InstrD[14:12];
    assign funct7D = InstrD[31:25];
    assign opD = InstrD[6:0];
    
    
    output [4:0] Rs1D, Rs2D;
    wire [4:0] RdD; 
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD = InstrD[11:7];

    input FlushE, bne_selD, RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, jalr_selD, lui_selD;
    input [1:0] ResultSrcD;
    input [2:0] ALUControlD;
    wire bne_selE, RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, jalr_selE, lui_selE;
    output [1:0] ResultSrcE;
    wire [2:0] ALUControlE;
    wire [31:0] RD1E, RD2E, PCE, ExtImmE, PCPlus4E;
    output [4:0] Rs1E, Rs2E, RdE;
    registerDE registerDE_instance(.clk(clk), .rst(rst), .CLR(FlushE),
    .bne_selD(bne_selD), .RegWriteD(RegWriteD), .ResultSrcD(ResultSrcD), .MemWriteD(MemWriteD), .JumpD(JumpD), .BranchD(BranchD), .ALUControlD(ALUControlD), .ALUSrcD(ALUSrcD), .jalr_selD(jalr_selD), .lui_selD(lui_selD), .RD1D(RD1D), .RD2D(RD2D), .PCD(PCD), .Rs1D(Rs1D), .Rs2D(Rs2D), .RdD(RdD), .ExtImmD(ExtImmD), .PCPlus4D(PCPlus4D),
    .bne_selE(bne_selE), .RegWriteE(RegWriteE), .ResultSrcE(ResultSrcE), .MemWriteE(MemWriteE), .JumpE(JumpE),
     .BranchE(BranchE), .ALUControlE(ALUControlE), .ALUSrcE(ALUSrcE),
    .jalr_selE(jalr_selE), .lui_selE(lui_selE),
    .RD1E(RD1E), .RD2E(RD2E) , .PCE(PCE), .Rs1E(Rs1E), .Rs2E(Rs2E), .RdE(RdE), .ExtImmE(ExtImmE), .PCPlus4E(PCPlus4E));

    // Execution

    wire [31:0] ForwardSrc, SrcAE, input_3;
    input [1:0] ForwardAE;
    mux_4_32 forwardA_mux_instance(.input_0(RD1E), .input_1(ResultW), .input_2(ForwardSrc), .input_3(input_3), .select(ForwardAE), .out(SrcAE));

    wire [31:0] WriteDataE;
    input [1:0] ForwardBE;
    mux_4_32 forwardB_mux_instance(.input_0(RD2E), .input_1(ResultW), .input_2(ForwardSrc), .input_3(input_3), .select(ForwardBE), .out(WriteDataE));

    wire [31:0] SrcBE;
    mux_2_32 alu_src_mux_instance(.input_0(WriteDataE), .input_1(ExtImmE), .select(ALUSrcE), .out(SrcBE));


    wire [31:0] PCOffset;
    add pc_offset_adder_instance(.A(PCE), .B(ExtImmE), .Result(PCOffset));


    wire [31:0] ALUResultE;
    wire ZeroE;
    alu alu_instance(.A(SrcAE), .B(SrcBE), .ALUControl(ALUControlE), .ALUResult(ALUResultE), .Zero(ZeroE));



    mux_2_32 pctarget_mux_instance(.input_0(PCOffset), .input_1(ALUResultE), .select(jalr_selE), .out(PCTargetE));

    wire BranchVerdict;
    mux_2_1 bne_mux_instance(.input_0(ZeroE), .input_1(~ZeroE), .select(bne_selE), .out(BranchVerdict));
    assign PCSrcE = (((BranchVerdict) && (BranchE)) || JumpE) ? 1'b1 : 1'b0;

    output RegWriteM;
    wire MemWriteM, lui_selM;
    wire [1:0] ResultSrcM;
    output [4:0] RdM;
    wire [31:0] ALUResultM, WriteDataM, ExtImmM, PCPlus4M; 
    registerEM registerEM_instance(.clk(clk), .rst(rst),
     .RegWriteE(RegWriteE), .ResultSrcE(ResultSrcE), .MemWriteE(MemWriteE), .lui_selE(lui_selE),  .ALUResultE(ALUResultE), .WriteDataE(WriteDataE), .RdE(RdE), .ExtImmE(ExtImmE), .PCPlus4E(PCPlus4E),
     .RegWriteM(RegWriteM), .ResultSrcM(ResultSrcM), .MemWriteM(MemWriteM), .lui_selM(lui_selM), .ALUResultM(ALUResultM), .WriteDataM(WriteDataM), .RdM(RdM), .ExtImmM(ExtImmM), .PCPlus4M(PCPlus4M));
    
    // Memory

    wire [31:0] ReadDataM;
    data_memory data_memory_instance(.clk(clk), .WE(MemWriteM), .A(ALUResultM), .WD(WriteDataM), .RD(ReadDataM));

    mux_2_32 forwardSrc_mux_instance(.input_0(ALUResultM), .input_1(ExtImmM), .select(lui_selM), .out(ForwardSrc));

    wire [1:0] ResultSrcW;
    wire [31:0] ReadDataW, ALUResultW, ExtImmW, PCPlus4W;
    registerMW registerMW_instance(.clk(clk), .rst(rst),
    .RegWriteM(RegWriteM), .ResultSrcM(ResultSrcM), .ALUResultM(ALUResultM), .ReadDataM(ReadDataM), .RdM(RdM), .ExtImmM(ExtImmM), .PCPlus4M(PCPlus4M),
    .RegWriteW(RegWriteW), .ResultSrcW(ResultSrcW), .ALUResultW(ALUResultW), .ReadDataW(ReadDataW), .RdW(RdW), .ExtImmW(ExtImmW), .PCPlus4W(PCPlus4W));

    // Write Back

    mux_4_32 resultw_mux_instance(.input_0(ALUResultW), .input_1(ReadDataW), .input_2(PCPlus4W), .input_3(ExtImmW), .select(ResultSrcW), .out(ResultW));

endmodule