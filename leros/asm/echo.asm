//
// Just echo characters received from the UART
//

	nop	// first instruction is not executed


start:
	in 0 3	// check rdrf
	and 2
	nop	// one delay slot
	brz start
	in 0 4	// read received character
	store r0
loop:
	in 0 3	// check tdre
	and 1
	nop	// one delay slot
	brz loop
	load r0
	out 0 4
	branch start
