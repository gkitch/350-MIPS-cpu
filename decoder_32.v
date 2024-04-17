module decoder_32(out, select);
    input [4:0] select;
    output [31:0] out;
    wire enable;
    assign enable = 1'b1;
    assign out = enable << select;
endmodule