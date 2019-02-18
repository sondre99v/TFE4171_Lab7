/*
 * ex2_1
 * 
 * Purpose:
 * - Reset on rst=1
 * - When validi=1 three clk's in a row, compute data_out=a*b+c
 *   where a is data_in on the first clk, b on the second and c
 *   on the third. Also set valido=1. Else valido=0 which means
 *   data_out is not valid.
 */

module ex2_1 (
	      input 		  clk, rst, validi,
	      input [31:0] 	  data_in,
	      output logic 	  valido, 
	      output logic [31:0] data_out,
              output logic [31:0] alu1_a,
              output logic [31:0] alu1_b,
              output logic [2:0] alu1_op,
              input logic [31:0] alu1_r,
              output logic [31:0] alu2_a,
              output logic [31:0] alu2_b,
              output logic [2:0] alu2_op,
              input logic [31:0] alu2_r
	      );
   
   enum 			  {S0, S1, S2} state = S0, next = S0;
   
   logic [31:0] 		  a;
   logic [31:0]                   b;

   always @* begin
     alu1_a = a;
     alu1_b = b;
     alu1_op = 3'b010;
     alu2_a = alu1_r;
     alu2_b = data_in;
     alu2_op = 3'b000;
   end

   always_ff @(posedge clk or posedge rst) begin
      if (rst) begin
	 data_out <= 32'b0;
	 valido <= 1'b0;
	 state = S0;
      end
   
      else begin
         a <= b;
         b <= data_in;
   
	 case (state)
	   // S0
	   S0: begin
	      valido <= 1'b0;
	      if (validi) begin
		 next = S1;
	      end
	   end

	   // S1
	   S1: begin
	      if (validi) begin
		 next = S2;
	      end
	      else begin
		next = S0;
              end
	   end

	   // S2
	   S2: begin
	      if (validi) begin
		 //data_out <= a * b + data_in;
		 data_out <= alu2_r;
		 valido <= 1'b1;
                 next = S2;
	      end
              else begin
                next = S0;
                valido <= 1'b0;
              end
	   end
	       
	 endcase
	 state = next;
	 
      end
   end
endmodule
