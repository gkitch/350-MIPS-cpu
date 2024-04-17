module bitwise_and(data_A, data_B, out);
    input [31:0] data_A, data_B;
    output [31:0] out;
    //performs bitwise and on A && B, returns output
    //AND each individual bit, and then assign to the output bit?
    
    and AND1(out[0], data_A[0], data_B[0]);
    and AND2(out[1], data_A[1], data_B[1]);
    and AND3(out[2], data_A[2], data_B[2]);
    and AND4(out[3], data_A[3], data_B[3]);
    and AND5(out[4], data_A[4], data_B[4]);
    and AND6(out[5], data_A[5], data_B[5]);
    and AND7(out[6], data_A[6], data_B[6]);
    and AND8(out[7], data_A[7], data_B[7]);
    and AND9(out[8], data_A[8], data_B[8]);
    and AND10(out[9], data_A[9], data_B[9]);
    and AND11(out[10], data_A[10], data_B[10]);
    and AND12(out[11], data_A[11], data_B[11]);
    and AND13(out[12], data_A[12], data_B[12]);
    and AND14(out[13], data_A[13], data_B[13]);
    and AND15(out[14], data_A[14], data_B[14]);
    and AND16(out[15], data_A[15], data_B[15]);
    and AND17(out[16], data_A[16], data_B[16]);
    and AND18(out[17], data_A[17], data_B[17]);
    and AND19(out[18], data_A[18], data_B[18]);
    and AND20(out[19], data_A[19], data_B[19]);
    and AND21(out[20], data_A[20], data_B[20]);
    and AND22(out[21], data_A[21], data_B[21]);
    and AND23(out[22], data_A[22], data_B[22]);
    and AND24(out[23], data_A[23], data_B[23]);
    and AND25(out[24], data_A[24], data_B[24]);
    and AND26(out[25], data_A[25], data_B[25]);
    and AND27(out[26], data_A[26], data_B[26]);
    and AND28(out[27], data_A[27], data_B[27]);
    and AND29(out[28], data_A[28], data_B[28]);
    and AND30(out[29], data_A[29], data_B[29]);
    and AND31(out[30], data_A[30], data_B[30]);
    and AND32(out[31], data_A[31], data_B[31]);
endmodule