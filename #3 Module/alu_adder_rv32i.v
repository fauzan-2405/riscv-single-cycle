module alu_adder_rv32i (
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire type,
    output wire [31:0] out
);
    assign out = (type) ? (in1 + (~in2 + 1)) 
                            : (in1 + in2);
endmodule