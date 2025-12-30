module load_select_rv32i (
    input  wire [31:0] dmem_out, // from data memory
    input  wire [2:0]  type,
    output wire [31:0] load_out
);
    assign load_out =
        (type == 3'b000) ? {{24{dmem_out[7]}},  dmem_out[7:0]}  : // LB  (sign extend)
        (type == 3'b001) ? {{16{dmem_out[15]}}, dmem_out[15:0]} : // LH  (sign extend)
        (type == 3'b010) ? dmem_out                              : // LW
        (type == 3'b011) ? {24'b0, dmem_out[7:0]}               : // LBU (zero extend)
        (type == 3'b100) ? {16'b0, dmem_out[15:0]}              : // LHU (zero extend)
                           32'b0;
endmodule
