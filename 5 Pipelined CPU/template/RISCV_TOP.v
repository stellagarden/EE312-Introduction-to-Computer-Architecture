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

	output reg [31:0] FD_IR,
	output reg [31:0] DE_IR,
	output reg [31:0] EM_IR,
	output reg [31:0] MW_IR,
	output wire [31:0] ALU_out,
	output reg [31:0] ALU_in1,
	output reg [31:0] ALU_in2,
	output wire LoadDelaySlot,
	output wire [1:0] ForwardA,
	output wire [1:0] ForwardB,
	output reg [31:0] DE_imm,
	output reg DE_ALU_in1,
	output reg DE_ALU_in2,
	output reg [1:0] MW_WD,
	output wire [1:0] ForwardC,
	output wire [1:0] ForwardD,
	output wire [1:0] ForwardE,
	output reg [31:0] EM_ALU_out,
	output reg [31:0] MW_ALU_out,
	output reg [31:0] DE_RD1,
	output reg [31:0] DE_RD2,
	output reg [31:0] EM_RD2,
	output reg [1:0] DE_target,
	output reg flag_HALT,
	output reg [11:0] next_PC,
	output reg jumped,
	output reg [12:0] i,
	output reg [12:0] j,
	output reg predict,
	output reg FD_predict,
	output reg DE_predict
	);

	// TODO: implement pipeline CPU

	//// Declare variables ////
	// Data Flow
	// reg [31:0] FD_IR,DE_IR,EM_IR,MW_IR;		// I_MEM_DI
	// reg [11:0] next_PC;
	reg [11:0] FD_PC,DE_PC,EM_PC,MW_PC;		// PC (I_MEM_ADDR)
	reg [4:0] DE_RA1,DE_RA2,EM_RA2;
	// reg [31:0] DE_RD1,DE_RD2,EM_RD2;		// RF_RD
	reg [4:0] DE_WA,EM_WA,MW_WA;			// RF_WA
	reg [31:0] MW_MEM_out;
	// wire [31:0] ALU_out;
	// reg [31:0] EM_ALU_out,MW_ALU_out;	// custom
	// reg [31:0] DE_imm, ALU_in1,ALU_in2;
	// reg predict,FD_predict,DE_predict;
	// reg jumped;
	reg EM_jumped,MW_jumped;
	// wire LoadDelaySlot;
	// Control Flow
	wire ID_WE;
	reg DE_WE,EM_WE,MW_WE;
	wire ID_WEN;
	reg DE_WEN,EM_WEN;
	wire [3:0] ID_BE;
	reg [3:0] DE_BE,EM_BE;
	wire [4:0] ALU_cont;
	reg [4:0] DE_ALU_cont;
	wire [1:0] m_imm;
	wire m_ALU_in1;
	// reg DE_ALU_in1;
	wire m_ALU_in2;
	// reg DE_ALU_in2;
	wire [1:0] m_WD;
	reg [1:0] DE_WD,EM_WD;
	// reg [1:0] MW_WD;
	wire [1:0] m_target;
	// reg [1:0] DE_target;
	// reg flag_HALT;
	reg first_inst;
	// wire [1:0] ForwardA,ForwardB;
	// wire [1:0] ForwardC,ForwardD,ForwardE;
	// wire-to-reg
	reg [31:0] D_MEM_DOUT_reg;
	reg [11:0] D_MEM_ADDR_reg;
	reg [31:0] RF_WD_reg;
	reg HALT_reg;
	reg [11:0] BTB [0:4095];
	reg [1:0] BHT [0:4095];

	//// Assign ////
	assign I_MEM_CSN = ~RSTn;
	assign D_MEM_CSN = ~RSTn;
	assign D_MEM_DOUT = D_MEM_DOUT_reg;
	assign D_MEM_ADDR = D_MEM_ADDR_reg;
	assign D_MEM_WEN = EM_WEN;
	assign D_MEM_BE = EM_BE;

	assign RF_WE = MW_WE;
	assign RF_RA1 = FD_IR[19:15];
	assign RF_RA2 = FD_IR[24:20];
	assign RF_WA1 = MW_WA;
	assign RF_WD = RF_WD_reg;
	assign HALT = HALT_reg;
	assign OUTPUT_PORT = RF_WD;

	// Reset BTB
	// reg [12:0] i;
	// reg [12:0] j;
	reg flag_reset;
	always @(*) begin
		if (~RSTn) begin
			flag_reset = 1;
			i = 0;
			j = 0;
			if (flag_reset) begin
				for (i = 0; i < 4096; i = i + 1) BTB[i] = 0;
				for (j = 0; j < 4096; j = j + 1) BHT[j] = 2'b11;
				flag_reset = 0;
			end
			
		end
	end

	//// Connect Modules ////
	control_flow c1(RSTn,FD_IR,ID_WE,ID_WEN,ID_BE,ALU_cont,m_imm,m_ALU_in1,m_ALU_in2,m_WD,m_target);
	alu a1(RSTn,DE_ALU_cont,ALU_in1,ALU_in2,ALU_out);
	forwarding_unit f1(RSTn,RF_RA1,RF_RA2,DE_WA,EM_WA,MW_WA,DE_WE,EM_WE,MW_WE,EM_IR,DE_IR,DE_RA1,DE_RA2,EM_RA2,ForwardA,ForwardB,ForwardC,ForwardD,ForwardE,LoadDelaySlot);

	//// Main ////
	always @(posedge CLK) begin
		if (RSTn) begin
			if (~LoadDelaySlot) begin
				// IF //
				first_inst <= 1;
				if (first_inst) begin
					FD_IR <= I_MEM_DI;
					FD_PC <= I_MEM_ADDR;
					I_MEM_ADDR <= next_PC;
					FD_predict <= predict;
				end
				
				// ID //
				case (m_imm)
					0: DE_imm <= {{11{FD_IR[31]}},FD_IR[31],FD_IR[19:12],FD_IR[20],FD_IR[30:21],1'b0};
					1: DE_imm <= {{20{FD_IR[31]}},FD_IR[31:20]};
					2: DE_imm <= {{19{FD_IR[31]}},FD_IR[31],FD_IR[7],FD_IR[30:25],FD_IR[11:8],1'b0};
					3: DE_imm <= {{20{FD_IR[31]}},FD_IR[31:25],FD_IR[11:7]};
				endcase
				DE_IR <= FD_IR;
				DE_PC <= FD_PC;
				DE_WE <= ID_WE;
				DE_WEN <= ID_WEN;
				DE_BE <= ID_BE;
				DE_ALU_cont <= ALU_cont;
				DE_ALU_in1 <= m_ALU_in1;
				DE_ALU_in2 <= m_ALU_in2;
				DE_WD <= m_WD;
				DE_target <= m_target;
				DE_RA1 <= RF_RA1;
				DE_RA2 <= RF_RA2;
				DE_WA <= FD_IR[11:7];
				DE_predict <= FD_predict;
				if (ForwardA) begin
					case (MW_WD)
						0: DE_RD1 <= MW_PC + 4;
						1: DE_RD1 <= MW_MEM_out;
						2: DE_RD1 <= MW_ALU_out;
					endcase
				end else DE_RD1 <= RF_RD1;
				if (ForwardB) begin
					case (MW_WD)
						0: DE_RD2 <= MW_PC + 4;
						1: DE_RD2 <= MW_MEM_out;
						2: DE_RD2 <= MW_ALU_out;
					endcase
				end else DE_RD2 <= RF_RD2;
			end else begin
				DE_IR <= 32'h00000013;
				DE_PC <= 0;
				DE_RA1 <= 0;
				DE_RA2 <= 0;
				DE_RD1 <= 0;
				DE_RD2 <= 0;
				DE_ALU_in1 <= 0;
				DE_ALU_in2 <= 0;
				DE_ALU_cont <= 0;
				DE_WA <= 0;
				DE_WE <= 0;
				DE_WEN <= 1;
				DE_BE <= 0;
				DE_WD <= 0;
				DE_target <= 0;
				DE_predict <= 0;
				// But if jump,
				if (DE_target == 1 || DE_target == 2 || (DE_target == 3 && ALU_out == 1)) begin
					// IF //
					I_MEM_ADDR <= next_PC;
				end
			end

			// EX //
			EM_IR <= DE_IR;
			EM_PC <= DE_PC;
			EM_jumped <= jumped;
			EM_RA2 <= DE_RA2;
			if (ForwardD) begin
				case (MW_WD)
					0: EM_RD2 <= MW_PC + 4;
					1: EM_RD2 <= MW_MEM_out;
					2: EM_RD2 <= MW_ALU_out;
				endcase
			end else EM_RD2 <= DE_RD2;
			EM_ALU_out <= ALU_out;
			EM_WA <= DE_WA;
			EM_WE <= DE_WE;
			EM_WEN <= DE_WEN;
			EM_BE <= DE_BE;
			EM_WD <= DE_WD;
			// Update BTB
			jumped <= (DE_target == 1 || DE_target == 2 || (DE_target == 3 && ALU_out == 1)) ? 1 : 0;
			case (DE_target)
				1: 	if (~DE_predict) begin
						BTB[DE_PC] <= ALU_out;
						FD_IR <= 32'h00000013;
						FD_PC <= 0;
					end
				2: 	if (~DE_predict) begin
						BTB[DE_PC] <= ALU_out & 32'hfffffffe;
						FD_IR <= 32'h00000013;
						FD_PC <= 0;
					end				
				3: begin
					if (ALU_out == 1) begin
						if (~DE_predict) begin
							BTB[DE_PC] <= DE_PC + DE_imm;
							if (BHT[DE_PC] != 2'b11) BHT[DE_PC] = BHT[DE_PC] + 1;
							FD_IR <= 32'h00000013;
							FD_PC <= 0;
						end else begin
							if (BHT[DE_PC] != 2'b11) BHT[DE_PC] = BHT[DE_PC] + 1;
						end
					end else begin
						if (~DE_predict) begin
							if (BHT[DE_PC] != 2'b00) BHT[DE_PC] = BHT[DE_PC] - 1;
						end else begin
							FD_IR <= 32'h00000013;
							DE_IR <= 32'h00000013;
							FD_PC <= 0;
							DE_PC <= 0;
							if (BHT[DE_PC] != 2'b00) BHT[DE_PC] = BHT[DE_PC] - 1;
						end
					end
				end
			endcase

			// MEM //
			MW_MEM_out <= D_MEM_DI;
			MW_IR <= EM_IR;
			MW_PC <= EM_PC;
			MW_jumped <= EM_jumped;
			MW_ALU_out <= EM_ALU_out;
			MW_WA <= EM_WA;
			MW_WE <= EM_WE;
			MW_WD <= EM_WD;
			if (EM_IR != 32'h00000013 && ~EM_jumped) NUM_INST <= NUM_INST + 1;
			if (EM_IR == 32'h00c00093) flag_HALT <= 1;
			else if (EM_IR == 32'h00008067 && flag_HALT == 1) HALT_reg <= 1;

			// WB //
		end
	end

	always @(*) begin
		if (~RSTn) begin
			// Reset all registers
			I_MEM_ADDR = 0;
			next_PC = 0;
			FD_PC = 0;
			DE_PC = 0;
			EM_PC = 0;
			MW_PC = 0;
			NUM_INST = 0;
			FD_IR=32'h00000013;
			DE_IR=32'h00000013;
			EM_IR=32'h00000013;
			MW_IR=32'h00000013;
			DE_RA1=0;
			DE_RA2=0;
			EM_RA2=0;
			DE_RD1=0;
			DE_RD2=0;
			EM_RD2=0;
			DE_WA=0;
			EM_WA=0;
			MW_WA=0;
			DE_imm=0;
			ALU_in1=0;
			ALU_in2=0;
			EM_ALU_out=0;
			MW_ALU_out=0;
			jumped=0;
			EM_jumped=0;
			MW_jumped=0;
			DE_WE=0;
			EM_WE=0;
			MW_WE=0;
			DE_WEN=1;
			EM_WEN=1;
			DE_BE=0;
			EM_BE=0;
			EM_WD=0;
			MW_WD=0;
			flag_HALT=0;
			first_inst=0;
			D_MEM_DOUT_reg=0;
			D_MEM_ADDR_reg=0;
			RF_WD_reg=0;
			HALT_reg=0;
		end else begin
			// Set ALU_in1
			if (DE_ALU_in1)
				case (ForwardC)
					// forward data from the MEM stage instruction
					1: case (EM_WD)
						0: ALU_in1 = EM_PC + 4;
						1: ALU_in1 = D_MEM_DI;
						2: ALU_in1 = EM_ALU_out;
					endcase
					// forward data from the WB stage instruction
					2: case (MW_WD)
						0: ALU_in1 = MW_PC + 4;
						1: ALU_in1 = MW_MEM_out;
						2: ALU_in1 = MW_ALU_out;
					endcase
					default: ALU_in1 = DE_RD1;
				endcase
			else ALU_in1 = DE_PC;

			// Set ALU_in2
			if (DE_ALU_in2)
				case (ForwardD)
					// forward data from the MEM stage instruction
					1: case (EM_WD)
						0: ALU_in2 = EM_PC + 4;
						1: ALU_in2 = D_MEM_DI;
						2: ALU_in2 = EM_ALU_out;
					endcase
					// forward data from the WB stage instruction
					2: case (MW_WD)
						0: ALU_in2 = MW_PC + 4;
						1: ALU_in2 = MW_MEM_out;
						2: ALU_in2 = MW_ALU_out;
					endcase
					default: ALU_in2 = DE_RD2;
				endcase
			else ALU_in2 = DE_imm;

			// Set RF_WD
			case (MW_WD)
				0: RF_WD_reg = MW_PC + 4;
				1: RF_WD_reg = MW_MEM_out;
				2: RF_WD_reg = MW_ALU_out;
			endcase

			// Set MEM
			D_MEM_ADDR_reg = EM_ALU_out;
			if (ForwardE) begin
				case (MW_WD)
					0: D_MEM_DOUT_reg = MW_PC + 4;
					1: D_MEM_DOUT_reg = MW_MEM_out;
					2: D_MEM_DOUT_reg = MW_ALU_out;
				endcase
			end else D_MEM_DOUT_reg = EM_RD2;

			// Set next_PC
			// Intercept at ID stage
			if (FD_predict) begin next_PC = BTB[FD_PC]; predict = 0; end
			// Intercept at EX stage
			else if (DE_target == 1 && ~DE_predict) next_PC = ALU_out;
			else if (DE_target == 2 && ~DE_predict) next_PC = ALU_out & 32'hfffffffe;
			else if (DE_target == 3 && ~DE_predict && ALU_out == 1) next_PC = DE_PC + DE_imm;
			else if (DE_target == 3 && DE_predict && ALU_out == 0) next_PC = DE_PC + 4;
			// Update at IF stage
			else if (BTB[I_MEM_ADDR] == 0 || BHT[I_MEM_ADDR] < 2) begin next_PC = I_MEM_ADDR + 4; predict = 0; end
			else begin
				next_PC = I_MEM_ADDR + 4; predict = 1;
			end

		end
	end

endmodule //
