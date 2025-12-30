module instr_rom_rv32i (
    input wire clk, 
    input wire [31:0] PC, 
    output wire [31:0] INSTR
);
    // Word index untuk 32 word
    wire [4:0] waddr = PC[6:2];

    xpm_memory_sprom #(
        .ADDR_WIDTH_A        (5),         // 32 words / $clog2(32)
        .MEMORY_SIZE         (32*32),     // bits
        .READ_DATA_WIDTH_A   (32),
        .READ_LATENCY_A      (1),         // synchronous read (1 cycle)
        .MEMORY_INIT_FILE    ("imemory_rv32i.mem"),
        .MEMORY_PRIMITIVE    ("auto"),    // let Vivado choose BRAM/LUTRAM
        .ECC_MODE            ("no_ecc"),
        .AUTO_SLEEP_TIME     (0),
        .WAKEUP_TIME         ("disable")
    ) instr_rom (
        .clka   (clock),
        .addra  (waddr),
        .ena    (1'b1),
        .rsta   (1'b0),
        .regcea (1'b1),
        .douta  (INSTR),
        .injectsbiterra (1'b0),
        .injectdbiterra (1'b0)
    );
    
endmodule