`timescale 1ns / 1ps

module tb_reg_file_rv32i;

    localparam CLK_PERIOD = 10;

    // DUT signals
    reg         clock;
    reg         cu_rdwrite;
    reg  [4:0]  rs1_addr;
    reg  [4:0]  rs2_addr;
    reg  [4:0]  rd_addr;
    reg  [31:0] rd_in;
    wire [31:0] rs1;
    wire [31:0] rs2;

    // DUT instantiation
    reg_file_rv32i dut (
        .clock      (clock),
        .cu_rdwrite (cu_rdwrite),
        .rs1_addr   (rs1_addr),
        .rs2_addr   (rs2_addr),
        .rd_addr    (rd_addr),
        .rd_in      (rd_in),
        .rs1        (rs1),
        .rs2        (rs2)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #(CLK_PERIOD/2) clock = ~clock;
    end

    // ============================
    // Test sequence
    // ============================
    initial begin
        $display("==== Register File Testbench ====");

        // Default values
        cu_rdwrite = 0;
        rs1_addr   = 0;
        rs2_addr   = 0;
        rd_addr    = 0;
        rd_in      = 0;

        // Wait for init
        repeat (2) @(posedge clock);

        // --------------------------------
        // TEST 1: Write to x1
        // --------------------------------
        @(posedge clock);
        cu_rdwrite = 1;
        rd_addr    = 5'd1;
        rd_in      = 32'h11111111;

        @(posedge clock);
        cu_rdwrite = 0;

        // Read immediately (async)
        rs1_addr = 5'd1;
        rs2_addr = 5'd0;
        #1;
        $display("x1 = 0x%08h (expect 11111111)", rs1);

        // --------------------------------
        // TEST 2: Write to x2
        // --------------------------------
        @(posedge clock);
        cu_rdwrite = 1;
        rd_addr    = 5'd2;
        rd_in      = 32'h22222222;

        @(posedge clock);
        cu_rdwrite = 0;

        rs1_addr = 5'd2;
        rs2_addr = 5'd1;
        #1;
        $display("x2 = 0x%08h (expect 22222222)", rs1);
        $display("x1 = 0x%08h (expect 11111111)", rs2);

        // --------------------------------
        // TEST 3: Attempt write to x0
        // --------------------------------
        @(posedge clock);
        cu_rdwrite = 1;
        rd_addr    = 5'd0;
        rd_in      = 32'hFFFFFFFF;

        @(posedge clock);
        cu_rdwrite = 0;

        rs1_addr = 5'd0;
        #1;
        $display("x0 = 0x%08h (expect 00000000)", rs1);

        // --------------------------------
        // TEST 4: Change read address (async read)
        // --------------------------------
        rs1_addr = 5'd1;
        rs2_addr = 5'd2;
        #1;
        $display("x1 = 0x%08h, x2 = 0x%08h (expect 11111111, 22222222)",
                 rs1, rs2);

        // --------------------------------
        // Done
        // --------------------------------
        $display("==== Test Finished ====");
        $finish;
    end

endmodule
