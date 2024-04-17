module sra(data, shiftamt, out);
    input [31:0] data;
    input [4:0] shiftamt;
    output [31:0] out;

    //filter shiftamt into 32, 16, 8, 4, 2, 1 bit shifts
    wire shiftby1, shiftby2, shiftby4, shiftby8, shiftby16;
    assign shiftby1 = shiftamt[0];
    assign shiftby2 = shiftamt[1];
    assign shiftby4 = shiftamt[2];
    assign shiftby8 = shiftamt[3];
    assign shiftby16 = shiftamt[4];

    //shift by that much
    wire [31:0] w16, w8, w4, w2;
    wire [31:0] shifted16, shifted8, shifted4, shifted2, shifted1;
    //shift by 16?
    sra_16 sh16(.data(data), .out(shifted16));
    mux_2 first(.out(w16), .select(shiftby16), .in0(data), .in1(shifted16));
    //shift by 8?
    sra_8 sh8(.data(w16), .out(shifted8));
    mux_2 second(.out(w8), .select(shiftby8), .in0(w16), .in1(shifted8));
    //shift by 4?
    sra_4 sh4(.data(w8), .out(shifted4));
    mux_2 third(.out(w4), .select(shiftby4), .in0(w8), .in1(shifted4));
    //shift by 2?
    sra_2 sh2(.data(w4), .out(shifted2));
    mux_2 fourth(.out(w2), .select(shiftby2), .in0(w4), .in1(shifted2));
    //shift by 1? data out regardless
    sra_1 sh1(.data(w2), .out(shifted1));
    mux_2 last(.out(out), .select(shiftby1), .in0(w2), .in1(shifted1));
endmodule