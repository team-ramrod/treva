# Loads two images from memory assuming the images are 32x32x24bit stored at
# addresses 0x1000--0x1BFF and 0x2000--0x2BFF respectively.  The colour value
# of each pixel in the images will be halved and added together to effectively
# `ghost` the two images together.  The result will be placed at
# 0x3000--0x3BFF.

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

# for (int i = 0xC00; i > 0; i--) {
#     output[i] = (first[i] >> 1) + (second[i] >> 1);
# }

# int i = 0xC00;
  LDI   r0    0x00
  LDI   r1    0x0C

# load 0 and 1 for later operations
  LDI   r2    0x00
  MV    r3    r2
  LDI   r2    0x01

# i > 0
label: loop_test
  MV    r4    r0
  ADDU  r4    r1
  BC    loop_start
  BEQ   loop_exit

# output[i] = (first[i] >> 1) + (second[i] >> 1);
label: loop_start
  LD    r5    a0+
  RSH   r5    r2
  LD    r6    a1+
  RSH   r6    r2
  ADDU  r5    r6
  ST    a2+   r5

# i--
label: loop_end
  SUBU  r0    r2
  SBBU  r1    r3
  RJMP  loop_test

label: loop_exit
  HALT
