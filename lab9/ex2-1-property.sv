/*
 * Turning all checks on with check5
 */
`ifdef check5
`define check1 
`define check2 
`define check3 
`define check4
`endif 

module ex2_1_property 
  (
   input 	      clk, rst, validi,
   input [31:0]       data_in,
   input logic 	      valido, 
   input logic [31:0] data_out
   );

/*------------------------------------
 *
 *        CHECK # 1. Check that when 'rst' is asserted (==1) that data_out == 0
 *
 *------------------------------------ */

`ifdef check1
/* -----\/----- EXCLUDED -----\/-----

property reset_asserted;
   @(posedge clk) rst |=> data_out == 0;
endproperty

reset_check: assert property(reset_asserted)
  $display($stime,,,"\t\tRESET CHECK PASS:: rst_=%b data_out=%0d \n",
	   rst, data_out);
else $display($stime,,,"\t\RESET CHECK FAIL:: rst_=%b data_out=%0d \n",
	      rst, data_out);
 -----/\----- EXCLUDED -----/\-----  */
`endif

/* ------------------------------------
 * Check valido assertion to hold 
 *
 *       CHECK # 2. Check that valido is asserted when validi=1 for three
 *                  consecutive clk cycles
 * 
 * ------------------------------------ */

`ifdef check2
property validi_to_valido;
   @(posedge clk) disable iff (rst) validi [*3] |=> valido;
endproperty

validi_to_valido_check: assert property(validi_to_valido)
   $display($stime,,,"\t\tCHECK 2 PASS (valido follows three high cycles on validi)\n");
else $display($stime,,,"\t\tCHECK 2 FAIL (valido does not follow three high cycles on validi)\n");

`endif

/* ------------------------------------
 * Check valido not asserted wrong 
 *
 *       CHECK # 3. Check that valido is not asserted when validi=1 for only two, one
 *                  or zero consecutive clk cycles
 * 
 * ------------------------------------ */

`ifdef check3
property valido_no_glitch;
   @(posedge clk) disable iff (rst) valido |-> $past(validi, 1) && $past(validi, 2) && $past(validi, 3);
endproperty

valido_no_glich_check: assert property(valido_no_glitch)
else $display($stime,,,"\t\tCHECK 3 FAIL (valido was asserted whithout three high cycles on validi)\n");

`endif

/* ------------------------------------
 * Check data_out value 
 *
 *       CHECK # 4. Check that data_out when valido=1 is equal to a*b+c where a is data_in
 *       two cycles back, b is data_in one cycle back, and c is the present data_in
 * 
 * ------------------------------------ */

`ifdef check4
property data_out_correct;
   @(posedge clk) disable iff (rst) valido |-> 
      data_out == $past(data_in, 4) * $past(data_in, 3) + $past(data_in, 2);
endproperty

data_out_correct_check: assert property(data_out_correct)
   $display($stime,,,"\t\tCHECK 4 PASS (correct computation result)\n");
else $display($stime,,,"\t\tCHECK 4 FAIL (wrong computation result)\n");

`endif

endmodule
