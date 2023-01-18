module RISCV_TOP (
   //General Signals
   input wire CLK,
   input wire RSTn,

   //I-Memory Signals
   output wire I_MEM_CSN,
   input wire [31:0] I_MEM_DI,//input from IM
   output reg [11:0] I_MEM_ADDR,//in byte address

   //D-Memory Signals
   output wire D_MEM_CSN,
   input wire [31:0] D_MEM_DI,
   output wire [31:0] D_MEM_DOUT,
   output wire [11:0] D_MEM_ADDR,//in word address
   output wire D_MEM_WEN,
   output wire [3:0] D_MEM_BE,

   //RegFile Signals
   output wire RF_WE,
   output wire [4:0] RF_RA1,
   output wire [4:0] RF_RA2,
   output wire [4:0] RF_WA1,
   input wire [31:0] RF_RD1,
   input wire [31:0] RF_RD2,
   output wire [31:0] RF_WD,
   output wire HALT,
   output reg [31:0] NUM_INST,
   output wire [31:0] OUTPUT_PORT,
   output reg [31:0] IR,
   output reg [3:0] state,
   output reg [11:0] PC,
   output wire bcond
   );

   // TODO: implement multi-cycle CPU

   // Initialization
   parameter initial_state = 0;
   parameter IF  = 1;
   parameter ID  = 2;
   parameter EX  = 3;
   parameter MEM = 4;
   parameter WB  = 5;

   reg [31:0] target;
//    reg [11:0] PC;
   reg [31:0] rs1;
   reg [31:0] rs2;
//    reg [31:0] IR;
   reg [4:0] RF_RA1_reg, RF_RA2_reg, RF_WA1_reg;
   reg [31:0] RF_WD_reg;
   reg [31:0] A;
   reg [31:0] B;
   reg [31:0] D_MEM_DOUT_reg;
   reg [11:0] D_MEM_ADDR_reg;
//    reg [3:0] state;
   reg check_HALT;
   reg HALT_reg;

   wire [3:0] next_state;
   wire [4:0] ALU_cont;
   wire [2:0] mux1;
   wire [1:0] mux2;
   wire mux3;
   wire mux4;
   wire [31:0] ALU_out;
//    wire bcond;

   assign OUTPUT_PORT = RF_WD;
   assign I_MEM_CSN = ~RSTn;
   assign D_MEM_CSN = ~RSTn;
   // assign HALT = ((IR == 32'h00008067) || (IR == 32'h00c00093)) ? 1 : 0;
      //wire to register
   assign RF_RA1 = RF_RA1_reg;
   assign RF_RA2 = RF_RA2_reg;
   assign RF_WA1 = RF_WA1_reg;
   assign RF_WD = RF_WD_reg;
   assign D_MEM_DOUT = D_MEM_DOUT_reg;
   assign D_MEM_ADDR = D_MEM_ADDR_reg;
   assign HALT = HALT_reg;
   // Declare instance of the other module
   control_flow c1(RSTn,IR[6:0],IR[14:12],IR[31:25],state,next_state,
   RF_WE,D_MEM_WEN,D_MEM_BE,ALU_cont,mux1,mux2,mux3,mux4);

   ALU a1(RSTn,IR[14:12],ALU_cont,rs1,rs2,state,ALU_out,bcond);

   always @(posedge CLK) begin
      if (RSTn) state <= next_state;
   end
   always @(negedge CLK) begin
      if (RSTn) begin
         if (state == IF) I_MEM_ADDR <= PC;
         if (next_state == IF) NUM_INST <= NUM_INST + 1;
      end
   end

   always @(*) begin
      if (~RSTn) begin
         // Reset registers
         NUM_INST <= 0;
         RF_RA1_reg = 0;
         RF_RA2_reg = 0;
         RF_WD_reg = 0;
         D_MEM_DOUT_reg = 0;
         D_MEM_ADDR_reg = 0;
         I_MEM_ADDR = 0;
         NUM_INST = 0;
         target = 0;
         rs1 = 0;
         rs2 = 0;
         PC = 0;
         IR = 0;
         A = 0;
         B = 0;
         state = initial_state;
         HALT_reg = 0;
         check_HALT = 0;
      end 
      else begin
         case (state)
            IF: IR = I_MEM_DI;
            ID: begin
               if (IR == 32'h00c00093) check_HALT = 1;
               else if (IR == 32'h00008067 && check_HALT == 1) HALT_reg = 1;
               PC = I_MEM_ADDR + 4;
               RF_RA1_reg = IR[19:15];
               RF_RA2_reg = IR[24:20];
               RF_WA1_reg = IR[11:7];
               A = RF_RD1;
               B = RF_RD2;
               // B,J type: Set target
               case (mux2)
                  1: target = I_MEM_ADDR + {{11{IR[31]}},IR[31],IR[19:12],IR[20],IR[30:21],1'b0};      // JAL
                  2: target = I_MEM_ADDR + {{19{IR[31]}},IR[31],IR[7],IR[30:25],IR[11:8],1'b0};      // B type
                  3: target = (RF_RD1 + {{20{IR[31]}},IR[31:20]}) & 32'hfffffffe;                  // JALR
               endcase
            end
            EX: begin
               rs1 = A;
               if (mux4) rs2 = {{20{IR[31]}},IR[31:20]};
               else rs2 = B;
               // ALU works //
               case (mux2)
                  1: PC = target;
                  2: if (bcond) PC = target;
                  //////////////////////
                  3: PC = target;
                  //////////////////////
               endcase
               if (mux1 == 6) RF_WD_reg = (bcond) ? 1 : 0;
            end
            MEM: begin
               D_MEM_DOUT_reg = B;
               D_MEM_ADDR_reg = (mux3) ? ((A + {{20{IR[31]}},IR[31:25],IR[11:7]}) & 16'h3FFF) : ((A + {{20{IR[31]}},IR[31:20]}) & 16'h3FFF);   // D_MEM_ADDR [13:2] 없애도 에러 안 뜨길래 그냥 한 줄로 바꿔버림
               if (mux1 == 5 && mux3 == 1) RF_WD_reg = (A + {{20{IR[31]}},IR[31:25],IR[11:7]}) & 16'h3FFF;
            end
            WB: begin
               case (mux1)
                  2: RF_WD_reg = I_MEM_ADDR + 4;
                  3: if (D_MEM_BE==4'b1111) RF_WD_reg = D_MEM_DI[31:0];
                  4: RF_WD_reg = ALU_out;
               endcase
            end
         endcase
      end
   end
endmodule //