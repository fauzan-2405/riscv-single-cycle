// ============================================================
// Register File RV32I
// 32 registers x 32-bit
// 2 asynchronous read ports
// 1 synchronous write port
// x0 is hardwired to zero
// ============================================================

module reg_file_rv32i (
    input  wire        clk,       // global clock
    input  wire        cu_rdwrite,    // write enable from CU
    input  wire [4:0]  rs1_addr,      // read port 1 address
    input  wire [4:0]  rs2_addr,      // read port 2 address
    input  wire [4:0]  rd_addr,       // write-back address
    input  wire [31:0] rd_in,          // write-back data
    output wire [31:0] rs1,            // read port 1 data
    output wire [31:0] rs2             // read port 2 data
);

    // Register storage: 32 x 32-bit
    reg [31:0] rf [0:31];
    integer i;

    // Initialize registers (simulation only)
    initial begin
        for (i = 0; i < 32; i = i + 1)
            rf[i] = 32'b0;
    end

    // Synchronous write (posedge)
    // x0 is always zero
    always @(posedge clock) begin
        if (cu_rdwrite && (rd_addr != 5'd0))
            rf[rd_addr] <= rd_in;

        // Enforce x0 = 0
        rf[0] <= 32'b0;
    end

    // Asynchronous read
    assign rs1 = (rs1_addr == 5'd0) ? 32'b0 : rf[rs1_addr];
    assign rs2 = (rs2_addr == 5'd0) ? 32'b0 : rf[rs2_addr];

endmodule
