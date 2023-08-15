// For Testing: iverilog -o Test SingleCycleProcTest.v SingleCycleProc.v InstructionMemory.v DataMemory.v SignExtender.v ALU.v RegisterFile.v NextPClogic.v SingleCycleControl.v
module singlecycle(
		   input 	     resetl,
		   input [63:0]      startpc,
		   output reg [63:0] currentpc,
		   output [63:0]     MemtoRegOut,  // this should be
						   // attached to the
						   // output of the
						   // MemtoReg Mux
		   input 	     CLK
		   );

   // Next PC connections
   wire [63:0] 			     nextpc;       // The next PC, to be updated on clock cycle

   // Instruction Memory connections
   wire [31:0] 			     instruction;  // The current instruction

   // Parts of instruction
   wire [4:0] 			     rd;            // The destination register
   wire [4:0] 			     rm;            // Operand 1
   wire [4:0] 			     rn;            // Operand 2
   wire [10:0] 			     opcode;

   // Control wires
   wire 			     reg2loc;
   wire 			     alusrc;
   wire 			     mem2reg;
   wire 			     regwrite;
   wire 			     memread;
   wire 			     memwrite;
   wire 			     branch;
   wire 			     uncond_branch;
   wire [3:0] 			     aluctrl;
   wire [2:0] 			     signop;

   // Register file connections
   wire [63:0] 			     regoutA;     // Output A
   wire [63:0] 			     regoutB;     // Output B

   // ALU connections
   wire [63:0] 			     aluout;
   wire 			     zero;

   // Sign Extender connections
   wire [63:0] 			     extimm;

   // PC update logic
   always @(negedge CLK)
     begin
        if (resetl)
          currentpc <= #3 nextpc;
        else
          currentpc <= #3 startpc;
     end

   // Parts of instruction
   assign rd = instruction[4:0];
   assign rm = instruction[9:5];
   assign rn = reg2loc ? instruction[4:0] : instruction[20:16];
   assign opcode = instruction[31:21];

   InstructionMemory imem(
			  .Data(instruction),
			  .Address(currentpc)
			  );

   control control(
		   .Reg2Loc(reg2loc),
		   .ALUSrc(alusrc),
		   .Mem2Reg(mem2reg),
		   .RegWrite(regwrite),
		   .MemRead(memread),
		   .MemWrite(memwrite),
		   .Branch(branch),
		   .UncondBranch(uncond_branch),
		   .ALUOp(aluctrl),
		   .SignOp(signop),
		   .Opcode(opcode)
		   );

   /*
    * Connect the remaining datapath elements below.
    * Do not forget any additional multiplexers that may be required.
    */
    
    SignExtender SignExtender(
        .BusImm(extimm),
        .Instr(instruction[25:0]),
        .Ctrl(signop)
    );

    wire [63:0] ALUMUX; // output of ALU
    assign ALUMUX = alusrc ? extimm : regoutB; // sign extender output if alusrc is true

    ALU ALU(
        .BusW(aluout),
        .BusA(regoutA),
        .BusB(ALUMUX),
        .ALUCtrl(aluctrl),
        .Zero(zero)
    );
    
    RegisterFile RegisterFile(
        .BusA(regoutA),
        .BusB(regoutB),
        .BusW(dataMUX),
        .RA(rm),
        .RB(rn),
        .RW(rd),
        .RegWr(regwrite),
        .Clk(CLK)
    );

    wire [63:0] dataMUX;
    assign dataMUX = mem2reg ? MemtoRegOut : aluout;
    
    DataMemory DataMemory(
        .ReadData(MemtoRegOut),
        .Address(aluout),
        .WriteData(regoutB),
        .MemoryRead(memread),
        .MemoryWrite(memwrite),
        .Clock(CLK)
    );

    NextPClogic NextPClogic(
        .NextPC(nextpc),
        .CurrentPC(currentpc),
        .SignExtImm64(extimm),
        .Branch(branch),
        .ALUZero(zero),
        .Uncondbranch(uncond_branch)
    );


endmodule

