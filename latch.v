module latch(pc, instruction, clk, reset, en, data_A, data_B, pcOut, insnOut, data_A_out, data_B_out);
    input clk, reset, en;
    input [31:0] pc, instruction, data_A, data_B;
    output [31:0] pcOut, insnOut, data_A_out, data_B_out;

    register myPC(.readOut(pcOut), .clk(clk), .in_enable(en), .writeIn(pc), .clear(reset));
    register insn(.readOut(insnOut), .clk(clk), .in_enable(en), .writeIn(instruction), .clear(reset));
    register dataA(.readOut(data_A_out), .clk(clk), .in_enable(en), .writeIn(data_A), .clear(reset));
    register dataB(.readOut(data_B_out), .clk(clk), .in_enable(en), .writeIn(data_B), .clear(reset));

endmodule