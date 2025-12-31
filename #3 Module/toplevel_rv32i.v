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
    // Control Unit signals
    // ALU source select
    wire        cu_ALU1src_sig;
    wire        cu_ALU2src_sig;

    // Immediate selector
    wire [2:0]  cu_immtype_sig;

    // ALU control
    wire [1:0]  cu_ALUtype_sig;
    wire        cu_adtype_sig;
    wire [1:0]  cu_gatype_sig;
    wire [1:0]  cu_shiftype_sig;
    wire        cu_sltype_sig;

    // Writeback control
    wire [1:0]  cu_rdtype_sig;
    wire        cu_rdwrite_sig;

    // Load / Store
    wire [2:0]  cu_loadtype_sig;
    wire        cu_store_sig;
    wire [1:0]  cu_storetype_sig;

    // Branch / Jump
    wire        cu_branch_sig;
    wire [2:0]  cu_branchtype_sig;
    wire        cu_jump_sig;

    //----------------------------INSTRUCTION FETCH----------------------------//
    wire [31:0] PC_4_add, PC_jump, PC_new;
    wire [31:0] PC_branch;
    assign PC_jump   = ALU_output;
    assign PC_branch = ALU_output;

    // Sesuaikan dengan nama modul 2-to-1 multiplexer generik Anda
    mux2to1_32bit blok_21mux_jumper(
        .A(PC_4_add),
        .B(PC_jump),
        .sel(cu_jump_sig),
        .D(PC_new)
    );

    brancher_rv32i blok_brancher(
        .PC_new(PC_new),
        .PC_branch(PC_branch), // **WARNING** This a bit weird, based on the architecture, it must be PC_jump
        .rs1(rs1),
        .rs2(rs2),
        .cu_branch(cu_branch_sig),
        .cu_branchtype(cu_branchtype_sig),
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
    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    ctrl_unit_rv32i blok_cu (
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),

        .cu_ALU1src     (cu_ALU1src_sig),
        .cu_ALU2src     (cu_ALU2src_sig),

        .cu_immtype     (cu_immtype_sig),

        .cu_ALUtype     (cu_ALUtype_sig),
        .cu_adtype      (cu_adtype_sig),
        .cu_gatype      (cu_gatype_sig),
        .cu_shiftype    (cu_shiftype_sig),
        .cu_sltype      (cu_sltype_sig),

        .cu_rdtype      (cu_rdtype_sig),
        .cu_rdwrite     (cu_rdwrite_sig),

        .cu_loadtype    (cu_loadtype_sig),

        .cu_store       (cu_store_sig),
        .cu_storetype   (cu_storetype_sig),

        .cu_branch      (cu_branch_sig),
        .cu_branchtype  (cu_branchtype_sig),

        .cu_jump        (cu_jump_sig)
    );

    reg_file_rv32i blok_reg (
        .clk(clk),
        .cu_rdwrite(cu_rdwrite_sig),
        .rs1_addr(instr[19:15]),
        .rs2_addr(instr[24:20]),
        .rd_addr(instr[11:7]),
        .rd_in(rd_in),
        
        .rs1(rs1),
        .rs2(rs2)
    );

    imm_select_rv32i blok_imm_select (
        .trimmed_instr(instr[31:7]),
        .cu_immtype(cu_immtype_sig),
        .imm(immediate)
    );

    mux2to1_32bit blok_21mux_id0(
        .A(rs1),
        .B(PC_out),
        .sel(cu_ALU1src_sig),
        .D(ALU_in1)
    );

    mux2to1_32bit blok_21mux_id1(
        .A(rs2),
        .B(immediate),
        .sel(cu_ALU2src_sig),
        .D(ALU_in2)
    );

    //---------------------------------EXECUTE---------------------------------//
    alu_rv32i blok_alu (
        ,in1(ALU_in1),
        .in2(ALU_in2),
        .cu_ALUtype(cu_ALUtype_sig),
        .cu_adtype(cu_adtype_sig),
        .cu_gatype(cu_gatype_sig),
        .cu_shiftype(cu_shiftype_sig),
        .out(ALU_output)
    );

    //------------------------------MEMORY ACCESS------------------------------//
    data_mem_rv32i blok_datamemory (
        .clk(clk),
        .cu_store(cu_store_sig),
        .cu_storetype(cu_storetype_sig),
        .dmem_addr(dmem_addr),
        .rs2(rs2),
        .dmem_out(dmem_out)
    );
    
    load_select_rv32i blok_loadselect (
        .dmem_out(dmem_out),
        .type(cu_loadtype_sig),
        .load_out(load_out)
    );

    //--------------------------------WRITE BACK-------------------------------//
    mux4to1_32bit blok_mux41_wb (
        .W(ALU_output),
        .X(load_out),
        .Y(PC_4_add),
        .Z(immediate),
        .sel(cu_rdtype_sig),
        .D(rd_in)
    );

endmodule