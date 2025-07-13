module hazard_unit(Rs1D, Rs2D, PCSrcE, Rs1E, Rs2E, RdE, ResultSrcE, RdM, RegWriteM, RdW, RegWriteW, 
    StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE);

    input RegWriteM, RegWriteW, PCSrcE;
    input [1:0] ResultSrcE;
    input [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW;

    output StallF, StallD, FlushD, FlushE;
    output reg [1:0] ForwardAE, ForwardBE;

    // Data Hazard
    always  @(Rs1E or RdM or RdW or RegWriteM or RegWriteW)begin
        if(Rs1E == 5'b0)
            ForwardAE = 2'b00;
        else if ((Rs1E==RdM) && (RegWriteM) && (Rs1E))
            ForwardAE = 2'b10;
        else if((Rs1E==RdW) && (RegWriteW) && (Rs1E))
            ForwardAE = 2'b01;
        else
            ForwardAE = 2'b00;
    end

    always @(Rs2E or RdM or RdW or RegWriteM or RegWriteW)begin 
        if(Rs2E == 5'b0)
            ForwardBE = 2'b00;
        else if ((Rs2E==RdM) && (RegWriteM) && (Rs2E))
            ForwardBE = 2'b10;
        else if((Rs2E==RdW) && (RegWriteW) && (Rs2E))
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
    end

    // load word stall
    wire lwStall;
    assign lwStall = (((Rs1D == RdE) || (Rs2D == RdE)) && (ResultSrcE==2'b01) && (RdE)) ? 1'b1 : 1'b0;
    assign StallF = lwStall ? 1'b1 : 1'b0;
    assign StallD = lwStall ? 1'b1 : 1'b0;

    // control hazard
    assign FlushD = PCSrcE ? 1'b1 : 1'b0;
    assign FlushE = (lwStall || PCSrcE) ? 1'b1 : 1'b0;
endmodule