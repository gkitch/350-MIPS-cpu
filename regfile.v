module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	// add your code here
	//decode writeReg so that inEnable[i] is on only on for writeReg value i
	wire [31:0] inEnableTemp, inEnable;
	decoder_32 decoder1(.out(inEnableTemp), .select(ctrl_writeReg));

	genvar i;
	generate
		for (i = 0; i <= 31; i = i + 1) begin: loop1
			wire w1;
			and AND1(w1, ctrl_writeEnable, inEnableTemp[i]);
			assign inEnable[i] = w1;
		end
	endgenerate

	//output from each register
	wire [31:0] out0, out1, out2, out3, out4, out5, out6, out7,
                out8, out9, out10, out11, out12, out13, out14, out15,
                out16, out17, out18, out19, out20, out21, out22, out23,
                out24, out25, out26, out27, out28, out29, out30, out31;

	register0 reg0(.readOut(out0), .clk(clock), .in_enable(inEnable[0]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg1(.readOut(out1), .clk(clock), .in_enable(inEnable[1]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg2(.readOut(out2), .clk(clock), .in_enable(inEnable[2]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg3(.readOut(out3), .clk(clock), .in_enable(inEnable[3]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg4(.readOut(out4), .clk(clock), .in_enable(inEnable[4]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg5(.readOut(out5), .clk(clock), .in_enable(inEnable[5]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg6(.readOut(out6), .clk(clock), .in_enable(inEnable[6]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg7(.readOut(out7), .clk(clock), .in_enable(inEnable[7]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg8(.readOut(out8), .clk(clock), .in_enable(inEnable[8]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg9(.readOut(out9), .clk(clock), .in_enable(inEnable[9]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg10(.readOut(out10), .clk(clock), .in_enable(inEnable[10]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg11(.readOut(out11), .clk(clock), .in_enable(inEnable[11]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg12(.readOut(out12), .clk(clock), .in_enable(inEnable[12]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg13(.readOut(out13), .clk(clock), .in_enable(inEnable[13]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg14(.readOut(out14), .clk(clock), .in_enable(inEnable[14]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg15(.readOut(out15), .clk(clock), .in_enable(inEnable[15]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg16(.readOut(out16), .clk(clock), .in_enable(inEnable[16]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg17(.readOut(out17), .clk(clock), .in_enable(inEnable[17]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg18(.readOut(out18), .clk(clock), .in_enable(inEnable[18]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg19(.readOut(out19), .clk(clock), .in_enable(inEnable[19]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg20(.readOut(out20), .clk(clock), .in_enable(inEnable[20]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg21(.readOut(out21), .clk(clock), .in_enable(inEnable[21]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg22(.readOut(out22), .clk(clock), .in_enable(inEnable[22]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg23(.readOut(out23), .clk(clock), .in_enable(inEnable[23]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg24(.readOut(out24), .clk(clock), .in_enable(inEnable[24]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg25(.readOut(out25), .clk(clock), .in_enable(inEnable[25]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg26(.readOut(out26), .clk(clock), .in_enable(inEnable[26]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg27(.readOut(out27), .clk(clock), .in_enable(inEnable[27]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg28(.readOut(out28), .clk(clock), .in_enable(inEnable[28]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg29(.readOut(out29), .clk(clock), .in_enable(inEnable[29]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg30(.readOut(out30), .clk(clock), .in_enable(inEnable[30]), .writeIn(data_writeReg), .clear(ctrl_reset));
	register reg31(.readOut(out31), .clk(clock), .in_enable(inEnable[31]), .writeIn(data_writeReg), .clear(ctrl_reset));

	//now, tristate for readOut1 and readOut2 to pick which is outputted
	wire [31:0] outEnableA, outEnableB;
	decoder_32 decoder2(.out(outEnableA), .select(ctrl_readRegA));
	decoder_32 decoder3(.out(outEnableB), .select(ctrl_readRegB));

	//tristate(data_readRegA, outX, outEnableA[X])
	tristate buf0(data_readRegA, out0, outEnableA[0]);
	tristate buf1(data_readRegA, out1, outEnableA[1]);
	tristate buf2(data_readRegA, out2, outEnableA[2]);
	tristate buf3(data_readRegA, out3, outEnableA[3]);
	tristate buf4(data_readRegA, out4, outEnableA[4]);
	tristate buf5(data_readRegA, out5, outEnableA[5]);
	tristate buf6(data_readRegA, out6, outEnableA[6]);
	tristate buf7(data_readRegA, out7, outEnableA[7]);
	tristate buf8(data_readRegA, out8, outEnableA[8]);
	tristate buf9(data_readRegA, out9, outEnableA[9]);
	tristate buf10(data_readRegA, out10, outEnableA[10]);
	tristate buf11(data_readRegA, out11, outEnableA[11]);
	tristate buf12(data_readRegA, out12, outEnableA[12]);
	tristate buf13(data_readRegA, out13, outEnableA[13]);
	tristate buf14(data_readRegA, out14, outEnableA[14]);
	tristate buf15(data_readRegA, out15, outEnableA[15]);
	tristate buf16(data_readRegA, out16, outEnableA[16]);
	tristate buf17(data_readRegA, out17, outEnableA[17]);
	tristate buf18(data_readRegA, out18, outEnableA[18]);
	tristate buf19(data_readRegA, out19, outEnableA[19]);
	tristate buf20(data_readRegA, out20, outEnableA[20]);
	tristate buf21(data_readRegA, out21, outEnableA[21]);
	tristate buf22(data_readRegA, out22, outEnableA[22]);
	tristate buf23(data_readRegA, out23, outEnableA[23]);
	tristate buf24(data_readRegA, out24, outEnableA[24]);
	tristate buf25(data_readRegA, out25, outEnableA[25]);
	tristate buf26(data_readRegA, out26, outEnableA[26]);
	tristate buf27(data_readRegA, out27, outEnableA[27]);
	tristate buf28(data_readRegA, out28, outEnableA[28]);
	tristate buf29(data_readRegA, out29, outEnableA[29]);
	tristate buf30(data_readRegA, out30, outEnableA[30]);
	tristate buf31(data_readRegA, out31, outEnableA[31]);

	tristate bufB0(data_readRegB, out0, outEnableB[0]);
	tristate bufB1(data_readRegB, out1, outEnableB[1]);
	tristate bufB2(data_readRegB, out2, outEnableB[2]);
	tristate bufB3(data_readRegB, out3, outEnableB[3]);
	tristate bufB4(data_readRegB, out4, outEnableB[4]);
	tristate bufB5(data_readRegB, out5, outEnableB[5]);
	tristate bufB6(data_readRegB, out6, outEnableB[6]);
	tristate bufB7(data_readRegB, out7, outEnableB[7]);
	tristate bufB8(data_readRegB, out8, outEnableB[8]);
	tristate bufB9(data_readRegB, out9, outEnableB[9]);
	tristate bufB10(data_readRegB, out10, outEnableB[10]);
	tristate bufB11(data_readRegB, out11, outEnableB[11]);
	tristate bufB12(data_readRegB, out12, outEnableB[12]);
	tristate bufB13(data_readRegB, out13, outEnableB[13]);
	tristate bufB14(data_readRegB, out14, outEnableB[14]);
	tristate bufB15(data_readRegB, out15, outEnableB[15]);
	tristate bufB16(data_readRegB, out16, outEnableB[16]);
	tristate bufB17(data_readRegB, out17, outEnableB[17]);
	tristate bufB18(data_readRegB, out18, outEnableB[18]);
	tristate bufB19(data_readRegB, out19, outEnableB[19]);
	tristate bufB20(data_readRegB, out20, outEnableB[20]);
	tristate bufB21(data_readRegB, out21, outEnableB[21]);
	tristate bufB22(data_readRegB, out22, outEnableB[22]);
	tristate bufB23(data_readRegB, out23, outEnableB[23]);
	tristate bufB24(data_readRegB, out24, outEnableB[24]);
	tristate bufB25(data_readRegB, out25, outEnableB[25]);
	tristate bufB26(data_readRegB, out26, outEnableB[26]);
	tristate bufB27(data_readRegB, out27, outEnableB[27]);
	tristate bufB28(data_readRegB, out28, outEnableB[28]);
	tristate bufB29(data_readRegB, out29, outEnableB[29]);
	tristate bufB30(data_readRegB, out30, outEnableB[30]);
	tristate bufB31(data_readRegB, out31, outEnableB[31]);

endmodule
