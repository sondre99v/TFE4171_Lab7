timeunit 10ns; 
`include "alu_packet.sv"
//`include "alu_assertions.sv"

module alu_tb();

reg clk = 0;
bit [0:7] a = 8'h0;
bit [0:7] b = 8'h0;
bit [0:2] op = 3'h0;
wire [0:7] r;


parameter NUMBERS = 10000;

alu_data test_data[NUMBERS];

initial
data_gen: begin
    #20;
    for (int i = 0; i < NUMBERS; i++) begin
        test_data[i] = new;
        test_data[i].randomize();
        test_data[i].get(alu_tb.a, alu_tb.b, alu_tb.op);
        #20;
    end
end



//Displaying signals on the screen
always @(posedge clk) 
  $display($stime,,,"clk=%b a=%b b=%b op=%b r=%b",clk,a,b,op,r);

//Clock generation
always #10 clk=~clk;

//Declaration of the VHDL alu
alu dut (clk,a,b,op,r);


enum {ADD, SUB, MULT, NOT, NAND, NOR, AND, OR} opcode;



covergroup alu_cg @(posedge clk);

    opc: coverpoint op
    {
        bins valid_states[] = {ADD, SUB, MULT, NOT, NAND, NOR, AND, OR};
    }

    ac: coverpoint a
    {
        bins bin_zero = {0};
        bins bin_small = {[1:50]};
        bins bin_hunds[3] = {100, 200, 100, 200};
        bins bin_large = {[200:$]};
        bins bin_others = default;
    }

    bc: coverpoint b
    {
        bins bin_zero = {0};
        bins bin_small = {[1:50]};
        bins bin_hunds[3] = {100, 200, 100, 200};
        bins bin_large = {[200:$]};
        bins bin_others = default;
    }

    abc: cross ac, bc;

endgroup




//Initialize your covergroup here
alu_cg alu_cg_Inst = new();

//Sample covergroup here
always @(posedge clk) alu_cg_Inst.sample();

endmodule:alu_tb
