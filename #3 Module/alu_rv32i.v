module alu_rv32i(
    input wire [31:0] in1,          // in1 = rs1 atau PC
    input wire [31:0] in2,          // in2 = rs2 atau imm
    input wire [1:0] cu_ALUtype,    // adder = 2'b00, gate = 2'b01,
                                    // shifter = 2'b10, SLT = 2'b11
    input wire cu_adtype,
    input wire [1:0] cu_gatype,
    input wire [1:0] cu_shiftype,
    input wire cu_sltype,

    output reg [31:0] out
    );
    wire [31:0] adder_out, gate_out, shifter_out, slt_out;

    alu_adder_rv32i subblok_adder(
        .in1(in1),
        .in2(in2),
        .type(cu_adtype),
        .out(adder_out)
    );

    alu_gate_rv32i subblok_gate(
        .in1(in1),
        .in2(in2),
        .type(cu_gatype),
        .out(gate_out)
    );

    alu_shifter_rv32i subblok_shifter(
        .in1(in1),
        .shamt(in2),
        .type(cu_shiftype),
        .out(shifter_out)
    );

    alu_slt_rv32i subblok_slt (
        .in1(in1),
        .in2(in2),
        .type(cu_sltype),
        .out(slt_out)
    );

    always @ (*)
    begin
        case (cu_ALUtype)
        2'b00:
            out <= adder_out;
        2'b01:
            out <= gate_out; // isi untuk tipe operasi gate logika
        2'b10:
            out <= shifter_out;
        2'b11:
            out <= slt_out;
        default:
            out <= 32'd0;
        endcase
    end
endmodule