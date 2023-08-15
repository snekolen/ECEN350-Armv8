module SignExtender(BusImm, Instr, Ctrl); 
   output reg [63:0] BusImm; 
   input [25:0]  Instr; 
   input [2:0] Ctrl; 
   
   always @(*) begin
	  case (Ctrl)
		  3'b000: begin
		     BusImm = {52'b0, Instr[21:10]}; //I type
		     end
		  3'b001: begin
		     BusImm = {{55{Instr[20]}}, Instr[20:12]}; //D type
		     end
		  3'b010: begin
		     BusImm = {{38{Instr[25]}}, Instr[25:0]}; //B type
		     end
		  3'b011: begin
		     BusImm = {{45{Instr[23]}}, Instr[23:5]}; //CB type
		     end
		  3'b100: begin
			case(Instr[22:21])
			   2'b00: BusImm = {48'b0, Instr[20:5]};
			   2'b01: BusImm = {32'b0, Instr[20:5], 16'b0};
			   2'b10: BusImm = {16'b0, Instr[20:5], 32'b0};
			   2'b11: BusImm = {Instr[20:5], 48'b0};
			endcase
		     end
	  endcase
   end
   
endmodule
