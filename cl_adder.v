module cl_adder(data_A, data_B, Cin, out, overflow);
    input [31:0] data_A, data_B;
    input Cin;
    output [31:0] out;
    output overflow;

    //use bitwise addition on each one, where each kth bitwise add also incorporates p, g
    //sum each bit of A, B using one_bit_adder
    //carryin Ci is determined from p(i), g(i) functions
    wire G0, P0, G1, P1, G2, P2, G3, P3;
    wire c7, c15, c23, c31;
    //block 1
    cl_sub_adder block1(.data_A(data_A[7:0]), .data_B(data_B[7:0]), .Cin(Cin), .S(out[7:0]), .G(G0), .P(P0), .overflow(c7));
    //c8 = G0 + P0c0
    wire c8, c8a;
    and ANDC81(c8a, P0, Cin);
    or ORC8(c8, G0, c8a);
    //block 2
    cl_sub_adder block2(.data_A(data_A[15:8]), .data_B(data_B[15:8]), .Cin(c8), .S(out[15:8]), .G(G1), .P(P1), .overflow(c15));
    //c16 = G1 + P1G0 + P1P0c0
    wire c16, c16a, c16b;
    // and ANDC161(c16a, P1, G0);
    // and ANDC162(C16b, P1, P0, Cin);
    // or ORC16(c16, G1, c16a, c16b);
    and ANDTEST(c16a, P1, c8);
    or ORTEST1(c16, G1, c16a);
    //block 3
    cl_sub_adder block3(.data_A(data_A[23:16]), .data_B(data_B[23:16]), .Cin(c16), .S(out[23:16]), .G(G2), .P(P2), .overflow(c23));
    //c24 = G2 + P2G1 + P2P1G0 + P2P1P0c0
    wire c24, c2a, c2b, c2c;
    // and ANDC21(c2a, P2, G1);
    // and ANDC22(c2b, P2, P1, G0);
    // and ANDC23(c2c, P2, P1, P0, Cin);
    // or ORC24(c24, G2, c2a, c2b, c2c);
    and ANDTEST1(c2a, P2, c16);
    or ORTEST2(c24, G2, c2a);
    //block 4
    cl_sub_adder block4(.data_A(data_A[31:24]), .data_B(data_B[31:24]), .Cin(c24), .S(out[31:24]), .G(G3), .P(P3), .overflow(c31));
    //c32 = G3 + P3G2 + P3P2G1 + P3P2P1G0 + P3P2P1P0c0
    wire c32, c3a, c3b, c3c, c3d;
    and AND31(c3a, P3, G2);
    and AND32(c3b, P3, P2, G1);
    and AND33(c3c, P3, P2, P1, G0);
    and AND34(c3d, P3, P2, P1, P0, Cin);
    or ORC32(c32, G3, c3a, c3b, c3c, c3d);
    //c31 xor c32 == overflow
    xor XOR1(overflow, c31, c32);
endmodule
