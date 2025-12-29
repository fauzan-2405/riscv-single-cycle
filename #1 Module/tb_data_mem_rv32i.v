`timescale 1ns / 1ps

module tb_data_mem_rv32i;

    localparam CLK_PERIOD = 10;

    // DUT signals
    reg         clock;
    reg         cu_store;
    reg  [1:0]  cu_storetype;
    reg  [31:0] dmem_addr;
    reg  [31:0] rs2;
    wire [31:0] dmem_out;

    // DUT
    data_mem_rv32i dut (
        .clock        (clock),
        .cu_store     (cu_store),
        .cu_storetype (cu_storetype),
        .dmem_addr    (dmem_addr),
        .rs2          (rs2),
        .dmem_out     (dmem_out)
    );

    // Clock
    initial begin
        clock = 0;
        forever #(CLK_PERIOD/2) clock = ~clock;
    end
    
    initial begin
        $display("==== Data Memory Testbench ====");

        // Default
        cu_store     = 0;
        cu_storetype = 2'b00;
        dmem_addr    = 32'b0;
        rs2          = 32'b0;

        // Wait for memory init
        repeat (2) @(posedge clock);

        // --------------------------
        // TEST 1: Store Word (SW)
        // --------------------------
        @(posedge clock);
        cu_store     = 1;
        cu_storetype = 2'b10;             // SW
        dmem_addr    = 32'h0000_0000;
        rs2          = 32'hDEADBEEF;

        @(posedge clock);
        cu_store = 0;

        // Wait for read latency
        repeat (1) @(posedge clock);
        $display("SW Read @0x00 = 0x%08h (expect DEADBEEF)", dmem_out);

        // --------------------------
        // TEST 2: Store Byte (SB)
        // --------------------------
        @(posedge clock);
        cu_store     = 1;
        cu_storetype = 2'b00;             // SB
        dmem_addr    = 32'h0000_0001;     // byte offset = 1
        rs2          = 32'h000000AA;

        @(posedge clock);
        cu_store = 0;

        repeat (1) @(posedge clock);
        $display("SB Read @0x00 = 0x%08h (expect DEADAAEF)", dmem_out);

        // --------------------------
        // TEST 3: Store Halfword (SH)
        // --------------------------
        @(posedge clock);
        cu_store     = 1;
        cu_storetype = 2'b01;             // SH
        dmem_addr    = 32'h0000_0002;     // halfword upper
        rs2          = 32'h00001234;

        @(posedge clock);
        cu_store = 0;

        repeat (1) @(posedge clock);
        $display("SH Read @0x00 = 0x%08h (expect 1234AAEF)", dmem_out);

        // --------------------------
        // TEST 4: Another SW
        // --------------------------
        @(posedge clock);
        cu_store     = 1;
        cu_storetype = 2'b10;             // SW
        dmem_addr    = 32'h0000_0004;
        rs2          = 32'hCAFEBABE;

        @(posedge clock);
        cu_store = 0;

        repeat (1) @(posedge clock);
        $display("SW Read @0x04 = 0x%08h (expect CAFEBABE)", dmem_out);

        $display("==== Test Finished ====");
        $finish;
    end

endmodule
