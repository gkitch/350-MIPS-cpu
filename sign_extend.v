module sign_extend(data, out);
    input [16:0] data;
    output [31:0] out;

    wire msb;
    assign msb = data[16];

    assign out[31] = msb;
    assign out[30] = msb;
    assign out[29] = msb;
    assign out[28] = msb;
    assign out[27] = msb;
    assign out[26] = msb;
    assign out[25] = msb;
    assign out[24] = msb;
    assign out[23] = msb;
    assign out[22] = msb;
    assign out[21] = msb;
    assign out[20] = msb;
    assign out[19] = msb;
    assign out[18] = msb;
    assign out[17] = msb;
    assign out[16] = msb;
    assign out[15] = data[15];
    assign out[14] = data[14];
    assign out[13] = data[13];
    assign out[12] = data[12];
    assign out[11] = data[11];
    assign out[10] = data[10];
    assign out[9] = data[9];
    assign out[8] = data[8];
    assign out[7] = data[7];
    assign out[6] = data[6];
    assign out[5] = data[5];
    assign out[4] = data[4];
    assign out[3] = data[3];
    assign out[2] = data[2];
    assign out[1] = data[1];
    assign out[0] = data[0];

endmodule