module cl_sub_adder(data_A, data_B, Cin, S, G, P, overflow);
    input [7:0] data_A, data_B;
    input Cin;
    output [7:0] S;
    output G, P, overflow;

    wire [7:0] g, p, c;
    //G[i] = A[i] • B[i] (i.e. data_A && data_B)
    and AND1(g[0], data_A[0], data_B[0]);
    and AND2(g[1], data_A[1], data_B[1]);
    and AND3(g[2], data_A[2], data_B[2]);
    and AND4(g[3], data_A[3], data_B[3]);
    and AND5(g[4], data_A[4], data_B[4]);
    and AND6(g[5], data_A[5], data_B[5]);
    and AND7(g[6], data_A[6], data_B[6]);
    and AND8(g[7], data_A[7], data_B[7]);
    //P[i] = A[i] or B[i] (bitwise)
    or or1(p[0], data_A[0], data_B[0]);
    or or2(p[1], data_A[1], data_B[1]);
    or or3(p[2], data_A[2], data_B[2]);
    or or4(p[3], data_A[3], data_B[3]);
    or or5(p[4], data_A[4], data_B[4]);
    or or6(p[5], data_A[5], data_B[5]);
    or or7(p[6], data_A[6], data_B[6]);
    or or8(p[7], data_A[7], data_B[7]);

    //now that we have defined p, g, we can define Ci
    //c[i + 1] = gi + pi gi-1 + pi pi-1 gi-2 + ... + pi pi-1 .. p1 g0 + pi pi-1 ... p1 p0 c0
    //c0
    assign c[0] = Cin;
    //c1 = g0 + p0c0
    wire wc1;
    and andC1(wc1, p[0], c[0]);
    or orC1(c[1], g[0], wc1);
    //c2 = g1 + p1g0 + p1p0c0
    wire wc21, wc22;
    and andC21(wc21, p[1], g[0]);
    and andC22(wc22, p[1], p[0], c[0]);
    or orC2(c[2], g[1], wc21, wc22);
    //c3 = g2 + p2g1 + p2p1g0 + p2p1p0c0
    wire wc31, wc32, wc33;
    and andC31(wc31, p[2], g[1]);
    and andC32(wc32, p[2], p[1], g[0]);
    and andC33(wc33, p[2], p[1], p[0], c[0]);
    or orC3(c[3], g[2], wc31, wc32, wc33);
    //c4 = g3 + p3g2 + p3p2g1 + p3p2p1g0 + p3p2p1p0c0
    wire wc41, wc42, wc43, wc44;
    and andC41(wc41, p[3], g[2]);
    and andC42(wc42, p[3], p[2], g[1]);
    and andC43(wc43, p[3], p[2], p[1], g[0]);
    and andC44(wc44, p[3], p[2], p[1], p[0], c[0]);
    or orC4(c[4], g[3], wc41, wc42, wc43, wc44);
    //c5 = g4 + p4g3 + p4p3g2 + p4p3p2g1 + p4p3p2p1g0 + p4p3p2p1p0c0
    wire wc51, wc52, wc53, wc54, wc55;
    and andC51(wc51, p[4], g[3]);
    and andC52(wc52, p[4], p[3], g[2]);
    and andC53(wc53, p[4], p[3], p[2], g[1]);
    and andC54(wc54, p[4], p[3], p[2], p[1], g[0]);
    and andC55(wc55, p[4], p[3], p[2], p[1], p[0], c[0]);
    or orC5(c[5], g[4], wc51, wc52, wc53, wc54, wc55);
    //c6 = g5 + p5g4 + p5p4g3 + p5p4p3g2 + p5p4p3p2g1 + p5p4p3p2p1g0 + p5p4p3p2p1p0c0
    wire wc61, wc62, wc63, wc64, wc65, wc66;
    and andC61(wc61, p[5], g[4]);
    and andC62(wc62, p[5], p[4], g[3]);
    and andC63(wc63, p[5], p[4], p[3], g[2]);
    and andC64(wc64, p[5], p[4], p[3], p[2], g[1]);
    and andC65(wc65, p[5], p[4], p[3], p[2], p[1], g[0]);
    and andC66(wc66, p[5], p[4], p[3], p[2], p[1], p[0], c[0]);
    or orC6(c[6], g[5], wc61, wc62, wc63, wc64, wc65, wc66);
    //c7 = g6 + p6g5 + p6p5g4 + p6p5p4g3 + p6p5p4p3g2 + p6p5p4p3p2g1 + p6p5p4p3p2p1g0 + p6p5p4p3p2p1p0g0
    wire wc71, wc72, wc73, wc74, wc75, wc76, wc77;
    and andC71(wc71, p[6], g[5]);
    and andC72(wc72, p[6], p[5], g[4]);
    and andC73(wc73, p[6], p[5], p[4], g[3]);
    and andC74(wc74, p[6], p[5], p[4], p[3], g[2]);
    and andC75(wc75, p[6], p[5], p[4], p[3], p[2], g[1]);
    and andC76(wc76, p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and andC77(wc77, p[6], p[5], p[4], p[3], p[2], p[1], p[0], c[0]);
    or orC7(c[7], g[6], wc71, wc72, wc73, wc74, wc75, wc76, wc77);

    //once all c[0...7] are calculated, bitwise sums
    xor XOR0(S[0], data_A[0], data_B[0], c[0]);
    xor XOR1(S[1], data_A[1], data_B[1], c[1]);
    xor XOR2(S[2], data_A[2], data_B[2], c[2]);
    xor XOR3(S[3], data_A[3], data_B[3], c[3]);
    xor XOR4(S[4], data_A[4], data_B[4], c[4]);
    xor XOR5(S[5], data_A[5], data_B[5], c[5]);
    xor XOR6(S[6], data_A[6], data_B[6], c[6]);
    xor XOR7(S[7], data_A[7], data_B[7], c[7]);

    //P0 = p0p1p2p3p4p5p6p7
    and andP(P, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    
    //G0 = g7 + p7g6 + p7p6 g5 + p7p6p5 g4 + ... + p7p6p5p4p3p2p1 g0
    wire wG1, wG2, wG3, wG4, wG5, wG6, wG7;
    and andG1(wG1, g[6], p[7]);
    and andG2(wG2, g[5], p[7], p[6]);
    and andG3(wG3, g[4], p[7], p[6], p[5]);
    and andG4(wG4, g[3], p[7], p[6], p[5], p[4]);
    and andG5(wG5, g[2], p[7], p[6], p[5], p[4], p[3]);
    and andG6(wG6, g[1], p[7], p[6], p[5], p[4], p[3], p[2]);
    and andG7(wG7, g[0], p[7], p[6], p[5], p[4], p[3], p[2], p[1]);
    or orG(G, g[7], wG1, wG2, wG3, wG4, wG5, wG6, wG7);

    assign overflow = c[7];

endmodule
