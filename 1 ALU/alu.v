`timescale 1ns / 100ps

module ALU(A,B,OP,C,Cout);

	input [15:0]A;
	input [15:0]B;
	input [3:0]OP;
	output [15:0]C;
	output Cout;

	//TODO
	reg [15:0]C, Cout, pB;
	
	always @ * begin
	Cout <= 0;

	case (OP)
		4'b0000: begin
			C <= A + B;
			Cout <= (~A[15])&(~B[15])&(C[15]) | (A[15])&(B[15])&(~C[15]);
		end
		4'b0001: begin
			C <= A - B;
			pB <= -B;
			Cout <= (~A[15])&(~pB[15])&(C[15]) | (A[15])&(pB[15])&(~C[15]);
		end
		4'b0010: C <= A & B;
		4'b0011: C <= A | B;
		4'b0100: C <= ~(A & B);
		4'b0101: C <= ~(A | B);
		4'b0110: C <= A ^ B;
		4'b0111: C <= ~(A ^ B);
		4'b1000: C <= A;
		4'b1001: C <= ~A;
		4'b1010: C <= A >> 1;
		4'b1011: C <= {A[15], A[15:1]};
		4'b1100: C <= {A[0], A[15:1]};
		4'b1101: C <= A << 1;
		4'b1110: C <= {A[14:0], A[0]};
		4'b1111: C <= {A[14:0], A[15]};
	endcase

	end	
endmodule

