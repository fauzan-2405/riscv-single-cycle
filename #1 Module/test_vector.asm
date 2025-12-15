    ADDI x1, x0, 1      # i = 1
    ADDI x2, x0, 0      # sum = 0
    ADDI x3, x0, 11     # stop when i == 11

loop:
    BLT x1, x3, body    # if i < 11, run body, else exit
    ADDI x0, x0, 0      # exit (NOP)
    # nothing else needed here

body:
    ADD  x2, x2, x1     # sum += i
    ADDI x1, x1, 1      # i++
    BLT  x1, x3, loop   # loop again if i < 11

exit:
    ADDI x0, x0, 0      # return 0
