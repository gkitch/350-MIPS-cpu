/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
    // global
    wire flush;
    wire [31:0] nop;
    assign nop = 32'b0;

    // ******* FETCH *******
    wire [31:0] pc_in, pc_out, pc_plus1;
    wire pc_ovf;
    cl_adder next_pc(.data_A(pc_out), .data_B(32'b0), .Cin(1'b1), .out(pc_plus1), .overflow(pc_ovf));
    // if we branch, then take branch_pc; if we jump, take jump_pc, else pc_plus1
    wire [31:0] temp_pc, temp2_pc;
    assign temp_pc = take_branch ? branch_pc : pc_plus1;
    assign temp2_pc = bex_insn ? bex_pc : temp_pc;
    assign pc_in = jump_insn ? jump_pc : temp2_pc;
    register pc_reg(.readOut(pc_out), .clk(~clock), .in_enable(~(multdiv_stall || stall)), .writeIn(pc_in), .clear(reset));
    assign address_imem = pc_out;
    // now, q_imem is our instruction
    // do we need to flush our insn?
    wire [31:0] new_q_imem;
    assign new_q_imem = flush ? nop : q_imem;

    // F/D Latch
    wire [31:0] fd_data_A, fd_data_B, fd_insn, fd_pc;
    // set enable for multdiv
    latch fd(.pc(address_imem), .instruction(new_q_imem), .clk(~clock), .reset(reset), .en(~(stall || multdiv_stall)), .data_A(32'b0), .data_B(32'b0),
                .pcOut(fd_pc), .insnOut(fd_insn), .data_A_out(fd_data_A), .data_B_out(fd_data_B));

    // ******* DECODE *******
    // r type wires
    wire [4:0] rs, rt, rd, temp_regB, d_opcode;
    assign d_opcode = fd_insn[31:27];
    assign rs = fd_insn[21:17];
    assign rt = fd_insn[16:12];
    assign rd = fd_insn[26:22];
    // get values from register — if we have an I type insn, then our A, B are the same???
    assign ctrl_readRegA = rs;
    // regB should either be rt (r-type), or rd (if I, JI, or JII) to sw, or rstatus if bex (10101)
    assign temp_regB = (d_opcode == 5'b00000) ? rt : rd;
    assign ctrl_readRegB = (d_opcode == 5'b10110) ? 5'b11110 : temp_regB;
    // now, data_readRegA/B automatically stores values
    // flush out an insn if we need to
    wire [31:0] new_fd_insn;
    assign new_fd_insn = flush ? nop : fd_insn;

    // D/X Latch
    wire [31:0] dx_data_A, dx_data_B, dx_insn, dx_pc;
    latch dx(.pc(fd_pc), .instruction(new_fd_insn), .clk(~clock), .reset(reset), .en(~multdiv_stall), .data_A(data_readRegA), .data_B(data_readRegB),
                .pcOut(dx_pc), .insnOut(dx_insn), .data_A_out(dx_data_A), .data_B_out(dx_data_B));

    // ****** EXECUTE *******
    // opcode
    wire [4:0] x_opcode;
    assign x_opcode = dx_insn[31:27];
    // r type wires
    wire [4:0] shamt, r_type_aluOp, aluOp, x_rd, x_rs, x_rt;
    // i type wires
    wire [16:0] immed;
    wire [31:0] extendedImmed;
    // assign values from instructions
    assign shamt = dx_insn[11:7];
    assign r_type_aluOp = dx_insn[6:2];
    assign immed = dx_insn[16:0];
    assign x_rd = dx_insn[26:22];
    assign x_rs = dx_insn[21:17];
    assign x_rt = dx_insn[16:12];
    sign_extend extendImmed(.data(immed), .out(extendedImmed));
    // pick between (sign-extended) immediate and B for second ALU input
    wire useImmed;
    wire [31:0] intoALU_B, alu_out;
    assign useImmed = (x_opcode == 5'b00000 || x_opcode == 5'b00010 || x_opcode == 5'b00110) ? 1'b0 : 1'b1;
    // intoALU_B picks between our extendedImmed for certain ops, and our bypassed alu_inB
    assign intoALU_B = useImmed ? extendedImmed : alu_inB;  //changed to alu_inB****
    // determine our aluOp, which should be add (00000) if useImmed, sub(00001) if branch, else r_type_op
    wire [4:0] temp_aluOp;
    wire is_branch_insn;
    assign is_branch_insn = (x_opcode == 5'b00010 || x_opcode == 5'b00110) ? 1'b1 : 1'b0;
    assign temp_aluOp = useImmed ? 5'b00000 : r_type_aluOp;
    assign aluOp = is_branch_insn ? 5'b00001 : temp_aluOp;
    // is it a jump insn?
    wire [31:0] jump_pc;
    wire jump_insn;
    // jump to T if j or jal, jump to $rd value if jr
    assign jump_pc = (x_opcode == 5'b00001 || x_opcode == 5'b00011) ? {5'b0, dx_insn[26:0]} : alu_inB;
    assign jump_insn = (x_opcode == 5'b00001 || x_opcode == 5'b00011 || x_opcode == 5'b00100) ? 1'b1 : 1'b0;
    // do we branch?
    // theoretically caluclate our pc_takebranch with one adder call
    wire [31:0] branch_pc;
    wire branch_ovf;
    cl_adder possible_branch(.data_A(dx_pc), .data_B(extendedImmed), .Cin(1'b1), .out(branch_pc), .overflow(branch_ovf));
    // should we bex?
    wire bex_insn;
    wire [31:0] bex_pc;
    assign bex_insn = (x_opcode == 5'b10110) && (dx_data_B != 32'b0) ? 1'b1 : 1'b0;
    assign bex_pc = {5'b0, dx_insn[26:0]};


    // ADDITIONS: Bypassing
    wire [31:0] alu_inA, alu_inB;
    wire [1:0] ctrl_aluA, temp_ctrl_aluA, ctrl_aluB, temp_ctrl_aluB;
    // if D/X.IR.RS == X/M.RD, pick X/M.IR.dataA (in0)
    // if D/X.IR.RS == M/W.RD, pick data_writeReg (in1)
    // if neither of these, pick original dx_data_A (in2)
    // if we have a branch instruction, then we should be checking D/X.rd == X/M.rd also (since rd isn't destination, it's operated on)
    // IF WE THROW AN EXCEPTION, AND THEN WRITE
    assign temp_ctrl_aluA = (((x_rs == w_rd) && (w_rd != 5'b0) ||
                            (m_opcode == 5'b10101 && x_rs == 5'b11110)) &&                              //exception --> alu with $r30
                            (x_opcode == 5'b00000 || x_opcode == 5'b01000 || x_opcode == 5'b00101||     //arithmetic
                            x_opcode == 5'b00010 || x_opcode == 5'b00110 ||                             //branching
                            x_opcode == 5'b00100 ||
                            (x_opcode == 5'b00111 && x_rs == w_rd && w_rd != 5'b0 && w_opcode != 5'b00111))) ? 2'b01 : 2'b10;                                     //jr

    assign ctrl_aluA = (((x_rs == m_rd) && (m_rd != 5'b0) ||
                            (w_opcode == 5'b10101 && x_rs == 5'b11110)) &&                              //exception --> alu with $r30
                            (x_opcode == 5'b00000 || x_opcode == 5'b01000 || x_opcode == 5'b00101 ||    //arithmetic
                            x_opcode == 5'b00010 || x_opcode == 5'b00110 ||                             //branching
                            x_opcode == 5'b00100 ||
                            (x_opcode == 5'b00111 && x_rs == m_rd && m_rd != 5'b0 && w_opcode != 5'b00111))) ? 2'b00 : temp_ctrl_aluA;

    mux_4 aluInputA(.out(alu_inA), .select(ctrl_aluA), .in0(xm_data_A), .in1(data_writeReg), .in2(dx_data_A));
    // if D/X.IR.RT == X/M.RD, pick X/M.IR.dataA (in0) {either R type or branch insn}
    // if D/X.IR.RT == M/W.RD, pick data_writeReg (in1)
    //      it must be a R-type instruction for this to hold
    // if neither of these, pick original dx_data_A (in2)
    assign temp_ctrl_aluB = ((((x_rt == m_rd) && (x_opcode == 5'b00000)) && (m_rd != 5'b0) ||           //arithmetic
                             (m_opcode == 5'b10101 && x_rt == 5'b11110)) ||                             //exception --> alu with $r30
                            ((x_rd == m_rd) && (x_opcode == 5'b00010 || x_opcode == 5'b00110 ||         //branching
                              x_opcode == 5'b00100))) ? 2'b00 : 2'b10;                                  //jr
    assign ctrl_aluB = ((((x_rt == w_rd) && (x_opcode == 5'b00000)) && (w_rd != 5'b0) ||                //arithmetic
                            (m_opcode == 5'b10101 && x_rt == 5'b11110)) ||                              //exception --> alu with $r30
                        ((x_rd == w_rd) && (x_opcode == 5'b00010 || x_opcode == 5'b00110 ||             //branching
                          x_opcode == 5'b00100))) ? 2'b01 : temp_ctrl_aluB;                             //jr
    mux_4 aluInputB(.out(alu_inB), .select(ctrl_aluB), .in0(xm_data_A), .in1(data_writeReg), .in2(dx_data_B));

    // Stall = multdivstall || {(D/X.IR.OP == LOAD) && ((F/D.IR.RS1 == D/X.IR.RD) ||((F/D.IR.RS2 == D/X.IR.RD) && (F/D.IR.OP != STORE)))}
    wire stall;
    assign stall = ((x_opcode == 5'b01000) && ((rs == x_rd) || ((rt == x_rd) && (d_opcode == 5'b00111)))) ? 1'b1 : 1'b0;

    // run separate calculation for mult/div
    wire data_exception, data_ready, ctrl_MULT, ctrl_DIV, mult_happening, div_happening, multdiv_stall;
    wire [31:0] multdiv_out;
    wire multOp, divOp, startOp;
    assign multOp = (x_opcode == 5'b00000) && (aluOp == 5'b00110) && ~data_ready ? 1'b1 : 1'b0;
    assign divOp = (x_opcode == 5'b00000) && (aluOp == 5'b00111) && ~data_ready ? 1'b1 : 1'b0;
    assign multdiv_stall = ((multOp || divOp) && ~data_ready) ? 1'b1 : 1'b0;
    // modify enable bit so that ctrls stay high another cycle if bypass??
    assign ctrl_MULT = (multOp && ~mult_happening) ? 1'b1 : 1'b0;
    assign ctrl_DIV = (divOp && ~div_happening) ? 1'b1 : 1'b0;
    dffe_ref mult_pulse(.q(mult_happening), .d(multOp), .clk(clock), .en(1'b1), .clr(reset));
    dffe_ref div_pulse(.q(div_happening), .d(divOp), .clk(clock), .en(1'b1), .clr(reset));

    multdiv mymultdiv(.data_operandA(alu_inA), .data_operandB(intoALU_B), .ctrl_MULT(ctrl_MULT), .ctrl_DIV(ctrl_DIV),
                        .clock(clock), .data_result(multdiv_out), .data_exception(data_exception), .data_resultRDY(data_ready));

    // call our ALU
    wire isNotEqual, isLessThan, alu_ovf;
    alu myALU(.data_operandA(alu_inA), .data_operandB(intoALU_B), .ctrl_ALUopcode(aluOp), .ctrl_shiftamt(shamt),
                .data_result(alu_out), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(alu_ovf));

    // should we take our branch?
    wire bne_true, blt_true, take_branch;
    assign bne_true = isNotEqual && (x_opcode == 5'b00010);
    assign blt_true = ((x_opcode == 5'b00110) && isNotEqual && ~isLessThan) ? 1'b1 : 1'b0;
    assign take_branch = (bne_true || blt_true);
    // should we flush insns?
    assign flush = (jump_insn || take_branch || bex_insn) ? 1'b1 : 1'b0;
    // do we have an overflow / exception? set our new insn to be a setx instruction with proper error value
    // 1 if add, 2 if addi, 3 if sub, 4 if mult, 5 if div
    wire [31:0] overflow_insn, new_x_insn;
    wire [26:0] add_exc, addi_exc, sub_exc, mul_exc, exception_value;
    assign add_exc = ((aluOp == 5'b00000) && (x_opcode == 5'b00000)) ? 26'd1 : 26'd0;
    assign addi_exc = ((x_opcode == 5'b00101)) ? 26'd2 : add_exc;
    assign sub_exc = ((aluOp == 5'b00001) && (x_opcode == 5'b00000)) ? 26'd3 : addi_exc;
    assign mul_exc = ((aluOp == 5'b00110) && (x_opcode == 5'b00000)) ? 26'd4 : sub_exc;
    assign exception_value = ((aluOp == 5'b00111) && (x_opcode == 5'b00000)) ? 26'd5 : mul_exc;
    assign overflow_insn = {5'b10101, exception_value};
    // modify to incorporate mult/div exception
    assign new_x_insn = (alu_ovf || data_exception) ? overflow_insn : dx_insn;

    // pick between multdiv output and alu_out (if 00110 or 00101 --> multdiv)
    // this value gets passed into "A" of next latch
    wire [31:0] x_out;
    assign x_out = (aluOp == 5'b00111 || aluOp == 5'b00110 && data_ready) ? multdiv_out : alu_out;

    // ****************
    // *** xm latch ***
    wire [31:0] xm_data_A, xm_data_B, xm_insn, xm_pc;
    latch xm(.pc(dx_pc), .instruction(new_x_insn), .clk(~clock), .reset(reset), .en(~multdiv_stall), .data_A(x_out), .data_B(alu_inB),
                .pcOut(xm_pc), .insnOut(xm_insn), .data_A_out(xm_data_A), .data_B_out(xm_data_B));

    // ********************
    // ****** MEMORY ******
    // writing things to memory / loading from memory
    // if opcode = 00111 --> sw, mem[aluOut] = $rd value
    wire [4:0] m_opcode, m_rd;
    assign m_opcode = xm_insn[31:27];
    assign m_rd = xm_insn[26:22];

    // BYPASSING
    // if we have an aluOp/lw --> sw, where $rd of store is $rd of prev insn (X/M.RD == M/W.RD) && X/M.OP == store
    // if ^, then we should pick data = data_writeReg; else our xm_data_B
    wire ctrl_memB;
    assign ctrl_memB = ((m_opcode == 5'b00111) && (m_rd == w_rd) &&             //sw insn and rd matchees
                        (w_opcode == 5'b01000 || w_opcode == 5'b00000 || w_opcode == 5'b00101)) ? 1'b1 : 1'b0;
    assign data = ctrl_memB ? data_writeReg : xm_data_B;

    assign address_dmem = xm_data_A;
    // data is our value stored in rd (from decode stage), which is only written if we have a sw
    // assign data = xm_data_B;
    assign wren = (m_opcode == 5'b00111) ? 1'b1 : 1'b0;
    // now, q_dmem holds our data but its 32 bits, write our q_dmem to our register $rd in next stage

    // ********************
    // ***** mw latch *****
    wire [31:0] mw_data_A, mw_data_B, mw_insn, mw_pc;
    latch mw(.pc(xm_pc), .instruction(xm_insn), .clk(~clock), .reset(reset), .en(~multdiv_stall), .data_A(xm_data_A), .data_B(q_dmem),
                .pcOut(mw_pc), .insnOut(mw_insn), .data_A_out(mw_data_A), .data_B_out(mw_data_B));

    // *********************
    // ***** WRITEBACK *****
    // if necessary, write our resulting value to rd (insn[26:22])
    // we should WRITEBACK if lw ('01000'), r type ('00000'), or addi ('00101')
    wire [4:0] w_opcode, temp_writeReg, w_rd;
    assign w_opcode = mw_insn[31:27];
    assign w_rd = mw_insn[26:22];
    assign ctrl_writeEnable = (w_opcode == 5'b00000 || w_opcode == 5'b00101 || w_opcode == 5'b01000 || w_opcode == 5'b00011 || w_opcode == 5'b10101) ? 1'b1 : 1'b0;
    // if we jal, then we need to set to $r31
    // if setx, we need to set r_status to B
    assign temp_writeReg = (w_opcode == 5'b00011) ? 5'b11111 : mw_insn[26:22];
    // we should also write to rstatus if we have an exception, i.e. 
    assign ctrl_writeReg = (w_opcode == 5'b10101) ? 5'b11110 : temp_writeReg;
    // if we are jal, then data is pc + 1, else if lw then take our value from mem, else x_out
    wire [31:0] temp_reg_data, temp2_reg_data, mw_pc_plus1;
    wire writeback_ovf;
    cl_adder mw_next_pc(.data_A(mw_pc), .data_B(32'b0), .Cin(1'b1), .out(mw_pc_plus1), .overflow(writeback_ovf));
    assign temp_reg_data = (w_opcode == 5'b01000) ? mw_data_B : mw_data_A;
    assign temp2_reg_data = (w_opcode == 5'b10101) ? {5'b0, mw_insn[26:0]} : temp_reg_data;
    assign data_writeReg = (w_opcode == 5'b00011) ? mw_pc_plus1 : temp2_reg_data;

endmodule