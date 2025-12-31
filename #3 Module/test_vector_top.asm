.text
.globl main

main:
    addi sp, sp, -32            # Allocate stack frame
    sw ra, 28(sp)               # Save return address
    sw s0, 24(sp)               # Save s0
    sw s1, 20(sp)               # Save s1
    sw s2, 16(sp)               # Save s2

    lui s0, 0x1                 # Load upper 20 bits
    addi s0, s0, -1771          # a = 2325 (0x915)
    addi s1, zero, 71           # b = 71

    # Call division(a, b)
    addi a0, s0, 0              # First argument: a
    addi a1, s1, 0              # Second argument: b
    jal ra, division            # Call division
    addi s2, a0, 0              # Save div result in s2

    # Call remainder(a, b)
    addi a0, s0, 0              # First argument: a
    addi a1, s1, 0              # Second argument: b
    jal ra, remainder           # Call remainder
    sw a0, 12(sp)               # Save rem result on stack
    
    # Call multiply(b, div)
    addi a0, s1, 0              # First argument: b
    addi a1, s2, 0              # Second argument: div
    jal ra, multiply            # Call multiply

    # Calculate (multiply(b, div) + rem == a) ? 1 : 0
    lw t0, 12(sp)               # Load rem
    lw t0, 12(sp)               # Wait for an extra cycle to ensure memory loaded correctly
    add t1, a0, t0              # t1 = multiply(b, div) + rem
    sub t2, t1, s0              # t2 = (multiply + rem) - a
    sltiu a0, t2, 1             # a0 = (t2 == 0) ? 1 : 0
    
    # Restore and return
    lw s2, 16(sp)               # Restore s2
    lw s2, 16(sp)               # Wait for load
    lw s1, 20(sp)               # Restore s1
    lw s1, 20(sp)               # Wait for load
    lw s0, 24(sp)               # Restore s0
    lw s0, 24(sp)               # Wait for load
    lw ra, 28(sp)               # Restore return address
    lw ra, 28(sp)               # Wait for load
    addi sp, sp, 32             # Deallocate stack frame
    jalr zero, ra, 0            # Return

multiply:
    addi t0, zero, 0            # y = 0
    addi t1, zero, 0            # i = 0

multiply_loop:
    bge t1, a1, multiply_end    # if (i >= b) exit loop
    add t0, t0, a0              # y += a
    addi t1, t1, 1              # i++
    jal zero, multiply_loop     # Continue loop

multiply_end:
    addi a0, t0, 0              # Return y
    jalr zero, ra, 0            # Return

division:
    addi t0, zero, 0            # y = 0
    addi t1, a0, 0              # i = a

division_loop:
    blt t1, a1, division_end    # if (i < b) exit loop
    sub t1, t1, a1              # i -= b
    addi t0, t0, 1              # y++
    jal zero, division_loop     # Continue loop

division_end:
    addi a0, t0, 0              # Return y
    jalr zero, ra, 0            # Return

remainder:
    addi t0, a0, 0              # y = a

remainder_loop:
    blt t0, a1, remainder_end   # if (y < b) exit loop
    sub t0, t0, a1              # y -= b
    jal zero, remainder_loop    # Continue loop

remainder_end:
    addi a0, t0, 0              # Return y
    jalr zero, ra, 0            # Return