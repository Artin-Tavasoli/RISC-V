module data_path (clk, reset, op, funct3, funct7, Zero, PCSrc, MemWrite, ALUSrc, RegWrite, ResultSrc, ALUControl, ImmSrc);
    input clk, reset;
    input MemWrite, ALUSrc, RegWrite;
    input [1:0] PCSrc, ResultSrc;
    input [2:0] ALUControl, ImmSrc;
    output [2:0] funct3;
    output [6:0] funct7, op;
    output Zero;
    
    // ———————————————————————————————————————————
    // PC register
    // ———————————————————————————————————————————
    wire [31:0] PC, PCNext;
    pc pc_inst (
        .clk    (clk),
        .reset  (reset),
        .PCNext (PCNext),
        .PC     (PC)
    );
    
    // ———————————————————————————————————————————
    // Instruction memory
    // ———————————————————————————————————————————
    wire [31:0] Instr;
    assign op = Instr[6:0];
    assign funct3 = Instr[14:12];
    assign funct7 = Instr[31:25];

    instruction_memory instruction_memory_inst (
        .A  (PC),
        .RD (Instr)
    );
    


    // ———————————————————————————————————————————
    // Register file
    // ———————————————————————————————————————————
    wire [31:0] RD1, RD2, WD3;
    register_file register_file_inst (
        .clk  (clk),
        .WE3  (RegWrite),
        .A1   (Instr[19:15]), 
        .A2   (Instr[24:20]),
        .A3   (Instr[11:7]),  
        .WD3  (WD3),
        .RD1  (RD1),
        .RD2  (RD2)
    );
    
    // ———————————————————————————————————————————
    // Immediate generator 
    // ———————————————————————————————————————————
    wire [31:0]  ImmExt;
    imm_extend extend_inst (
        .instr  (Instr[31:7]),
        .ImmSrc (ImmSrc),
        .ImmExt (ImmExt)
    );
    
    // ———————————————————————————————————————————
    // ALU
    // ———————————————————————————————————————————
    wire [31:0]  SrcB, ALUResult;
    alu alu_inst (
        .A          (RD1),
        .B          (SrcB),
        .ALUControl (ALUControl),
        .ALUResult  (ALUResult),
        .Zero       (Zero)
    );
    
    // ———————————————————————————————————————————
    // Data memory
    // ———————————————————————————————————————————
    wire [31:0] ReadData;
    data_memory data_memory_inst (
        .clk  (clk),
        .WE   (MemWrite),
        .A    (ALUResult),
        .WD   (RD2),
        .RD   (ReadData)
    );

    // ———————————————————————————————————————————
    // PC+4 adder
    // ———————————————————————————————————————————
    wire [31:0] PCPlus4;
    add add4_inst (
        .A      (PC),
        .B      (32'd4),
        .Result (PCPlus4)
    );
    
    // ———————————————————————————————————————————
    // Target adder
    // ———————————————————————————————————————————
    wire [31:0] PCTarget;
    add add_target_inst (
        .A      (PC),
        .B      (ImmExt),
        .Result (PCTarget)
    );

    // ———————————————————————————————————————————
    // ALU input mux
    // ———————————————————————————————————————————
    mux_2_32 ALUSrcMux_inst (
        .input_0 (RD2),
        .input_1 (ImmExt),
        .select  (ALUSrc),
        .out     (SrcB)
    );
    
    // ———————————————————————————————————————————
    // Result mux
    // ———————————————————————————————————————————
    mux_4_32 ResultSrcMux_inst (
        .input_0 (ALUResult),
        .input_1 (ReadData),
        .input_2 (PCPlus4),
        .input_3 (ImmExt),
        .select  (ResultSrc),
        .out     (WD3)
    );
    
    // ———————————————————————————————————————————
    // PC next mux
    // ———————————————————————————————————————————
    mux_4_32 PCMux_inst (
    .input_0 (PCPlus4),
    .input_1 (PCTarget),
    .input_2 (ALUResult),
    .input_3 (32'd0),
    .select  (PCSrc),
    .out     (PCNext)
    );
    

    
endmodule
