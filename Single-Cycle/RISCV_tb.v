`timescale 1ns/1ps

module riscv_tb();
  reg clk   = 0;
  reg reset = 1;

  always #5 clk = ~clk;

  riscv uut (
    .clk(clk),
    .reset(reset)
  );

  initial begin
    #10;
    reset = 0;

    #2560;
    $stop;
  end

endmodule
