module brancher_rv32i(
    input wire [31:0] PC_new,       // PC + 4
    input wire [31:0] PC_branch,    // PC + imm (from ALU)
    input wire signed [31:0] in1,   // rs1
    input wire signed [31:0] in2,   // rs2
    input wire cu_branch,           // branch enable
    input wire [2:0] cu_branchtype, // BEQ=000, BNE=001, BLT=010,
                                    // BGE=011, BLTU=100, BGEU=101
    output reg [31:0] PC_in
);
    always @(*) begin
        if (cu_branch) begin
            case (cu_branchtype)

            // ======================
            // BEQ: branch if equal
            // ======================
            3'b000:
                PC_in = (in1 == in2) ? PC_branch : PC_new;

            // ======================
            // BNE: branch if not equal
            // ======================
            3'b001:
                PC_in = (in1 != in2) ? PC_branch : PC_new;

            // ======================
            // BLT: branch if less than (signed)
            // ======================
            3'b010:
                PC_in = (in1 < in2) ? PC_branch : PC_new;

            // ======================
            // BGE: branch if greater or equal (signed)
            // ======================
            3'b011:
                PC_in = (in1 >= in2) ? PC_branch : PC_new;

            // ======================
            // BLTU: branch if less than (unsigned)
            // ======================
            3'b100:
                PC_in = ($unsigned(in1) < $unsigned(in2)) ? PC_branch : PC_new;

            // ======================
            // BGEU: branch if greater or equal (unsigned)
            // ======================
            3'b101:
                PC_in = ($unsigned(in1) >= $unsigned(in2)) ? PC_branch : PC_new;

            default:
                PC_in = PC_new;
            endcase
        end
        else begin
            PC_in = PC_new;
        end
    end
endmodule
