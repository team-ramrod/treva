  nop

start:
  load  1
  loadh 0
  out   0 1
  load  2
  loadh 0
  nop
  out   0 1
  load  4
  loadh 0
  nop
  nop
  out   0 1

  load 1
  nop
  brnz start

