module toplevel_rv32i(
    input wire clk,
    input wire rst_n,

    // Sinyal-sinyal intermediat terekspos
    output wire [31:0] PC, PC_in, instr,
    output wire [6:0] opcode, funct7,
    output wire [2:0] funct3,
    output wire [31:0] immediate,
    output wire [4:0] rs1_addr, rs2_addr, rd_addr,
    output wire [31:0] rs1, rs2, rd_in,
    output wire [31:0] ALU_in1, ALU_in2, ALU_output,
    output wire [31:0] dmem_addr, dmem_out, load_out
);
    //----------------------------INSTRUCTION FETCH----------------------------//
    wire [31:0] PC_4_add, PC_jump, PC_new;
    wire cu_jump;

    // Sesuaikan dengan nama modul 2-to-1 multiplexer generik Anda
    mux2to1_32bit blok_21mux_jumper(
        .A(PC_4_add),
        .B(PC_jump),
        .sel(cu_jump),
        .D(PC_new)
    );

    wire [31:0] PC_branch;
    wire cu_branch;
    wire [3:0] cu_branchtype;

    brancher_rv32i blok_brancher(
        .PC_new(PC_new),
        .PC_branch(PC_branch),
        .rs1(rs1),
        .rs2(rs2),
        .cu_branch(cu_branch),
        .cu_branchtype(cu_branchtype),
        .PC_in(PC_in)
    );

    wire [31:0] PC_out;

    pc_rv32i blok_pc(
        .clk(clk),
        .rst_n(rst_n),
        .PC_in(PC_in),
        .PC_out(PC_out)
    );

    assign PC = PC_out;

    pc_4_adder_rv32i blok_4adder(
        .PC_old(PC_out),
        .PC_4_add(PC_4_add)
    );

    instr_rom_rv32i blok_imem(
        .clk(clk),
        .PC(PC_out),
        .INSTR(instr)
    );

    //---------------------------INSTRUCTION DECODE---------------------------//
    ctrl_unit_rv32i blok_cu (
        .opcode(),
        .funct3(),
        .funct7(),

        .cu_ALU1src(),          // rs1 = 1'b0, PC = 1'b1
        .cu_ALU2src(),          // rs2 = 1'b0, imm = 1'b1

        .cu_immtype(),          // I-type = 3'b000, S-type = 3'b001,
                                // B-type = 3'b010, U-type = 3'b011,
                                // J-type = 3'b100

        .cu_ALUtype(),          // ADD/SUB = 2'b00, GATE = 2'b01,
                                        // SHIFT = 2'b10 , SLT = 2'b11

        .cu_adtype(),           // ADD = 1’b0, SUB = 1’b1
        .cu_gatype(),           // XOR = 2'b00, OR = 2'b01, AND = 2'b10
        .cu_shiftype(),         // SLL = 2'b00, SRL = 2'b01, SRA = 2'b10
        .cu_sltype(),           // Signed = 1'b0, Unsigned = 1'b1

        .cu_rdtype(),           // From ALU = 2'b00 , from memory = 2'b01,
                                // from PC+4 = 2'b10,
                                // from immediate = 2'b11
        .cu_rdwrite(),          // Enable write to rd = 1'b1

        .cu_loadtype(),         // Load byte = 3'b000, load half = 3'b001 ,
                                // load word = 3'b010, load ubyte = 3'b011,
                                // load uhalf = 3'b100

        .cu_store(),            // Store to memory = 1'b1
        cu_storetype(),         // Store byte = 2'b00, store half = 2'b01,
                                // store word = 2'b10

        .cu_branch(),           // Enable branching = 1'b1
        .cu_branchtype(),       // BEQ = 3'b000, BNE = 3'b001,
                                // BLT = 3'b010, BGE = 3'b011,
                                // BLTU = 3'b100, BGEU = 3'b101

        .cu_jump()              // Enable jumping = 1'b1
    );

    reg_file_rv32i blok_reg (
        .clk(clk),
        .cu_rdwrite(),
        .rs1_addr(),
        .rs2_addr(),
        .rd_addr(),
        .rd_in(),
        
        .rs1(),
        .rs2()
    );

    imm_select_rv32i blok_imm_select (
        .trimmed_instr(),
        .cu_immtype(),
        .imm()
    );

    mux2to1_32bit blok_21mux_id0(
        .A(),
        .B(),
        .sel(),
        .D()
    );

    mux2to1_32bit blok_21mux_id1(
        .A(),
        .B(),
        .sel(),
        .D()
    );

    //---------------------------------EXECUTE---------------------------------//
    alu_rv32i blok_alu (
        ,in1(),
        .in2(),
        .cu_ALUtype(),
        .cu_adtype(),
        .cu_gatype(),
        .cu_shiftype(),
        .out()
    );

    //------------------------------MEMORY ACCESS------------------------------//
    data_mem_rv32i blok_datamemory (
        .clk(clk),
        .cu_store(),
        .cu_storetype(),
        .dmem_addr(),
        .rs2(),
        .dmem_out()
    );
    
    load_select_rv32i blok_loadselect (
        .dmem_out(),
        .type(),
        .load_out()
    );

    //--------------------------------WRITE BACK-------------------------------//
    mux4to1_32bit blok_mux41_wb (
        .W(),
        .X(),
        .Y(),
        .Z(),
        .sel(),
        .D()
    );
    
endmodule