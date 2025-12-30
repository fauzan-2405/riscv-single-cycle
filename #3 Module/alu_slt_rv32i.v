module alu_slt_rv32i (
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire type,
    output wire [31:0] out
);
    assign out = (type) ? (($unsigned(in1) < $unsigned(in2)) ? 32'h00000001 : 32'h00000000) 
                        : ((in1 < in2) ? 32'h00000001 : 32'h00000000);
endmodule