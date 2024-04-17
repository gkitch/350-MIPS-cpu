module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // add your code here:
    //barrel shifter left, right
    wire [31:0] sllOut, sraOut;
    sll barrel_left(.data(data_operandA), .shiftamt(ctrl_shiftamt), .out(sllOut));
    sra barrel_right(.data(data_operandA), .shiftamt(ctrl_shiftamt), .out(sraOut));

    //and, or
    wire [31:0] andOut, orOut;
    bitwise_and myAnd(.data_A(data_operandA), .data_B(data_operandB), .out(andOut));
    bitwise_or myOr(.data_A(data_operandA), .data_B(data_operandB), .out(orOut));

    //add
    wire [31:0] addOut;
    wire addOverflow;
    cl_adder add(.data_A(data_operandA), .data_B(data_operandB), .Cin(1'b0), .out(addOut), .overflow(addOverflow));
    //subtract
    wire [31:0] subOut, data_operandB_not;
    wire subOverflow;
    bitwise_not myNot(.out(data_operandB_not), .data(data_operandB));
    cl_adder sub(.data_A(data_operandA), .data_B(data_operandB_not), .Cin(1'b1), .out(subOut), .overflow(subOverflow));

    //if subOut == 0, 1. else 0
    assign isNotEqual = subOut ? 1 : 0;

    //if not overflow and subout, or overflow and A < 0 and subOut >= 0
    wire notOvf, notSubOut, w1, w2;
    not not2(notOvf, subOverflow);
    not not3(notSubOut, subOut[31]);
    and and11(w1, subOut[31], notOvf);
    and and12(w2, notSubOut, data_operandA[31], subOverflow);
    or or11(isLessThan, w1, w2);

    //select our correct overflow
    mux_2_1bit overflow_select(.out(overflow), .select(ctrl_ALUopcode[0]), .in0(addOverflow), .in1(subOverflow));

    //select our output
    // modify so that in6 is mult, in7 is div
    mux_8 function_select(.out(data_result), .select(ctrl_ALUopcode[2:0]), .in0(addOut), .in1(subOut), .in2(andOut), .in3(orOut), .in4(sllOut), .in5(sraOut), .in6(32'b0), .in7(32'b0));

endmodule