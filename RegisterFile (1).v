module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
    output [63:0] BusA;
    output [63:0] BusB;
    input [63:0] BusW;
    input [4:0] RW;
    input [4:0] RA;
    input [4:0] RB;
    input RegWr;
    input Clk;
    reg [63:0] registers [31:0]; //Size of 
     
    assign #2 BusA = registers[RA]; // registers[0]
    assign #2 BusB = registers[RB]; // registers[1]
    
    initial begin
        registers[31] = 0;
    end
     
    always @ (negedge Clk) begin
        if(RegWr & RW != 31) // 0 & 0
            registers[RW] <= #3 BusW; // registers[0] <= 0x0
    end
    
endmodule
