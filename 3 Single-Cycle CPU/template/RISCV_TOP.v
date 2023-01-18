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
   output wire HALT,                   // if set, terminate program
   output reg [31:0] NUM_INST,         // number of instruction completed
   output wire [31:0] OUTPUT_PORT      // equal RF_WD this port is used for test
   );

   assign OUTPUT_PORT = RF_WD;

   initial begin
      NUM_INST <= 0;
   end

   // Only allow for NUM_INST
   always @ (negedge CLK) begin
      if (RSTn) NUM_INST <= NUM_INST + 1;
   end

   // TODO: implement
   
   // Initialization
   reg [31:0] target;
   reg [31:0] rs2;
   reg [11:0] PC;
   reg [31:0] RF_WD_reg;
   wire [31:0] rs1;
   wire [1:0] I_ext;
   wire [4:0] ALU_cont;
   wire [2:0] mux1;
   wire [1:0] mux2;
   wire mux3;
   wire mux4;
   wire [31:0] ALU_out;
   wire bcond;
   wire [13:0] D_MEM_ADDR_before;
   assign I_MEM_CSN = ~RSTn;
   assign D_MEM_CSN = ~RSTn;
   assign RF_RA1 = I_MEM_DI[19:15];
   assign RF_RA2 = I_MEM_DI[24:20];
   // assign RF_WA1 = (I_MEM_DI[6:0] == 7'b1101111 || I_MEM_DI[6:0] == 7'b1100111) ? 1'b1 : I_MEM_DI[11:7];
   assign RF_WA1 = I_MEM_DI[11:7];
   assign D_MEM_DOUT =  RF_RD2;
   assign rs1 = RF_RD1;
   assign HALT = ((I_MEM_DI == 32'h00008067) && (RF_RD1 == 32'h0000000c)) ? 1 : 0;
   assign D_MEM_ADDR_before = (mux3) ? ((RF_RD1 + {{20{I_MEM_DI[31]}},I_MEM_DI[31:25],I_MEM_DI[11:7]}) & 16'h3FFF) : ((RF_RD1 + {{20{I_MEM_DI[31]}},I_MEM_DI[31:20]}) & 16'h3FFF);
   assign D_MEM_ADDR = D_MEM_ADDR_before[13:2];
   assign RF_WD = RF_WD_reg;

   // Declare instance of the other module
   control_flow c1(I_MEM_DI[6:0],I_MEM_DI[14:12],I_MEM_DI[31:25],
   RF_WE,D_MEM_WEN,D_MEM_BE,I_ext,ALU_cont,mux1,mux2,mux3,mux4);

   ALU a1(I_MEM_DI[14:12],ALU_cont,rs1,rs2,ALU_out,bcond);

   
   always @(negedge CLK) begin
      I_MEM_ADDR <= PC;
   end

   always @(*) begin
   if (~RSTn) begin
         // Reset registers
         I_MEM_ADDR = 0;
         NUM_INST = 0;
         target = 0;
         rs2 = 0;
         PC = 0;
         RF_WD_reg = 0;
      end
      else begin
         // Update PC
         if (NUM_INST)
            case (mux2)
               0: PC = I_MEM_ADDR + 4;
               1: PC = I_MEM_ADDR + target;
               2: begin
                  if (bcond) PC = I_MEM_ADDR + target;
                  else PC = I_MEM_ADDR + 4;
               end
               3: PC = target;
               // default: PC = I_MEM_ADDR;
            endcase
end
   end

   always @(*) begin
      if (RSTn) begin

         // B,J type: Set target
         case (mux2)
            1: target = {{11{I_MEM_DI[31]}},I_MEM_DI[31],I_MEM_DI[19:12],I_MEM_DI[20],I_MEM_DI[30:21],1'b0};   // JAL
            2: target = {{19{I_MEM_DI[31]}},I_MEM_DI[31],I_MEM_DI[7],I_MEM_DI[30:25],I_MEM_DI[11:8],1'b0};      // B type
            3: target = (RF_RD1 + {{20{I_MEM_DI[31]}},I_MEM_DI[31:20]}) & 32'hfffffffe;            // JALR
         endcase

         case (mux1)
            0: RF_WD_reg = {I_MEM_DI[31:12],12'b0000_0000_0000};
            1: RF_WD_reg = I_MEM_ADDR + {I_MEM_DI[31:12],12'b0000_0000_0000};
            2: RF_WD_reg = I_MEM_ADDR + 4;
            3: case (D_MEM_BE)
                  4'b0001: begin
                     if (I_ext == 1) RF_WD_reg = {{24{D_MEM_DI[7]}},D_MEM_DI[7:0]};
                     else if (I_ext == 2) RF_WD_reg = {24'b0000_0000_0000_0000_0000_0000,D_MEM_DI[7:0]};
                  end
                  4'b0011: begin
                     if (I_ext == 1) RF_WD_reg = {{16{D_MEM_DI[15]}},D_MEM_DI[15:0]};
                     else if (I_ext == 2) RF_WD_reg = {16'b0000_0000_0000_0000,D_MEM_DI[15:0]};
                  end
                  4'b1111: RF_WD_reg = D_MEM_DI[31:0];
               endcase
            4: RF_WD_reg = ALU_out;
            5: RF_WD_reg = (mux3) ? ((RF_RD1 + {{20{I_MEM_DI[31]}},I_MEM_DI[31:25],I_MEM_DI[11:7]}) & 16'h3FFF) : ((RF_RD1 + {{20{I_MEM_DI[31]}},I_MEM_DI[31:20]}) & 16'h3FFF);
            6: RF_WD_reg = (bcond) ? 1 : 0;
         endcase
         
         if (mux4) rs2 = {{20{I_MEM_DI[31]}},I_MEM_DI[31:20]};
         else rs2 = RF_RD2;
      end
   end
endmodule //
