`timescale 1ns / 1ps

module tb_instr_rom_rv32i;
    localparam CLK_PERIOD = 10;

    reg         clock;
    reg  [31:0] instr_addr;
    wire [31:0] instr_out;

    // DUT
    instr_rom_rv32i dut (
        .clock      (clock),
        .instr_addr (instr_addr),
        .instr_out  (instr_out)
    );

    initial begin
        clock = 0;
        forever #(CLK_PERIOD/2) clock = ~clock;
    end

    initial begin
        $display("==== Instruction ROM Testbench ====");
        $display("Time\tPC\t\tInstruction");

        // Start at PC = 0
        instr_addr = 32'h0000_0000;

        // Wait a few cycles
        repeat (2) @(posedge clock);

        // Fetch first 16 instructions
        repeat (16) begin
            @(posedge clock);
            instr_addr = instr_addr + 4; // RISC-V PC += 4
        end

        // Wait for last read
        repeat (2) @(posedge clock);

        $display("==== Test Finished ====");
        $finish;
    end

    // ========================
    // Monitor output
    // ========================
    always @(posedge clock) begin
        $display("%0t\t0x%08h\t0x%08h",
                 $time,
                 instr_addr,
                 instr_out);
    end

endmodule
