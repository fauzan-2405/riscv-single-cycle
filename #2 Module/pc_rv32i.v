module pc_rv32i (
    input wire clk,
    input wire rst_n,
    input wire [31:0] PC_in,
    output reg [31:0] PC_out
);
    always @(posedge clk) begin
        if (~rst_n) begin
            PC_out <= 32'h0;
        end else begin
            PC_out <= PC_in;
        end
    end
endmodule