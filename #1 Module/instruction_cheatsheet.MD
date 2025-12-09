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
