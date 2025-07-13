module instruction_memory (
    input [31:0] A,
    output [31:0] RD
);
    reg [7:0] mem_byte [0:1023]; 
    wire [31:0] adr;
    assign adr = {A[31:2],2'b00};
    initial begin
        $readmemh("instruction_memory.mem", mem_byte); 
    end
    assign RD = {mem_byte[adr], mem_byte[adr + 1], mem_byte[adr + 2], mem_byte[adr + 3]};
endmodule