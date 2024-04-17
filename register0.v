module register0(readOut, clk, in_enable, writeIn, clear);
    //clear = ctrl_reset, 
    input clk, in_enable, clear;
    input [31:0] writeIn;
    output [31:0] readOut;

    //we want 32 flipflops, each with input data_in[i], and output toOut[i]
    wire [31:0] toOut;

    assign readOut = 32'b0;

endmodule