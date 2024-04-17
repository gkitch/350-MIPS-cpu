module register(readOut, clk, in_enable, writeIn, clear);
    //clear = ctrl_reset, 
    input clk, in_enable, clear;
    input [31:0] writeIn;
    output [31:0] readOut;

    //we want 32 flipflops, each with input data_in[i], and output toOut[i]
    wire [31:0] toOut;

    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin: loop1
            dffe_ref my_dff(.d(writeIn[i]), .q(readOut[i]), .clk(clk), .en(in_enable), .clr(clear));
        end
    endgenerate

endmodule