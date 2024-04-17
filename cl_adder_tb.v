`timescale 1ns / 1ps

module cl_adder_tb;

  // Inputs
  reg [31:0] data_A, data_B;
  reg Cin;

  // Outputs
  wire [31:0] out;
  wire overflow;

  // Instantiate the 32-bit Carry-Lookahead Adder
  cl_adder uut (
    .data_A(data_A),
    .data_B(data_B),
    .Cin(Cin),
    .out(out),
    .overflow(overflow)
  );

  // Clock generation
  reg clk = 0;
  always #5 clk = ~clk;

  // Testbench stimulus
  initial begin
    $monitor("Time=%0t A=%h B=%h Cin=%b Sum=%b Overflow=%b", $time, data_A, data_B, Cin, out, overflow);

    // Test Case 1
    data_A = 32'd0;
    data_B = 32'hFFFFFFFF;
    Cin = 0;
    #10;

    // Test Case 2
    data_A = 32'd80000000;
    data_B = 32'd80000000;
    Cin = 0;
    #10;

    // Test Case 3
    data_A = 32'h0;
    data_B = 32'h0;
    Cin = 1;
    #10;

    // Test Case 4
    data_A = 32'hFFFFFFFF;
    data_B = 32'h00000001;
    Cin = 0;
    #10;

    // Add more test cases as needed

    #100 $finish;
  end

    initial begin
       $dumpfile("cl_adder_wave.vcd");
       $dumpvars(0, cl_adder_tb);
    end

  // Clock driver
  always #1 clk = ~clk;

endmodule
