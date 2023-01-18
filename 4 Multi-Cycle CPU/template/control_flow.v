module control_flow(
    
    input wire RSTn,
    input wire [6:0] opcode,    //I_MEM_DI[6:0]
    input wire [2:0] funct3,    //I_MEM_DI[14:12]
    input wire [6:0] imm,       //I_MEM_DI[31:25]
    input wire [3:0] state,

    output reg [3:0] next_state,
    output reg RF_WE,          //Write-enable on Register FIle
    output reg D_MEM_WEN,      //Write-enable-negative on Data Memory
    output reg [3:0] D_MEM_BE,       //Byte-enable on Data Memory
    output reg [4:0] ALU_cont,        //ALU control

    output reg [2:0] mux1,
    output reg [1:0] mux2,
    output reg mux3,
    output reg mux4
);
	parameter IF  = 1;
	parameter ID  = 2;
	parameter EX  = 3;
	parameter MEM = 4;
	parameter WB  = 5;

    always @(*) begin
        if (~RSTn) begin
            next_state = IF;
            RF_WE = 0;
            D_MEM_WEN = 0;
            D_MEM_BE = 0;
            ALU_cont = 0;
            mux1 = 0;
            mux2 = 0;
            mux3 = 0;
            mux4 = 0;
        end else begin
            case (opcode)
                7'b1101111: begin   //JAL
                    RF_WE = 0;
                    D_MEM_WEN = 1;
                    D_MEM_BE = 0;

                    case (state)
                        IF: next_state = ID;
                        ID: next_state = EX;
                        EX: next_state = WB;
                        WB: begin next_state = IF; RF_WE = 1; end
                    endcase

                    mux1 = 2;
                    mux2 = 1;
                    mux3 = 0;
                    mux4 = 0;
                end
                7'b1100111: begin   //JALR
                    RF_WE = 0;
                    D_MEM_WEN = 1;
                    D_MEM_BE = 0;

                    case (state)
                        IF: next_state = ID;
                        ID: next_state = EX;
                        EX: next_state = WB;
                        WB: begin next_state = IF; RF_WE = 1; end
                    endcase

                    mux1 = 2;
                    mux2 = 3;
                    mux3 = 0;
                    mux4 = 0;
                end
                7'b1100011: begin   //B-type
                    RF_WE = 0;
                    D_MEM_WEN = 1;
                    D_MEM_BE = 0;

                    case (state)
                        IF: next_state = ID;
                        ID: next_state = EX;
                        EX: begin ALU_cont = 11; next_state = IF; end   // ALU_cont = 11을 EX 안으로 옮기니까 branch false일 때 잘 작동!
                    endcase

                    mux1 = 6;
                    mux2 = 2;
                    mux3 = 0;
                    mux4 = 0;
                end
                7'b0000011: begin   //I-type Load (LW)
                    RF_WE = 0;
                    D_MEM_WEN = 1;
                    if (funct3 == 3'b010) D_MEM_BE = 15;

                    case (state)
                        IF: next_state = ID;
                        ID: next_state = EX;
                        EX: next_state = MEM;
                        MEM: next_state = WB;
                        WB: begin next_state = IF; RF_WE = 1; end
                    endcase

                    mux1 = 3;
                    mux2 = 0;
                    mux3 = 0;
                    mux4 = 1;
                end
                7'b0100011: begin   //S-type (SW)
                    RF_WE = 0;
                    D_MEM_WEN = 1;
                    if (funct3 == 3'b010) D_MEM_BE = 15;   //SW

                    case (state)
                        IF: next_state = ID;
                        ID: next_state = EX;
                        EX: next_state = MEM;
                        MEM: begin next_state = IF; D_MEM_WEN = 0; end
                    endcase

                    mux1 = 5;
                    mux2 = 0;
                    mux3 = 1;
                    mux4 = 1;
                end
                7'b0010011: begin   //I-type
                    RF_WE = 0;
                    D_MEM_WEN = 1;
                    D_MEM_BE = 0;
                    
                    case (state)
                        IF: next_state = ID;
                        ID: next_state = EX;
                        EX: begin
                            next_state = WB;
                            case(funct3)
                                3'b000: ALU_cont = 0; //ADDI
                                3'b010: ALU_cont = 12; //SLTI
                                3'b011: ALU_cont = 13; //SLTIU
                                3'b100: ALU_cont = 4; //XORI
                                3'b110: ALU_cont = 3; //ORI
                                3'b111: ALU_cont = 2; //ANDI
                                3'b001: ALU_cont = 7; //SLLI
                                3'b101: begin
                                    if (imm == 7'b0000000) ALU_cont = 5; //SRLI 
                                    else if (imm == 7'b0100000) ALU_cont = 6; //SRAI 
                                end
                            endcase
                        end
                        WB: begin next_state = IF; RF_WE = 1; end
                    endcase

                    mux1 = 4;
                    mux2 = 0;
                    mux3 = 0;
                    mux4 = 1;
                end
                7'b0110011: begin   //R-type
                    RF_WE = 0;
                    D_MEM_WEN = 1;
                    D_MEM_BE = 0;

                    case (state)
                        IF: next_state = ID;
                        ID: next_state = EX;
                        EX: begin
                            next_state = WB;
                            case(funct3)
                                3'b000: begin
                                    if (imm == 7'b0000000) ALU_cont = 0; //ADD
                                    else if (imm == 7'b0100000) ALU_cont = 1; //SUB
                                end 
                                3'b001: ALU_cont = 7; //SLL
                                3'b010: ALU_cont = 12; //SLT
                                3'b011: ALU_cont = 13; //SLTU
                                3'b100: ALU_cont = 4; //XOR
                                3'b101: begin
                                    if (imm == 7'b0000000) ALU_cont = 5; //SRL
                                    else if (imm == 7'b0100000) ALU_cont = 6; //SRA
                                end
                                3'b110: ALU_cont = 3; //OR
                                3'b111: ALU_cont = 2; //AND
                            endcase
                        end
                        WB: begin next_state = IF; RF_WE = 1; end
                    endcase

                    mux1 = 4;
                    mux2 = 0;
                    mux3 = 0;
                    mux4 = 0;
                end
                7'b0001011: begin   //MULT, MODULO, IS_EVEN
                    RF_WE = 0;
                    D_MEM_WEN = 1;
                    D_MEM_BE = 0;
                    
                    case (state)
                        IF: next_state = ID;
                        ID: next_state = EX;
                        EX: begin
                            next_state = WB;
                            case(funct3)
                                3'b111: begin
                                    if (imm == 7'b0000000) ALU_cont = 8;   //MULT
                                    else if (imm == 7'b0000001) ALU_cont = 9;  //MODULO
                                end
                                3'b110: ALU_cont = 10;  //IS_EVEN
                            endcase
                        end
                        WB: begin next_state = IF; RF_WE = 1; end
                    endcase

                    mux1 = 4;
                    mux2 = 0;
                    mux3 = 0;
                    mux4 = 0;
                end
            endcase
        end
    end

endmodule
