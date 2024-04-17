module sll_tb;

  // Parameters
  parameter PERIOD = 10; // Time units for simulation steps

  // Inputs
  reg [31:0] data;
  reg [4:0] shiftamt;

  // Outputs
  wire [31:0] out;

  // Instantiate the sll module
  sll my_sll(.data(data), .shiftamt(shiftamt), .out(out));

  // Initial block for testbench
  initial begin
    // Initialize inputs
    // data = 32'd12; // Replace with your test data
    // shiftamt = 2; // Replace with your desired shift amount

    // // Apply inputs and monitor outputs
    // $monitor("Time=%0t data=%b shiftamt=%b out=%b", $time, data, shiftamt, out);
    
    // Add any additional test scenarios as needed
    data = 32'd300; // Replace with your test data
    shiftamt = 17; // Replace with your desired shift amount

    // Apply inputs and monitor outputs
    $monitor("Time=%0t data=%b shiftamt=%b out=%b", $time, data, shiftamt, out);

    // Finish simulation after a certain time
    #2000 $finish;
  end

  // Add any additional logic or stimulus as needed

endmodule


// `timescale 1ns/1ps

// module testbench;

//   // Define shifter module
//   sll shifter(
//     .data(input_data),
//     .shiftamt(shift_amount),
//     .out(output_data)
//   );

//   // Declare signals
//   reg [31:0] input_data;
//   reg [4:0] shift_amount;
//   wire [31:0] output_data;

//   // Initial block
//   initial begin
//     // Test case 1
//     input_data = 32'hA5A5A5A5;
//     shift_amount = 5;
//     #10;
//     $display("Test Case 1: Input = %h, Shift Amount = %d, Output = %b", input_data, shift_amount, output_data);

//     // Test case 2
//     input_data = 32'h12345678;
//     shift_amount = 2;
//     #10;
//     $display("Test Case 2: Input = %h, Shift Amount = %d, Output = %b", input_data, shift_amount, output_data);

//     // Test case 3
//     input_data = 32'hABCDEF01;
//     shift_amount = 8;
//     #10;
//     $display("Test Case 3: Input = %h, Shift Amount = %d, Output = %b", input_data, shift_amount, output_data);

//     // Add more test cases as needed

//     // Stop simulation
//     $stop;
//   end

// endmodule
