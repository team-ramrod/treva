// first instruction is not executed
    nop

start:
    load    0
    loadh   0
    store   r1

loop:
    loadh   2
    store   r0

ll1:
    loadh   255

ll2:
    sub     1
    brnz    ll2
    load    255

    load    r0
    sub     1
    store   r0

    brnz    ll1
    load    255

    load    r1
    add     1
    out     0
    store   r1

    branch  loop
    load    0
