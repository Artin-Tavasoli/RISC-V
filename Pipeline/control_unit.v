module control_unit (op, funct3, funct7, RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, bne_selD, lui_selD, jalr_selD, ALUControlD, ALUSrcD, ImmSrcD);
    
    input [2:0] funct3;
    input [6:0] funct7, op;

    output JumpD, BranchD,bne_selD, lui_selD, jalr_selD;
    output reg  MemWriteD, ALUSrcD, RegWriteD;
    output reg [1:0] ResultSrcD;
    output reg [2:0] ALUControlD, ImmSrcD;

    parameter [6:0] R_type_opc = 7'b0110011, Lw_opc = 7'b0000011, I_type_opc = 7'b0010011, Jalr_opc = 7'b1100111,
    Sw_opc = 7'b0100011, Jal_opc = 7'b1101111, B_type_opc = 7'b1100011, Aui_opc = 7'b0110111, Lui_opc = 7'b0110111;

    wire [9:0] funct_type1;
    assign funct_type1 = {funct7, funct3};
    parameter [9:0] Add_funct = 10'b0000000000, Sub_funct = 10'b0100000000, Slt_funct = 10'b0000000010, And_funct = 10'b0000000111,
    Or_funct = 10'b0000000110;

    wire [2:0] funct_type2;
    assign funct_type2 = funct3;
    parameter [2:0] Lw_funct = 3'b010, Addi_funct = 3'b000, Ori_funct = 3'b110, Slti_funct = 3'b010, Jalr_funct = 3'b000,
    Sw_funct = 3'b010, Beq_funct = 3'b000, Bne_funct = 3'b001;

    assign JumpD = (op == Jal_opc || op == Jalr_opc) ? 1'b1 : 1'b0;

    assign BranchD = (op == B_type_opc) ? 1'b1 : 1'b0;

    assign bne_selD = (BranchD == 1) && (funct_type2 == Bne_funct) ? 1'b1 : 1'b0;

    assign jalr_selD = (op == Jalr_opc) ? 1'b1 : 1'b0;

    assign lui_selD = (op == Lui_opc) ? 1'b1 : 1'b0;


    always @(funct_type1 or funct_type2 or op)begin
        MemWriteD    = 1'b0;
        ALUSrcD      = 1'b0;
        RegWriteD    = 1'b0;
        ResultSrcD   = 2'b00;
        ALUControlD  = 3'b000;
        ImmSrcD      = 3'b000;
         case (op)
            R_type_opc: begin
                RegWriteD = 1'b1;
                case (funct_type1)
                    Add_funct: ALUControlD = 3'b000;
                    Sub_funct: ALUControlD = 3'b001;
                    And_funct: ALUControlD = 3'b010; 
                    Or_funct : ALUControlD = 3'b011; 
                    Slt_funct: ALUControlD = 3'b100;
                endcase
            end

            I_type_opc: begin
                ALUSrcD    = 1'b1;
                RegWriteD  = 1'b1;
                case (funct_type2)
                    Addi_funct: ALUControlD = 3'b000;
                    Ori_funct : ALUControlD = 3'b011;
                    Slti_funct: ALUControlD = 3'b100;
                endcase
            end

            Lw_opc: begin
                ResultSrcD = 2'b01;
                ALUSrcD     = 1'b1;
                RegWriteD   = 1'b1;
            end

            Sw_opc: begin
                ALUSrcD     = 1'b1;
                MemWriteD   = 1'b1;
                ImmSrcD     = 3'b001;
            end

            Jalr_opc: begin
                ResultSrcD   = 2'b10;
                ALUSrcD      = 1'b1;
                RegWriteD   = 1'b1;
                ImmSrcD     = 3'b011;
            end

            Jal_opc: begin
                ResultSrcD   = 2'b10;
                RegWriteD    = 1'b1;
                ImmSrcD      = 3'b100;
            end

            B_type_opc: begin
                ImmSrcD = 3'b010;
                ALUControlD = 3'b001;
            end

            Lui_opc: begin
                ResultSrcD   = 2'b11;
                RegWriteD    = 1'b1;
                ImmSrcD      = 3'b101;
            end
        endcase
    end

endmodule