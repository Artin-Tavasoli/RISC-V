module registerFD(clk, rst, EN, CLR, InstrF, PCF, PCPlus4F, InstrD, PCD, PCPlus4D);
    input clk, rst, EN, CLR;
    input [31:0] InstrF, PCF, PCPlus4F;
    output reg [31:0] InstrD, PCD, PCPlus4D;
    always @(posedge clk or posedge rst) begin
        if(rst || CLR) begin
            InstrD <= 32'd0;
            PCD <= 32'd0;
            PCPlus4D <= 32'd0;
        end
        else if(~EN) begin
            InstrD <= InstrF;
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;
        end
    end
endmodule