// /**
//  * READ THIS DESCRIPTION!
//  *
//  * This is your processor module that will contain the bulk of your code submission. You are to implement
//  * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
//  * necessary.
//  *
//  * Ultimately, your processor will be tested by a master skeleton, so the
//  * testbench can see which controls signal you active when. Therefore, there needs to be a way to
//  * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
//  * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
//  * for more details.
//  *
//  * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
//  * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
//  * in your Wrapper module. This is the same for your memory elements. 
//  *
//  *
//  */
// module mem_processor(
//     // Control signals
//     clock,                          // I: The master clock
//     reset,                          // I: A reset signal

//     // Imem
//     address_imem,                   // O: The address of the data to get from imem
//     q_imem,                         // I: The data from imem

//     // Dmem
//     address_dmem,                   // O: The address of the data to get or put from/to dmem
//     data,                           // O: The data to write to dmem
//     wren,                           // O: Write enable for dmem
//     q_dmem,                         // I: The data from dmem

//     // Regfile
//     ctrl_writeEnable,               // O: Write enable for RegFile
//     ctrl_writeReg,                  // O: Register to write to in RegFile
//     ctrl_readRegA,                  // O: Register to read from port A of RegFile
//     ctrl_readRegB,                  // O: Register to read from port B of RegFile
//     data_writeReg,                  // O: Data to write to for RegFile
//     data_readRegA,                  // I: Data from port A of RegFile
//     data_readRegB                   // I: Data from port B of RegFile
	 
// 	);

// 	// Control signals
// 	input clock, reset;
	
// 	// Imem
//     output [31:0] address_imem;
// 	input [31:0] q_imem;

// 	// Dmem
// 	output [31:0] address_dmem, data;
// 	output wren;
// 	input [31:0] q_dmem;

// 	// Regfile
// 	output ctrl_writeEnable;
// 	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
// 	output [31:0] data_writeReg;
// 	input [31:0] data_readRegA, data_readRegB;

// 	/* YOUR CODE STARTS HERE */
//     // temporary
//     wire flush;
//     assign flush = 1'b0;

//     // ******* FETCH *******
//     wire [31:0] pc_in, pc_out;
//     wire pc_ovf;
//     // assign pc_out = jumpPC ? target : pc_out;
//     cl_adder next_pc(.data_A(pc_out), .data_B(32'b0), .Cin(1'b1), .out(pc_in), .overflow(pc_ovf));
//     register pc_reg(.readOut(pc_out), .clk(~clock), .in_enable(1'b1), .writeIn(pc_in), .clear(reset));

//     assign address_imem = pc_out;
//     // now, q_imem is our instruction

//     // if we need to flush our insn, pass in all 0's
//     wire [31:0] new_q_imem;
//     // assign new_q_imem = flush ? 32'b0 : q_imem;
//     assign new_q_imem = q_imem;

//     // F/D Latch
//     wire [31:0] fd_data_A, fd_data_B, fd_insn, fd_pc;
//     latch fd(.pc(address_imem), .instruction(new_q_imem), .clk(~clock), .reset(reset), .data_A(32'b0), .data_B(32'b0),
//                 .pcOut(fd_pc), .insnOut(fd_insn), .data_A_out(fd_data_A), .data_B_out(fd_data_B));

//     // ******* DECODE *******
//     // r type wires
//     wire [5:0] rs, rt, rd;
//     wire [4:0] d_opcode;
//     assign d_opcode = fd_insn[31:27];
//     assign rs = fd_insn[21:17];
//     assign rt = fd_insn[16:12];
//     assign rd = fd_insn[26:22];
//     // do we jump?
//     wire [31:0] target;
//     wire jump_pc;
//     assign target = {5'b0, fd_insn[26:0]};
//     assign jump_pc = (d_opcode == 5'b00001 || d_opcode == 00011) ? 1'b1 : 1'b0;
    
//     // get values from register — if we have an I type insn, then our A, B are the same???
//     assign ctrl_readRegA = rs;
//     // regB should either be rt (r-type), or rd (if I, JI, or JII) to sw, 
//     assign ctrl_readRegB = (d_opcode == 5'b00000) ? rt : rd;
//     // now, data_readRegA/B automatically stores values
//     // flush out an insn if we need to
//     wire [31:0] new_fd_insn;
//     // assign new_fd_insn = flush ? 32'b0 : fd_insn;
//     assign new_fd_insn = fd_insn;

//     // D/X Latch
//     wire [31:0] dx_data_A, dx_data_B, dx_insn, dx_pc;
//     latch dx(.pc(fd_pc), .instruction(new_fd_insn), .clk(~clock), .reset(reset), .data_A(data_readRegA), .data_B(data_readRegB),
//                 .pcOut(dx_pc), .insnOut(dx_insn), .data_A_out(dx_data_A), .data_B_out(dx_data_B));

