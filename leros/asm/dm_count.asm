// first instruction is not executed
    nop

start:
    load      5
    store     r1
    load      0
    loadh     0
    store     r1  +8

loop:
    load      128
    loadh     0
    store     r0

ll1:
    load      255
    loadh     255

ll2:
    sub       1
    nop
    brnz      ll2
    nop

    load      r0
    sub       1
    store     r0

    brnz      ll1
    nop

    load      r1    +8
    add       1
    store     r1    +8
    out       0     0

    load      1
    nop
    brnz      loop
