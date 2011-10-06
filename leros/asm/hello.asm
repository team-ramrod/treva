//
// A small hello world
//
// write Leros to the UART
//

	nop	// first instruction is not executed


start:
	load 76
	store r0
  load <pause
  nop
  jal r1
  nop
	load <send
	nop
	jal r1
  nop

	load 101
	store r0
  load <pause
  nop
  jal r1
  nop
	load <send
	nop
	jal r1
  nop

	load 114
	store r0
  load <pause
  nop
  jal r1
  nop
	load <send
	nop
	jal r1
  nop

	load 111
	store r0
  load <pause
  nop
  jal r1
  nop
	load <send
	nop
	jal r1
  nop

	load 115
	store r0
  load <pause
  nop
  jal r1
  nop
	load <send
	nop
	jal r1
  nop

	load 13
	store r0
  load <pause
  nop
  jal r1
  nop
	load <send
	nop
	jal r1
  nop

	load 10
	store r0
  load <pause
  nop
  jal r1
  nop
	load <send
	nop
	jal r1
  nop

end:
	branch start

send:
	load r0
  nop
	out 0 4
	out 0 1 // Also output on leds
	load r1	// that's return
	nop
	jal r1	// here r1 is just dummy
  nop

pause:
    load    128
    loadh     0
    store   r0

ll1:
    load    255
    loadh   255

ll2:
    sub     1
    nop
    brnz    ll2
    nop

    load    r0
    sub     1
    store   r0

    brnz    ll1
    nop

    load r1
    nop
    jal r1
    nop
