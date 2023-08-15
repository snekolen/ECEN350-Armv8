`define OPCODE_ANDREG 11'b?0001010???
`define OPCODE_ORRREG 11'b?0101010???
`define OPCODE_ADDREG 11'b?0?01011???
`define OPCODE_SUBREG 11'b?1?01011???

`define OPCODE_ADDIMM 11'b?0?10001???
`define OPCODE_SUBIMM 11'b?1?10001???

`define OPCODE_MOVZ   11'b110100101??

`define OPCODE_B      11'b?00101?????
`define OPCODE_CBZ    11'b?011010????

`define OPCODE_LDUR   11'b??111000010
`define OPCODE_STUR   11'b??111000000

module control( // Control wires
    output reg Reg2Loc,
    output reg ALUSrc,
    output reg Mem2Reg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg UncondBranch,
    output reg [3:0] ALUOp,
    output reg [2:0] SignOp,
    input [10:0] Opcode
);

always @(*)
begin
    casez (Opcode)
        /* Add cases here for each instruction your processor supports */
        `OPCODE_ANDREG:
        begin
            Reg2Loc       <= 1'b0;
            UncondBranch <= 1'b0;
            Branch        <= 1'b0;
            MemRead       <= 1'b0;
            Mem2Reg       <= 1'b0;
            MemWrite      <= 1'b0;
            ALUSrc        <= 1'b0;
            RegWrite      <= 1'b1;
            ALUOp         <= 4'b0000;
            SignOp        <= 3'bxxx;
        end

        `OPCODE_ORRREG:
        begin
            Reg2Loc       <= 1'b0;
            UncondBranch <= 1'b0;
            Branch        <= 1'b0;
            MemRead       <= 1'b0;
            Mem2Reg       <= 1'b0;
            MemWrite      <= 1'b0;
            ALUSrc        <= 1'b0;
            RegWrite      <= 1'b1;
            ALUOp         <= 4'b0001;
            SignOp        <= 3'bxxx;
        end

        `OPCODE_ADDREG:
        begin
            Reg2Loc       <= 1'b0;
            UncondBranch <= 1'b0;
            Branch        <= 1'b0;
            MemRead       <= 1'b0;
            Mem2Reg       <= 1'b0;
            MemWrite      <= 1'b0;
            ALUSrc        <= 1'b0;
            RegWrite      <= 1'b1;
            ALUOp         <= 4'b0010;
            SignOp        <= 3'bxxx;
        end

        `OPCODE_SUBREG:
        begin
            Reg2Loc       <= 1'b0;
            UncondBranch <= 1'b0;
            Branch        <= 1'b0;
            MemRead       <= 1'b0;
            Mem2Reg       <= 1'b0;
            MemWrite      <= 1'b0;
            ALUSrc        <= 1'b0;
            RegWrite      <= 1'b1;
            ALUOp         <= 4'b0110;
            SignOp        <= 3'bxxx;
        end

        `OPCODE_ADDIMM:
        begin
            Reg2Loc       <= 1'bx;
            UncondBranch <= 1'b0;
            Branch        <= 1'b0;
            MemRead       <= 1'b0;
            Mem2Reg       <= 1'b0;
            MemWrite      <= 1'b0;
            ALUSrc        <= 1'b1;
            RegWrite      <= 1'b1;
            ALUOp         <= 4'b0010;
            SignOp        <= 3'b000;
        end

        `OPCODE_SUBIMM:
        begin
            Reg2Loc       <= 1'bx;
            UncondBranch <= 1'b0;
            Branch        <= 1'b0;
            MemRead       <= 1'b0;
            Mem2Reg       <= 1'b0;
            MemWrite      <= 1'b0;
            ALUSrc        <= 1'b1;
            RegWrite      <= 1'b1;
            ALUOp         <= 4'b0110;
            SignOp        <= 3'b000;
        end

        `OPCODE_B:
        begin
            Reg2Loc       <= 1'bx;
            UncondBranch <= 1'b1;
            Branch        <= 1'bx;
            MemRead       <= 1'b0;
            Mem2Reg       <= 1'bx;
            MemWrite      <= 1'b0;
            ALUSrc        <= 1'bx;
            RegWrite      <= 1'b0;
            ALUOp         <= 4'bxxxx;
            SignOp        <= 3'b010;
        end

        `OPCODE_CBZ:
        begin
            Reg2Loc       <= 1'b1;
            UncondBranch <= 1'b0;
            Branch        <= 1'b1;
            MemRead       <= 1'b0;
            Mem2Reg       <= 1'bx;
            MemWrite      <= 1'b0;
            ALUSrc        <= 1'b0;
            RegWrite      <= 1'b0;
            ALUOp         <= 4'b0111;
            SignOp        <= 3'b011;
        end

        `OPCODE_LDUR:
        begin
            Reg2Loc       <= 1'bx;
            UncondBranch <= 1'b0;
            Branch        <= 1'b0;
            MemRead       <= 1'b1;
            Mem2Reg       <= 1'b1;
            MemWrite      <= 1'b0;
            ALUSrc        <= 1'b1;
            RegWrite      <= 1'b1;
            ALUOp         <= 4'b0010;
            SignOp        <= 3'b001;
        end

        `OPCODE_STUR:
        begin
            Reg2Loc       <= 1'b1;
            UncondBranch <= 1'b0;
            Branch        <= 1'b0;
            MemRead       <= 1'b0;
            Mem2Reg       <= 1'bX;
            MemWrite      <= 1'b1;
            ALUSrc        <= 1'b1;
            RegWrite      <= 1'b0;
            ALUOp         <= 4'b0010;
            SignOp        <= 3'b001;
        end
        
        `OPCODE_MOVZ:   
        begin 
            Reg2Loc       <= 1'b1;
            UncondBranch <= 1'b0;
            Branch        <= 1'b0;
            MemRead       <= 1'b0;
            Mem2Reg       <= 1'b0;
            MemWrite      <= 1'b0;
            ALUSrc        <= 1'b1;
            RegWrite      <= 1'b1;
            ALUOp         <= 4'b0111;
            SignOp        <= 3'b100;
        end
        
        default:
        begin
            Reg2Loc       <= 1'bx;
            ALUSrc        <= 1'bx;
            Mem2Reg       <= 1'bx;
            RegWrite      <= 1'b0;
            MemRead       <= 1'b0;
            MemWrite      <= 1'b0;
            Branch        <= 1'b0;
            UncondBranch <= 1'b0;
            ALUOp         <= 4'bxxxx;
            SignOp        <= 3'bxxx;
        end
    endcase
end

endmodule
