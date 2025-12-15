.text
.globl main
main:
    ADDI x5, x0, 1      # i = 1
    ADDI x6, x0, 0      # sum = 0
    ADDI x7, x0, 11     # stop when i == 11

loop:
    BLT  x5, x7, body    # if i < 11, run body, else exit
    ADDI x0, x0, 0      # exit (NOP)
    # nothing else needed here

body:
    ADD  x6, x6, x5     # sum += i
    ADDI x5, x5, 1      # i++
    BLT  x5, x7, loop   # loop again if i < 11

exit:
    li a0, 10      # return 0
    ecall
