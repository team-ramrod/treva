#
# A small hello world
#
# write Leros to the UART
#

	nop	# first instruction is not executed


start:
	load 76
	store r0
	load <send
	nop
	jal r1
  nop

	load 101
	store r0
	load <send
	nop
	jal r1
  nop

	load 114
	store r0
	load <send
	nop
	jal r1
  nop

	load 111
	store r0
	load <send
	nop
	jal r1
  nop

	load 115
	store r0
	load <send
	nop
	jal r1
  nop

	load 13
	store r0
	load <send
	nop
	jal r1
  nop

	load 10
	store r0
	load <send
	nop
	jal r1
  nop

end:
	branch start

send:
	in 0 3	# check tdre
	and 1
	nop	# one delay slot
	brz send
  nop
	load r0
	out 0 4
	out 0 1 # Also output on leds
	load r1	# that's return
	nop
	jal r1	# here r1 is just dummy
  nop
