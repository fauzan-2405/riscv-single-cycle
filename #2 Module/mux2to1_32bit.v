module mux2to1_32bit (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire sel,
    output wire [31:0] D
);
    assign D = (sel) ? B : A;
endmodule