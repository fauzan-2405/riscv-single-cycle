module alu_shifter_rv32i (
    input wire [31:0] in,
    input wire [31:0] shamt,
    input wire [1:0] type,
    output wire [31:0] out
);
    assign out = (type == 2'b00) ? (in << shamt) :
                (type == 2'b01) ? (in >> shamt) :
                (type == 2'b10) ? (in >>> shamt) : 32'h0;
endmodule