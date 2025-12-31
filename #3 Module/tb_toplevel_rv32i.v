`timescale 1ns/1ps

module tb_toplevel_rv32i;

    // Clock & reset
    reg clk;
    reg rst_n;

    // Debug outputs from DUT
    wire [31:0] PC, PC_in, instr;
    wire [6:0]  opcode, funct7;
    wire [2:0]  funct3;
    wire [31:0] immediate;
    wire [4:0]  rs1_addr, rs2_addr, rd_addr;
    wire [31:0] rs1, rs2, rd_in;
    wire [31:0] ALU_in1, ALU_in2, ALU_output;
    wire [31:0] dmem_addr, dmem_out, load_out;

    // =============================
    // DUT instantiation
    // =============================
    toplevel_rv32i dut (
        .clk(clk),
        .rst_n(rst_n),

        .PC(PC),
        .PC_in(PC_in),
        .instr(instr),

        .opcode(opcode),
        .funct7(funct7),
        .funct3(funct3),

        .immediate(immediate),

        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),

        .rs1(rs1),
        .rs2(rs2),
        .rd_in(rd_in),

        .ALU_in1(ALU_in1),
        .ALU_in2(ALU_in2),
        .ALU_output(ALU_output),

        .dmem_addr(dmem_addr),
        .dmem_out(dmem_out),
        .load_out(load_out)
    );

    // =============================
    // Clock generation (100 MHz)
    // =============================
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 ns period
    end

    // =============================
    // Reset sequence
    // =============================
    initial begin
        rst_n = 0;
        #30;
        rst_n = 1;
    end

    // =============================
    // Simulation control
    // =============================
    initial begin
        // Waveform dump
        $dumpfile("rv32i.vcd");     // GTKWave
        $dumpvars(0, tb_toplevel_rv32i);

        // Run simulation
        #2000;  // adjust as needed
        $display("Simulation finished.");
        $finish;
    end

    // =============================
    // Instruction trace (VERY useful)
    // =============================
    always @(posedge clk) begin
        if (rst_n) begin
            $display(
                "PC=%08h | instr=%08h | op=%02h | rs1=x%0d=%08h | rs2=x%0d=%08h | rd=x%0d | ALU=%08h",
                PC,
                instr,
                opcode,
                rs1_addr, rs1,
                rs2_addr, rs2,
                rd_addr,
                ALU_output
            );
        end
    end

endmodule
