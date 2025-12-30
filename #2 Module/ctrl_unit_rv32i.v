module ctrl_unit_rv32i (
    input wire [6:0] opcode,        // R = 7'h33 , I = 7'h13 , Load = 7'h3,
                                    // S = 7'h23 , B = 7'h63 , JAL = 7'h6F,
                                    // JALR = 7'h67, LUI = 7'h37, AUIPC = 7'h17
    input wire [2:0] funct3,
    input wire [6:0] funct7,

    output reg cu_ALU1src,          // rs1 = 1'b0, PC = 1'b1
    output reg cu_ALU2src,          // rs2 = 1'b0, imm = 1'b1

    output reg [2:0] cu_immtype,    // I-type = 3'b000, S-type = 3'b001,
                                    // B-type = 3'b010, U-type = 3'b011,
                                    // J-type = 3'b100

    output reg [1:0] cu_ALUtype,    // ADD/SUB = 2'b00, GATE = 2'b01,
                                    // SHIFT = 2'b10 , SLT = 2'b11

    output reg cu_adtype,           // ADD = 1’b0, SUB = 1’b1
    output reg [1:0] cu_gatype,     // XOR = 2'b00, OR = 2'b01, AND = 2'b10
    output reg [1:0] cu_shiftype,   // SLL = 2'b00, SRL = 2'b01, SRA = 2'b10
    output reg cu_sltype,           // Signed = 1'b0, Unsigned = 1'b1

    output reg [1:0] cu_rdtype,     // From ALU = 2'b00 , from memory = 2'b01,
                                    // from PC+4 = 2'b10,
                                    // from immediate = 2'b11
    output reg cu_rdwrite,          // Enable write to rd = 1'b1

    output reg [2:0] cu_loadtype,   // Load byte = 3'b000, load half = 3'b001 ,
                                    // load word = 3'b010, load ubyte = 3'b011,
                                    // load uhalf = 3'b100

    output reg cu_store,            // Store to memory = 1'b1
    output reg [1:0] cu_storetype,  // Store byte = 2'b00, store half = 2'b01,
                                    // store word = 2'b10

    output reg cu_branch,           // Enable branching = 1'b1
    output reg [2:0] cu_branchtype, // BEQ = 3'b000, BNE = 3'b001,
                                    // BLT = 3'b010, BGE = 3'b011,
                                    // BLTU = 3'b100, BGEU = 3'b101

    output reg cu_jump              // Enable jumping = 1'b1
);
    always @* begin
        cu_ALU1src <= 1'b0;     // From rs1 by default
        cu_ALU2src <= 1'b0;     // From rs2 by default
        cu_immtype <= 3'b000;   // I-type immediate by default
        cu_ALUtype <= 2'b00;    // ADD/SUB by default
        cu_adtype <= 1'b0;      // Addition by default
        cu_gatype <= 2'b00;     // XOR by default
        cu_shiftype <= 2'b00;   // SLL by default
        cu_sltype <= 1'b0;      // SLT by default
        cu_rdtype <= 2'b00;     // From ALU by default
        cu_rdwrite <= 1'b0;     // No by default
        cu_loadtype <= 3'b000;  // Byte by default
        cu_store <= 1'b0;       // No by default
        cu_storetype <= 2'b00;  // Byte by default
        cu_branch <= 1'b0;      // No by default
        cu_branchtype <= 3'b000; // BEQ by default
        cu_jump <= 1'b0;        // No by default

        case (opcode) 
            7'h33: begin    // R-type
                cu_rdwrite = 1'b1;
                case (funct3) 
                    3'h0:   // ADD/SUB operation with addition by default
                    begin
                        if (funct7 == 7'h20) // Substraction
                            cu_adtype <= 1'b1;
                    end

                    3'h1:   // SLL
                        cu_ALUtype <= 2'b10; // Shift operation

                    3'h2:   // SLT
                        cu_ALUtype <= 2'b11; // SLT operation

                    3'h3:   // SLTU
                    begin
                        cu_ALUtype <= 2'b11; // SLT operation
                        cu_sltype <= 1'b1;
                    end

                    3'h4:   // XOR
                        cu_ALUtype <= 2'b01; // Gate operation

                    3'h5:   // SR
                    begin
                        cu_ALUtype <= 2'b10; // Shift operation
                        if (funct7 == 7'h00)
                            cu_shiftype <= 2'b01; // SRL
                        if (funct7 == 7'h20)
                            cu_shiftype <= 2'b10; // SRA
                    end

                    3'h6:   // OR
                    begin
                        cu_ALUtype <= 2'b01; // Gate operation
                        cu_gatype <= 2'b01;
                    end

                    3'h7:   // AND
                    begin
                        cu_ALUtype <= 2'b01; // Gate operation
                        cu_gatype <= 2'b10;
                    end
                endcase
            end

            7'h13: begin    // I-type
                cu_ALU2src <= 1'b1;
                cu_rdwrite <= 1'b1;
                case (funct3)
                    3'h1:   // SLLI
                        cu_ALUtype <= 2'b10;

                    3'h2:   // SLTI
                        cu_ALUtype <= 2'b11;

                    3'h3:   // SLTIU
                    begin
                        cu_ALUtype <= 2'b11;
                        cu_sltype <= 1'b1;
                    end
                    
                    3'h4:   // XORI
                        cu_ALUtype <= 2'b01;

                    3'h5:   // SRLI/SRAI
                    begin
                        cu_ALUtype <= 2'b10;
                        if (funct7 == 7'h00)
                            cu_shiftype <= 2'b01;
                        if (funct7 == 7'h20)
                            cu_shiftype <= 2'b10;
                    end

                    3'h6:   // ORI
                    begin
                        cu_ALUtype <= 2'b01;
                        cu_gatype <= 2'b01;
                    end

                    3'h7:   // ANDI
                    begin
                        cu_ALUtype <= 2'b01;
                        cu_gatype <= 2'b10;
                    end
                endcase
            end

            7'h3: begin     // Load-type
                cu_ALU2src <= 1'b1;
                cu_rdtype <= 2'b01;  
                cu_rdwrite <= 1'b1;
                case (funct3)
                    3'h0:   // LB DEFAULTT
                        cu_loadtype <= 3'b000;

                    3'h1:   // LH
                        cu_loadtype <= 3'b001;

                    3'h2:   // LW
                        cu_loadtype <= 3'b010;

                    3'h4:   // LBU
                        cu_loadtype <= 3'b011;

                    3'h5:   // LHU
                        cu_loadtype <= 3'b100;
                endcase
            end

            7'h23: begin    // S-type
                cu_ALU2src <= 1'b1;
                cu_immtype <= 3'b001;
                cu_store <= 1'b1;
                case (funct3)
                    3'h0:   // SB DEFAULT
                        cu_storetype <= 2'b00;

                    3'h1:   // SH
                        cu_storetype <= 2'b01;

                    3'h2:   // SW
                        cu_storetype <= 2'b10;
                endcase
            end

            7'h63: begin    // B-type
                cu_ALU1src <= 1'b1;     
                cu_ALU2src <= 1'b1;     
                cu_immtype <= 3'b010;
                cu_branch <= 1'b1;
                case (funct3)
                    3'h0:   // BEQ DEFAULT
                        cu_branchtype <= 3'b000;

                    3'h1:   // BNE
                        cu_branchtype <= 3'b001;

                    3'h4:   // BLT
                        cu_branchtype <= 3'b010;
                    
                    3'h5:   // BGE
                        cu_branchtype <= 3'b011;

                    3'h6:   // BLTU
                        cu_branchtype <= 3'b100;
                    
                    3'h7:   // BGEU
                        cu_branchtype <= 3'b101;
                endcase
            end

            7'h17: begin    // AUIPC
                cu_ALU1src <= 1'b1;     
                cu_ALU2src <= 1'b1; 
                cu_immtype <= 3'b011;
                cu_rdwrite <= 1'b1;
            end

            7'h37: begin    // LUI
                cu_ALU2src <= 1'b1;
                cu_immtype <= 3'b011;
                cu_rdtype  <= 2'b11;
                cu_rdwrite <= 1'b1;
            end

            7'h6F: begin    // JAL
                cu_ALU1src <= 1'b1;     
                cu_ALU2src <= 1'b1;
                cu_immtype <= 3'b100;
                cu_rdtype  <= 2'b10;
                cu_rdwrite <= 1'b1;
                cu_jump    <= 1'b1;
            end

            7'h67: begin    // JALR
                cu_ALU2src <= 1'b1;
                cu_rdtype  <= 2'b10;
                cu_rdwrite <= 1'b1;
                cu_jump    <= 1'b1;
            end
        endcase
    end
endmodule