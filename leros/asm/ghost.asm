    nop

# read in width
# r2 = width
    load <read
    loadh >read
    nop
    jal r1
    load r0
    store r2

# read in height
# r3 = height
    load <read
    loadh >read
    nop
    jal r1
    load r0
    store r3

# r4 = total bytes
    #mult r2
    store r4

# read in bytes


# read in width
# read in height

# read in bytes

# calculate

# write out width
# write out height

# write out bytes

# Reads byte from uart then places it into r0 and jumps to r1
read:
  # Check rdrf
  in 2 # uart control
  and 2
  nop
  brz read

  in 3 # uart data
  store r0
  load r1
  nop

  jal r1
