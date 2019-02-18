rm -rf work
vlib work
vlog +cover=bcefsx -sv test-ex2-1.sv ex2-1.v ex2-1-property.sv
vcom alu.vhd 
vsim -c -coverage test_ex2_1 -do "run 330ns; coverage report -memory -cvg -details -file coverage_rep.txt;exit"
