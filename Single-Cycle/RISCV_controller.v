module control_unit ( op, funct3, funct7, Zero, PCSrc, MemWrite, ALUSrc, RegWrite, ResultSrc, ALUControl, ImmSrc );
    input [2:0] funct3;
    input [6:0] funct7, op;
    input Zero;
    output reg  MemWrite, ALUSrc, RegWrite;
    output reg [1:0] PCSrc, ResultSrc;
    output reg [2:0] ALUControl, ImmSrc;

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

    always @(funct_type1 or funct_type2 or op or Zero)begin
        PCSrc       = 2'b00;
        MemWrite    = 1'b0;
        ALUSrc      = 1'b0;
        RegWrite    = 1'b0;
        ResultSrc   = 2'b00;
        ALUControl  = 3'b000;
        ImmSrc      = 3'b000;
         case (op)
            R_type_opc: begin
                RegWrite = 1'b1;
                case (funct_type1)
                    Add_funct: ALUControl = 3'b000;
                    Sub_funct: ALUControl = 3'b001;
                    And_funct: ALUControl = 3'b010; 
                    Or_funct : ALUControl = 3'b011; 
                    Slt_funct: ALUControl = 3'b100;
                endcase
            end

            I_type_opc: begin
                ALUSrc    = 1'b1;
                RegWrite  = 1'b1;
                case (funct_type2)
                    Addi_funct: ALUControl = 3'b000;
                    Ori_funct : ALUControl = 3'b011;
                    Slti_funct: ALUControl = 3'b100;
                endcase
            end

            Lw_opc: begin
                ResultSrc = 2'b01;
                ALUSrc     = 1'b1;
                RegWrite   = 1'b1;
            end

            Sw_opc: begin
                ALUSrc     = 1'b1;
                MemWrite   = 1'b1;
                ImmSrc     = 3'b001;
            end

            Jalr_opc: begin
                PCSrc       = 2'b10;
                ResultSrc   = 2'b10;
                ALUSrc      = 1'b1;
                RegWrite   = 1'b1;
                ImmSrc     = 3'b011;
            end

            Jal_opc: begin
                PCSrc       = 2'b01;
                ResultSrc   = 2'b10;
                RegWrite    = 1'b1;
                ImmSrc      = 3'b100;
            end

            B_type_opc: begin
                ImmSrc = 3'b010;
                ALUControl = 3'b001;
                case (funct_type2)
                    Beq_funct: PCSrc = {1'b0, Zero};
                    Bne_funct: PCSrc = {1'b0, ~Zero};
                endcase
            end

            Lui_opc: begin
                ResultSrc   = 2'b11;
                RegWrite    = 1'b1;
                ImmSrc      = 3'b101;
            end
        endcase
    end

endmodule