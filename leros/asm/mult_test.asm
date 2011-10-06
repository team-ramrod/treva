# 
nop

start:
  load    1
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

    load    r1
    out     0     1
    mult    3
    store   r1
    sub     258
    brnz     loop
    load    1
    nop
    brnz    start
