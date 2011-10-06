// first instruction is not executed
    nop

start:
    load    0
    loadh   0
    store   r1

loop:
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

    in      0   2
    add     r1
    out     0   1
    store   r1

    nop
    branch  loop
