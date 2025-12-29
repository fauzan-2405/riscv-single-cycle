
module data_mem_rv32i (
    input wire clock,
    input wire cu_store, // WE dari CU
    input wire [1:0] cu_storetype, // 00=SB, 01=SH, 10=SW
    input wire [31:0] dmem_addr, // byte address
    input wire [31:0] rs2, // data tulis
    output wire [31:0] dmem_out // data baca (async)
);
    wire [7:0] waddr = dmem_addr[9:2];
    reg [3:0] be;

    always @* begin
        case (cu_storetype)
            2'b00: case (dmem_addr[1:0]) // SB
                2'b00: be = 4'b0001;
                2'b01: be = 4'b0010;
                2'b10: be = 4'b0100;
                default: be = 4'b1000;
            endcase
            2'b01: be = (dmem_addr[1]) ? 4'b1100 : 4'b0011; // SH
            2'b10: be = 4'b1111; // SW
            default: be = 4'b0000;
        endcase
    end
    reg [31:0] wr_data_aligned;

    always @* begin
        case (cu_storetype)
            2'b00: case (dmem_addr[1:0]) // SB
                    2'b00: wr_data_aligned = {24'b0, rs2[7:0]};
                    2'b01: wr_data_aligned = {16'b0, rs2[7:0], 8'b0};
                    2'b10: wr_data_aligned = {8'b0, rs2[7:0], 16'b0};
                    default: wr_data_aligned = {rs2[7:0], 24'b0};
                    endcase
            2'b01: wr_data_aligned = (dmem_addr[1]) ? {rs2[15:0],16'b0} : {16'b0, rs2[15:0]};// SH
            2'b10: wr_data_aligned = rs2;
            default: wr_data_aligned = 32'b0;
        endcase
    end

    xpm_memory_spram #(
        .ADDR_WIDTH_A        (8),         // 32 words / $clog2(32)
        .MEMORY_SIZE         (32*256),     // bits
        .READ_DATA_WIDTH_A   (32),
        .WRITE_DATA_WIDTH_A  (32),
        .BYTE_WRITE_WIDTH_A  (8),
        .READ_LATENCY_A      (1),         // synchronous read (1 cycle)
        .MEMORY_INIT_FILE    ("dmemory.mem"),
        .MEMORY_PRIMITIVE    ("auto"),    // let Vivado choose BRAM/LUTRAM
        .ECC_MODE            ("no_ecc")
    ) ram (
        .clka   (clock),
        .wea    (be & {4{cu_store}})
        .addra  (waddr),
        .dina   (wr_data_aligned)
        .ena    (1'b1),
        .rsta   (1'b0),
        .regcea (1'b1),
        .douta  (dmem_out),
        .injectsbiterra (1'b0),
        .injectdbiterra (1'b0)
    );

    
endmodule