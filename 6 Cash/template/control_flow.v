module control_flow(
    input wire RSTn,
    input wire [31:0] FD_IR,

    output reg RF_WE,
    output reg D_MEM_WEN,
    output reg [3:0] D_MEM_BE,
    output reg [4:0] ALU_cont,
    output reg [1:0] m_imm,
    output reg m_ALU_in1,
    output reg m_ALU_in2,
    output reg [1:0] m_WD,
    output reg [1:0] m_target
);

    reg [6:0] opcode;
    reg [2:0] func3;
    reg [6:0] func2;

    assign opcode = FD_IR[6:0];
    assign func3 = FD_IR[14:12];
    assign func2 = FD_IR[31:25];

    always @(*) begin
        if (~RSTn) begin
            RF_WE = 0;
            D_MEM_WEN = 1;
            D_MEM_BE = 15;
            ALU_cont = 0;
            m_imm = 0;
            m_ALU_in1 = 0;
            m_ALU_in2 = 0;
            m_WD = 0;
            m_target = 0;
        end
        else begin
            //RF_WE
            case (opcode)
                7'b1100011: RF_WE = 0; //Branch
                7'b0100011: RF_WE = 0; //SW
                default: RF_WE = 1;
            endcase
            //D_MEM_WEN
            case (opcode)
                7'b0100011: D_MEM_WEN = 0; //SW
                default: D_MEM_WEN = 1;
            endcase
            //D_MEM_BE
            D_MEM_BE = 15;
            //ALU_cont
            case (opcode)
                7'b1101111: ALU_cont = 0; //JAL
                7'b1100111: ALU_cont = 0; //JALR
                7'b1100011: begin //Branch
                    case (func3)
                        3'b000: ALU_cont = 13; //BEQ
                        3'b001: ALU_cont = 14; //BNE
                        3'b100: ALU_cont = 15; //BLT
                        3'b101: ALU_cont = 16; //BGE
                        3'b110: ALU_cont = 17; //BLTU
                        3'b111: ALU_cont = 18; //BGEU
                    endcase
                end
                7'b0000011: ALU_cont = 0; //LW
                7'b0100011: ALU_cont = 0; //SW
                7'b0010011: begin //I-type
                    case(func3)
                        3'b000: ALU_cont = 0; //ADDI
                        3'b010: ALU_cont = 11; //SLTI
                        3'b011: ALU_cont = 12; //SLTIU
                        3'b100: ALU_cont = 4; //XORI
                        3'b110: ALU_cont = 3; //ORI
                        3'b111: ALU_cont = 2; //ANDI
                        3'b001: ALU_cont = 7; //SLLI
                        3'b101: begin
                            if (func2 == 7'b0000000) ALU_cont = 5; //SRLI 
                            else if (func2 == 7'b0100000) ALU_cont = 6; //SRAI 
                        end
                    endcase
                end
                7'b0110011: begin //R-type
                    case(func3)
                        3'b000: begin
                            if (func2 == 7'b0000000) ALU_cont = 0; //ADD
                            else if (func2 == 7'b0100000) ALU_cont = 1; //SUB
                        end 
                        3'b001: ALU_cont = 7; //SLL
                        3'b010: ALU_cont = 11; //SLT
                        3'b011: ALU_cont = 12; //SLTU
                        3'b100: ALU_cont = 4; //XOR
                        3'b101: begin
                            if (func2 == 7'b0000000) ALU_cont = 5; //SRL
                            else if (func2 == 7'b0100000) ALU_cont = 6; //SRA
                        end
                        3'b110: ALU_cont = 3; //OR
                        3'b111: ALU_cont = 2; //AND
                    endcase
                end
                7'b0001011: begin //R-custom
                    case(func3)
                        3'b111: begin
                            if (func2 == 7'b0000000) ALU_cont = 8;   //MULT
                            else if (func2 == 7'b0000001) ALU_cont = 9;  //MODULO
                        end
                        3'b110: ALU_cont = 10;  //IS_EVEN
                    endcase
                end
            endcase
            //m_imm
            case (opcode)
                7'b1101111: m_imm = 0;  //JAL
                7'b1100111: m_imm = 1;  //JALR
                7'b1100011: m_imm = 2;  //Branch
                7'b0000011: m_imm = 1;  //LW
                7'b0100011: m_imm = 3;  //SW
                7'b0010011: m_imm = 1;  //I-type
            endcase
            //m_ALU_in1
            case (opcode)
                7'b1101111: m_ALU_in1 = 0;  //JAL
                default: m_ALU_in1 = 1; //others
            endcase
            //m_ALU_in2
            case (opcode)
                7'b1101111: m_ALU_in2 = 0;  //JAL
                7'b1100111: m_ALU_in2 = 0;  //JALR
                7'b0000011: m_ALU_in2 = 0;  //LW
                7'b0100011: m_ALU_in2 = 0;  //SW
                7'b0010011: m_ALU_in2 = 0;  //I-type
                default: m_ALU_in2 = 1; //Branch, R-type, R-custom
            endcase
            //m_WD
            case (opcode)
                7'b1101111: m_WD = 0;   //JAL
                7'b1100111: m_WD = 0;   //JALR
                7'b0000011: m_WD = 1;   //LW
                default: m_WD = 2;  //others
            endcase
            //m_target
            case (opcode)
                7'b1101111: m_target = 1;   //JAL
                7'b1100111: m_target = 2;   //JALR
                7'b1100011: m_target = 3;   //Branch
                default: m_target = 0;
            endcase
        end
    end
endmodule