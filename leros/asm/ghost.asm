    nop

# Setting up the address register for storing image data to ram
# i = 0
    load  0
    loadh 0
    store r5

# images_loaded = 0
    load 0
    loadh 0
    store r6

# read in width
# r2 = width
read_image:
    load <read
    loadh >read
    nop
    jal r1
    nop
    load r0
    store r2

# read in height
# r3 = height
    load <read
    loadh >read
    nop
    jal r1
    nop
    load r0
    store r3

# r4 = total bytes
# temp = width*height
    mult r2
# size = temp
    load r7


# read in bytes
tits:
# count = temp
    store r4

# byte = uart_read()
    load <read
    loadh >read
    nop
    jal r1
    nop

# ram[i+20] = byte
    load r0
    store r5 +20

# i++
    add 1
    store r5

# temp = count -1
    load r4
    sub 1
    nop
# if(temp != 0) goto tits;
    brnz tits

#if (++images_loaded == 2) goto ghost
    load r6
    add 1
    store r6
    sub 2
    nop
    brz ghost
    nop

# goto read_image
    nop
    load <read_image
    loadh >read_image
    nop
    jal r1
    nop

# i = 0;
    load 0
    loadh 0
    store r5
ghost:
    load r5 +20
    store r8        # r8 is image1 pixel
    load r5
    add r7          # r7 is image size
    store r10       # r10 is address of image2 pixel
    load r10 +20
    add r8          # image2 px + image1 px
    shr             # Divide by 2
    store r9        # result = (im2 + im1)/2
    load r5         # address = i
    add r7          # address += size
    add r7          # address += size
    store r11
    store r11 +20   # store result into address
    load r5
    add 1
    store r5
    load r5
    sub 1
    sub r7
    nop
    brnz ghost      # if (++i == size) goto ghost
    nop


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
