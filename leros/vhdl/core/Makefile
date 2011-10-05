leros_ex_tb: leros_ex_tb.vhd
	ghdl -a leros_ex_tb.vhd
	ghdl -e leros_ex_tb
	ghdl -r leros_ex_tb

wave: 
	ghdl -r leros_ex_tb --vcd=leros_ex_tb.vcd
	gtkwave leros_ex_tb.vcd
