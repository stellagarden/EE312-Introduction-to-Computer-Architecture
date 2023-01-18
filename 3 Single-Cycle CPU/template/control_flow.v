module control_flow(
    
    input wire [6:0] opcode,    //I_MEM_DI[6:0]
    input wire [2:0] funct3,    //I_MEM_DI[14:12]
    input wire [6:0] imm,       //I_MEM_DI[31:25]

    output reg RF_WE,          //Write-enable on Register FIle
    output reg D_MEM_WEN,      //Write-enable-negative on Data Memory
    output reg [3:0] D_MEM_BE,       //Byte-enable on Data Memory
    output reg [1:0] I_ext,          //1: Sign Exten, 2: Zero Exten
    output reg [4:0] ALU_cont,        //ALU control

    output reg [2:0] mux1,
    output reg [1:0] mux2,
    output reg mux3,
    output reg mux4
);

    always @(*) begin

        case (opcode)
            7'b0110111: begin   //LUI
                RF_WE = 1;
                D_MEM_WEN = 1;
                D_MEM_BE = 0;
                I_ext = 0;

                mux1 = 0;
                mux2 = 0;
                mux3 = 0;
                mux4 = 0;
            end
            7'b0010111: begin   //AUIPC
                RF_WE = 1;
                D_MEM_WEN = 1;
                D_MEM_BE = 0;
                I_ext = 0;

                mux1 = 1;
                mux2 = 0;
                mux3 = 0;
                mux4 = 0;
            end
            7'b1101111: begin   //JAL
                RF_WE = 1;
                D_MEM_WEN = 1;
                D_MEM_BE = 0;
                I_ext = 0;

                mux1 = 2;
                mux2 = 1;
                mux3 = 0;
                mux4 = 0;
            end
            7'b1100111: begin   //JALR
                RF_WE = 1;
                D_MEM_WEN = 1;
                D_MEM_BE = 0;
                I_ext = 0;

                mux1 = 2;
                mux2 = 3;
                mux3 = 0;
                mux4 = 0;
            end
            7'b1100011: begin   //B-type
                RF_WE = 0;
                D_MEM_WEN = 1;
                D_MEM_BE = 0;
                I_ext = 0;
                ALU_cont = 19;

                mux1 = 6;
                mux2 = 2;
                mux3 = 0;
                mux4 = 0;
            end
            7'b0000011: begin   //I-type Load
                RF_WE = 1;
                D_MEM_WEN = 1;

                case (funct3)
                    3'b000: begin   //LB
                        D_MEM_BE = 1;
                        I_ext = 1;
                    end
                    3'b001: begin   //LH
                        D_MEM_BE = 3;
                        I_ext = 1;
                    end
                    3'b010: begin   //LW
                        D_MEM_BE = 15;
                        I_ext = 0;
                    end
                    3'b100: begin   //LBU
                        D_MEM_BE = 1;
                        I_ext = 2;
                    end
                    3'b101: begin   //LHU
                        D_MEM_BE = 3;
                        I_ext = 2;
                    end
                endcase

                mux1 = 3;
                mux2 = 0;
                mux3 = 0;
                mux4 = 0;
            end
            7'b0100011: begin   //S-type
                RF_WE = 0;
                D_MEM_WEN = 0;
                I_ext = 0;
                case (funct3)
                    3'b000: D_MEM_BE = 1;   //SB
                    3'b001: D_MEM_BE = 3;   //SH
                    3'b010: D_MEM_BE = 15;   //SW
                endcase

                mux1 = 5;
                mux2 = 0;
                mux3 = 1;
                mux4 = 1;
            end
            7'b0010011: begin   //I-type
                RF_WE = 1;
                D_MEM_WEN = 1;
                D_MEM_BE = 0;
                I_ext = 0;
                
                case(funct3)
                    3'b000: ALU_cont = 0; //ADDI
                    3'b010: ALU_cont = 20; //SLTI
                    3'b011: ALU_cont = 21; //SLTIU
                    3'b100: ALU_cont = 6; //XORI
                    3'b110: ALU_cont = 3; //ORI
                    3'b111: ALU_cont = 2; //ANDI
                    3'b001: ALU_cont = 13; //SLLI
                    3'b101: begin
                        if (imm == 7'b0000000) ALU_cont = 10; //SRLI 
                        else if (imm == 7'b0100000) ALU_cont = 11; //SRAI 
                    end
                endcase

                mux1 = 4;
                mux2 = 0;
                mux3 = 0;
                mux4 = 1;
            end
            7'b0110011: begin   //R-type
                RF_WE = 1;
                D_MEM_WEN = 1;
                D_MEM_BE = 0;
                I_ext = 0;

                case(funct3)
                    3'b000: begin
                        if (imm == 7'b0000000) ALU_cont = 0; //ADD
                        else if (imm == 7'b0100000) ALU_cont = 1; //SUB
                    end 
                    3'b001: ALU_cont = 13; //SLL
                    3'b010: ALU_cont = 20; //SLT
                    3'b011: ALU_cont = 21; //SLTU
                    3'b100: ALU_cont = 6; //XOR
                    3'b101: begin
                        if (imm == 7'b0000000) ALU_cont = 10; //SRL
                        else if (imm == 7'b0100000) ALU_cont = 11; //SRA
                    end
                    3'b110: ALU_cont = 3; //OR
                    3'b111: ALU_cont = 2; //AND
                endcase

                mux1 = 4;
                mux2 = 0;
                mux3 = 0;
                mux4 = 0;
            end
            7'b0001011: begin   //MULT, MODULO, IS_EVEN
                RF_WE = 1;
                D_MEM_WEN = 1;
                D_MEM_BE = 0;
                I_ext = 0;
                
                case(funct3)
                    3'b111: begin
                        if (imm == 7'b0000000) ALU_cont = 16;   //MULT
                        else if (imm == 7'b0000001) ALU_cont = 17;  //MODULO
                    end
                    3'b110: ALU_cont = 18;  //IS_EVEN
                endcase

                mux1 = 4;
                mux2 = 0;
                mux3 = 0;
                mux4 = 0;
            end
        endcase

    end

endmodule
