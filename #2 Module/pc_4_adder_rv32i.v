module pc_4_adder_rv32i (
    input wire [31:0] PC_old,
    output wire [31:0] PC_4_add
);
    assign PC_4_add = PC_old + 4;
endmodule