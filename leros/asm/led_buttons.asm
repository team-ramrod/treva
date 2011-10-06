    nop

start:

    in 0 1
    nop
    nop
    nop
    out 0 1

    nop
    load 1
    nop
    brnz start

#    load 0
#    loadh 0
#
#    in 0 1
#    store r2
#
#    in 0 2
#    store r0
#    load 0
#    loadh 0
#    store r1
#
#loop:
#
#    load r1
#    add 0xF
#    store r1
#    load r0
#    sub 1
#    store r0
#    nop
#    brnz loop
#
#    add r2
#    out 0 1
#
#    nop
#    branch start
