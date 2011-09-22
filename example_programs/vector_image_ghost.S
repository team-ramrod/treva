# Loads two images from memory assuming the images are 32x32x24bit stored at
# addresses 0x1000--0x1BFF and 0x2000--0x2BFF respectively.  The colour value
# of each pixel in the images will be halved and added together to effectively
# `ghost` the two images together.  The result will be placed at
# 0x3000--0x3BFF.

# Adapted to use 64-bit vector operations

# Store the first image reference in a0
  LDI   r0    0x10
  MV    a0H   r0
  LDI   r0    0x00
  MV    a0L   r0

# Store the second image reference in a1
  LDI   r0    0x20
  MV    a1H   r0
  LDI   r0    0x00
  MV    a1L   r0

# Store the output image reference in a2
  LDI   r0    0x30
  MV    r0    a2H
  LDI   r0    0x00
  MV    r0    a2L

# for (int i = 0xC00; i > 0; i = i - 64) {
#     output[i:i+63] = (first[i:i+63] >> 1) + (second[i:i+63] >> 1);
# }

# int i = 0xC00;
  LDI   r0    0x00
  LDI   r1    0x0C

# load 0, 1 and 64 for later operations
  LDI   r2    0x00
  MV    r3    r2
  LDI   r2    0x01
  MV    r4    r2
  LDI   r2    0x40

# i > 0
label: loop_test
  MV    r5    r0
  ADDU  r5    r1
  BC    loop_start
  BEQ   loop_exit

# output[i:i+63] = (first[i:i+63] >> 1) + (second[i:i+63] >> 1);
label: loop_start
  LDV   v0    a0+
  RSHV  v0    r4
  LDV   v1    a1+
  RSHV  v1    r4
  ADDV  v0    v1
  STV   a2+   v0

# i--
label: loop_end
  SUBU  r0    r2
  SBBU  r1    r3
  RJMP  loop_test

label: loop_exit
  HALT
