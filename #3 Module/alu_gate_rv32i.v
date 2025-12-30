module alu_gate_rv32i (
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire [1:0] type,
    output wire [31:0] out
);
    assign out = (type == 2'b00) ? (in1 ^ in2) :
                 (type == 2'b01) ? (in1 | in2) :
                 (type == 2'b10) ? (in1 & in2) : 32'h0;
endmodule