module mux4to1_32bit (
    input wire [31:0] W,
    input wire [31:0] X,
    input wire [31:0] Y,
    input wire [31:0] Z,
    input wire [1:0] sel,
    output wire [31:0] D
);
    assign D = (sel == 2'b00) ? W :
               (sel == 2'b01) ? X :
               (sel == 2'b10) ? Y :
                                Z;
endmodule
