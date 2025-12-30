module imm_select_rv32i(
    input wire [31:7] trimmed_instr,    // instr[31:7]
    input wire [2:0]  cu_immtype,        // 000=I, 001=S, 010=B, 011=U, 100=J
    output reg [31:0] imm
);
    always @(*) begin
        case (cu_immtype)

        // ======================
        // I-type (addi, lw, jalr)
        // imm[11:0] = instr[31:20]
        // ======================
        3'b000: 
            imm = {{20{trimmed_instr[31]}}, trimmed_instr[31:20]};

        // ======================
        // S-type (sw, sh, sb)
        // imm[11:5] = instr[31:25]
        // imm[4:0]  = instr[11:7]
        // ======================
        3'b001: 
            imm = {{20{trimmed_instr[31]}},
                   trimmed_instr[31:25],
                   trimmed_instr[11:7]};

        // ======================
        // B-type (beq, bne, blt, bge)
        // imm[12]   = instr[31]
        // imm[10:5] = instr[30:25]
        // imm[4:1]  = instr[11:8]
        // imm[11]   = instr[7]
        // imm[0]    = 0
        // ======================
        3'b010:
            imm = {{19{trimmed_instr[31]}},
                   trimmed_instr[31],
                   trimmed_instr[7],
                   trimmed_instr[30:25],
                   trimmed_instr[11:8],
                   1'b0};

        // ======================
        // U-type (lui, auipc)
        // imm[31:12] = instr[31:12]
        // imm[11:0]  = 0
        // ======================
        3'b011:
            imm = {trimmed_instr[31:12], 12'b0};

        // ======================
        // J-type (jal)
        // imm[20]    = instr[31]
        // imm[10:1]  = instr[30:21]
        // imm[11]    = instr[20]
        // imm[19:12] = instr[19:12]
        // imm[0]     = 0
        // ======================
        3'b100:
            imm = {{11{trimmed_instr[31]}},
                   trimmed_instr[31],
                   trimmed_instr[19:12],
                   trimmed_instr[20],
                   trimmed_instr[30:21],
                   1'b0};

        default:
            imm = 32'd0;

        endcase
    end
endmodule
