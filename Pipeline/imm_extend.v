module imm_extend (
    input [24:0] instr,
    input [2:0] ImmSrc,
    output reg  [31:0] ImmExt
);
    parameter [2:0] I_type = 3'b000, S_type = 3'b001, B_type = 3'b010, Jalr_type = 3'b011, Jal_type = 3'b100, Lui_type = 3'b101;

    always @(ImmSrc or instr) begin
        case (ImmSrc)
            I_type:
                ImmExt = {{20{instr[24]}}, instr[24:13]};

            S_type:
                ImmExt = {{20{instr[24]}}, instr[24:18], instr[4:0]};

            B_type:
                ImmExt ={{19{instr[24]}}, {instr[24], instr[0], instr[23:18], instr[4:1], 1'b0}};
            
            Jalr_type:
                ImmExt = {{20{instr[24]}}, instr[24:13]};

            Jal_type:
                ImmExt = {{11{instr[24]}}, instr[24], instr[12:5], instr[13], instr[23:14], 1'b0};

            Lui_type:
                ImmExt = {instr[24:5], 12'b0};  

            default:
                ImmExt = {{20{instr[24]}},instr[24:13]};
        endcase
    end

endmodule