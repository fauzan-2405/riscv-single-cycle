
module instr_rom_rv32i (
    input wire [31:0] ADDR, // byte address dari PC
    output wire [31:0] INSTR // instruksi 32-bit
);
    // 32 word x 32-bit
    reg [31:0] mem [0:31];

    // Word index = PC[6:2] (bit [1:0] = 2'b00)
    wire [4:0] waddr = ADDR[6:2];

    integer i;
    initial begin
        // Default: semua NOP (addi x0,x0,0)
        for (i = 0; i < 32; i = i + 1) mem[i] = 32'h00000013;

        // Isi program (ganti sesuai dengan "Machine Code" dari Venus pada Tugas Pendahuluan nomor 3!):
        mem[0] = 32'h00100293; //
        mem[1] = 32'h00000313; // 
        mem[2] = 32'h00B00393; // 
        mem[3] = 32'h0072C463; // 
        mem[4] = 32'h00000013;
        mem[5] = 32'h00530333;
        mem[6] = 32'h00128293;
        mem[7] = 32'hFE72C8E3;
        mem[8] = 32'h00A00513;
        mem[9] = 32'h00000073;
    end
    // Baca asinkron
    assign INSTR = mem[waddr];
endmodule