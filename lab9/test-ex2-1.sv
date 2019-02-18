module test_ex2_1;

   logic clk, rst, validi;
   
   logic [31:0] data_in;
   wire 	valido;
   wire [31:0]  data_out;
   
   wire [31:0] alu1_a;
   wire [31:0] alu1_b;
   wire [2:0] alu1_op;
   wire [31:0] alu1_r;

   wire [31:0] alu2_a;
   wire [31:0] alu2_b;
   wire [2:0] alu2_op;
   wire [31:0] alu2_r;


   enum {ADD, SUB, MULT, NOT, NAND, NOR, AND, OR} opcode;

   covergroup alu_cg @(posedge clk);

      opc: coverpoint alu2_op
      {
         bins valid_states[] = {ADD, SUB, MULT, NOT, NAND, NOR, AND, OR};
      }
 
      ac: coverpoint alu2_a
      {
         bins bin_zero = {0};
         bins bin_small = {[1:50]};
         bins bin_hund[3] = {100, 200, 100, 200};
         bins bin_large = {[200:$]};
         bins bin_others = default;
      }

      bc: coverpoint alu2_b
      {
         bins bin_zero = {0};
         bins bin_small = {[1:50]};
         bins bin_hund[3] = {100, 200, 100, 200};
         bins bin_large = {[200:$]};
         bins bin_others = default;
      }

      // abc: cross ac, bc;
   endgroup

   
   alu_cg alu_cg_Inst = new();
   always @(posedge clk) alu_cg_Inst.sample();


   ex2_1 dut 
     (
      clk, rst, validi,
      data_in,
      valido,
      data_out,
      alu1_a, alu1_b, alu1_op, alu1_r,
      alu2_a, alu2_b, alu2_op, alu2_r
      );
   
   alu alu1 (  alu1_a, alu1_b, alu1_op, alu1_r);
   alu alu2 (  alu2_a, alu2_b, alu2_op, alu2_r);

   bind ex2_1 ex2_1_property ex2_1_bind 
     (
      clk, rst, validi,
      data_in,
      valido,
      data_out
      );

   initial begin
      clk=1'b0;
      set_stim;
      @(posedge clk); $finish(2);
   end

   always @(posedge clk) 
     $display($stime,,,"rst=%b clk=%b validi=%b DIN=%0d valido=%b DOUT=%0d",
	      rst, clk, validi, data_in, valido, data_out);
   
   always #5 clk=!clk;

   task set_stim;
      rst=1'b0; validi=0'b1; data_in=32'b1;
      @(negedge clk) rst=1;
      @(negedge clk) rst=0;
      
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
 
      @(negedge clk);
   endtask

endmodule
