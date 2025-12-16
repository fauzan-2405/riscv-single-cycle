**Complete Table (Compact)**
| Instruction | Type | Opcode[6:0] | funct3 | funct7  | Meaning                    |
| ----------- | ---- | ----------- | ------ | ------- | -------------------------- |
| SLLI        | I    | 0010011     | 001    | 0000000 | Shift left logical imm     |
| SUB         | R    | 0110011     | 000    | 0100000 | Subtract                   |
| NOR         | –    | –           | –      | –       | Not in RV32I (use OR+XORI) |
| ADDI        | I    | 0010011     | 000    | –       | Add immediate              |
| XORI        | I    | 0010011     | 100    | –       | XOR immediate              |
| JAL (rd=x0) | J    | 1101111     | –      | –       | Unconditional jump         |
| SRLI        | I    | 0010011     | 101    | 0000000 | Shift right logical imm    |
| AND         | R    | 0110011     | 111    | 0000000 | AND                        |
| SLT         | R    | 0110011     | 010    | 0000000 | Set less than (signed)     |
| SLTI        | I    | 0010011     | 010    | –       | Set less than imm          |
| LUI         | U    | 0110111     | –      | –       | Load upper immediate       |
| JAL         | J    | 1101111     | –      | –       | Jump + link                |
| JALR        | I    | 1100111     | 000    | –       | Jump + link register       |
| OR          | R    | 0110011     | 110    | 0000000 | OR                         |
| BEQ         | B    | 1100011     | 000    | –       | Branch if equal            |
| ANDI        | I    | 0010011     | 111    | –       | AND immediate              |
| LW          | I    | 0000011     | 010    | –       | Load word                  |
| ADD         | R    | 0110011     | 000    | 0000000 | Add                        |
| XOR         | R    | 0110011     | 100    | 0000000 | XOR                        |
| BNE         | B    | 1100011     | 001    | –       | Branch if not equal        |
| ORI         | I    | 0010011     | 110    | –       | OR immediate               |
| SW          | S    | 0100011     | 010    | –       | Store word                 |
| SLTIU       | I    | 0010011     | 011    | –       | Set less than imm unsigned |

Machine code from Venus based on test_vector.asm :
0x00100293
0x00000313
0x00B00393
0x0072C463
0x00000013
0x00530333
0x00128293
0xFE72C8E3
0x00A00513
0x00000073

| Address | Machine Code | Meaning            |
| ------- | ------------ | ------------------ |
| mem[0]  | `0x00100293` | `addi x5, x0, 1`   |
| mem[1]  | `0x00000313` | `addi x6, x0, 0`   |
| mem[2]  | `0x00B00393` | `addi x7, x0, 11`  |
| mem[3]  | `0x0072C463` | `blt x5, x7, body` |
| mem[4]  | `0x00000013` | NOP                |
| mem[5]  | `0x00530333` | `add x6, x6, x5`   |
| mem[6]  | `0x00128293` | `addi x5, x5, 1`   |
| mem[7]  | `0xFE72C8E3` | `blt x5, x7, loop` |
| mem[8]  | `0x00A00513` | `addi a0, x0, 10`  |
| mem[9]  | `0x00000073` | `ecall`            |

Why do we PC[6:2] for addressing? It is because PC generates addresses by incrementing 4. So, for example:
We started from 0x0000 0000 (32 bit). The next address are: 0x0000 01000 (4 in int). The first two bits [1:0] are always
00, so it does not have any function for the address. So, we extract JUST PC[6:2] for addressing. Oh, BTW PC[6:2] is
5 bits long, i.e. enough to give address to 32 registers in RISC-V