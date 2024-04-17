module bitwise_or(data_A, data_B, out);
    input [31:0] data_A, data_B;
    output [31:0] out;
    //performs bitwise or on A || B, returns output
    //OR each individual bit, and then assign to the output bit?

    or or1(out[0], data_A[0], data_B[0]);
    or or2(out[1], data_A[1], data_B[1]);
    or or3(out[2], data_A[2], data_B[2]);
    or or4(out[3], data_A[3], data_B[3]);
    or or5(out[4], data_A[4], data_B[4]);
    or or6(out[5], data_A[5], data_B[5]);
    or or7(out[6], data_A[6], data_B[6]);
    or or8(out[7], data_A[7], data_B[7]);
    or or9(out[8], data_A[8], data_B[8]);
    or or10(out[9], data_A[9], data_B[9]);
    or or11(out[10], data_A[10], data_B[10]);
    or or12(out[11], data_A[11], data_B[11]);
    or or13(out[12], data_A[12], data_B[12]);
    or or14(out[13], data_A[13], data_B[13]);
    or or15(out[14], data_A[14], data_B[14]);
    or or16(out[15], data_A[15], data_B[15]);
    or or17(out[16], data_A[16], data_B[16]);
    or or18(out[17], data_A[17], data_B[17]);
    or or19(out[18], data_A[18], data_B[18]);
    or or20(out[19], data_A[19], data_B[19]);
    or or21(out[20], data_A[20], data_B[20]);
    or or22(out[21], data_A[21], data_B[21]);
    or or23(out[22], data_A[22], data_B[22]);
    or or24(out[23], data_A[23], data_B[23]);
    or or25(out[24], data_A[24], data_B[24]);
    or or26(out[25], data_A[25], data_B[25]);
    or or27(out[26], data_A[26], data_B[26]);
    or or28(out[27], data_A[27], data_B[27]);
    or or29(out[28], data_A[28], data_B[28]);
    or or30(out[29], data_A[29], data_B[29]);
    or or31(out[30], data_A[30], data_B[30]);
    or or32(out[31], data_A[31], data_B[31]);
endmodule