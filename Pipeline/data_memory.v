module data_memory (
    input clk, WE,
    input [31:0] A,
    input [31:0] WD,
    output [31:0] RD
);
    reg [7:0] mem_byte [0:1023]; 
    wire [31:0] adr;
    assign adr = {A[31:2],2'b00};
    initial begin
        $readmemh("data_memory.mem", mem_byte); 
    end
    assign RD = {mem_byte[adr], mem_byte[adr + 1], mem_byte[adr + 2], mem_byte[adr + 3]};
    always @(posedge clk) begin
        if (WE)
            {mem_byte[adr], mem_byte[adr + 1], mem_byte[adr + 2], mem_byte[adr + 3]} <= WD;  
    end

endmodule