//     // ****** EXECUTE *******
//     // opcode
//     wire [4:0] opcode;
//     assign opcode = dx_insn[31:27];
//     // r type wires
//     wire [4:0] shamt, r_type_aluOp, aluOp;
//     // i type wires
//     wire [16:0] immed;
//     wire [31:0] extendedImmed;
//     // assign values from instructions
//     assign shamt = dx_insn[11:7];
//     assign r_type_aluOp = dx_insn[6:2];
//     assign immed = dx_insn[16:0];
//     sign_extend extendImmed(.data(immed), .out(extendedImmed));
//     // pick between (sign-extended) immediate and B for second ALU input
//     wire useImmed;
//     wire [31:0] intoALU_B, alu_out, multdiv_out;
//     assign useImmed = (opcode == 5'b00000) ? 1'b0 : 1'b1;
//     assign intoALU_B = useImmed ? extendedImmed : dx_data_B;
//     assign aluOp = useImmed ? 5'b00000 : r_type_aluOp;
//     // run separate calculation for mult/div
//     // if it is a mult/div op, we need to delay until it is complete
//     // if mult/div AND not data_resultRDY --> delay is true
//     // our opcode can be our ctrl_MULT/ctrl_DIV
//     // multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
//     // if aluOp is 00110 (mult) or 00101 (div)
//     // multdiv mymultdiv(.data_operandA(dx_data_A), .data_operandB(intoALU_B), .ctrl_MULT(), .ctrl_DIV(),
//     //                     .clock(), .data_result(), .data_exception(), .data_resultRDY());

//     //TODO
//     // branching
//     // if we end up branching (alu comparison), flush out D, E stage instructions, and set PC to proper val
//     // jumping
//     // set next PC to proper value, and flush - link $31 if JAL
//     // wire flush;
//     // assign flush = 1'b0;

//     // call our ALU
//     wire isNotEqual, isLessThan, alu_ovf;
//     alu myALU(.data_operandA(dx_data_A), .data_operandB(intoALU_B), .ctrl_ALUopcode(aluOp), .ctrl_shiftamt(shamt),
//                 .data_result(alu_out), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(alu_ovf));
//     // pick between multdiv output and alu_out (if 00110 or 00101 --> multdiv)
//     // this value gets passed into "A" of next latch
//     wire [31:0] x_out;
//     // assign x_out = (aluOp == 5'b00101 || aluOp == 5'b00110) ? multdiv_out : alu_out;
//     assign x_out = alu_out;

//     // ****************
//     // *** xm latch ***
//     wire [31:0] xm_data_A, xm_data_B, xm_insn, xm_pc;
//     latch xm(.pc(dx_pc), .instruction(dx_insn), .clk(~clock), .reset(reset), .data_A(x_out), .data_B(dx_data_B),
//                 .pcOut(xm_pc), .insnOut(xm_insn), .data_A_out(xm_data_A), .data_B_out(xm_data_B));

//     // ********************
//     // ****** MEMORY ******
//     // writing things to memory / loading from memory
//     // if opcode = 00111 --> sw, mem[aluOut] = $rd value
//     wire [4:0] m_opcode, m_rd;
//     assign m_opcode = xm_insn[31:27];
//     assign m_rd = xm_insn[26:22];
//     assign address_dmem = xm_data_A;
//     // data is our value stored in rd (from decode stage), which is only written if we have a sw
//     assign data = xm_data_B;
//     assign wren = (m_opcode == 5'b00111) ? 1'b1 : 1'b0;
//     // if opcode = 01000 --> lw, $rd = mem[aluOut]
//     // now, q_dmem holds our data but its 32 bits, write our q_dmem to our register $rd in next stage

//     // ********************
//     // ***** mw latch *****
//     wire [31:0] mw_data_A, mw_data_B, mw_insn, mw_pc;
//     latch mw(.pc(xm_pc), .instruction(xm_insn), .clk(~clock), .reset(reset), .data_A(xm_data_A), .data_B(q_dmem),
//                 .pcOut(mw_pc), .insnOut(mw_insn), .data_A_out(mw_data_A), .data_B_out(mw_data_B));

//     // *********************
//     // ***** WRITEBACK *****
//     // if necessary, write our resulting value to rd (insn[26:22])
//     // we should WRITEBACK if lw ('01000'), r type ('00000'), or addi ('00101')
//     wire [4:0] w_opcode;
//     assign w_opcode = mw_insn[31:27];
//     assign ctrl_writeEnable = (w_opcode == 5'b00000 || w_opcode == 5'b00101 || w_opcode == 5'b01000) ? 1'b1 : 1'b0;
//     assign ctrl_writeReg = mw_insn[26:22];
//     assign data_writeReg = (w_opcode == 5'b01000) ? mw_data_B : mw_data_A;

// 	/* END CODE */
//     // OFF BY LIKE 2 CLOCK CYCLES??? r18 is getting 3

// endmodule
