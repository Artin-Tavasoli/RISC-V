module alu (A, B, ALUControl, ALUResult, Zero);
    input [31:0] A, B;
    input [2:0] ALUControl;
    output reg [31:0] ALUResult;
    output  Zero;
    always @(ALUControl or A or B) begin
        case (ALUControl)
            3'b000: ALUResult = A + B;              
            3'b001: ALUResult = A - B;              
            3'b010: ALUResult = A & B;              
            3'b011: ALUResult = A | B;             
            3'b100: ALUResult = (A < B) ? 32'd1 : 32'd0; 
            default: ALUResult = 0;
        endcase
    end
    assign Zero = (~|ALUResult);
endmodule
