module alu(
    input wire RSTn,
    input reg [4:0] ALU_cont,
    input wire [31:0] rs1,
    input wire [31:0] rs2,

    output reg [31:0] ALU_out
);

    always @(*) begin
        if (~RSTn) begin
            ALU_out = 0;
        end
        else begin
            case (ALU_cont)
                0: ALU_out = rs1 + rs2;
                1: ALU_out = rs1 - rs2;
                2: ALU_out = rs1 & rs2;
                3: ALU_out = rs1 | rs2;
                4: ALU_out = rs1 ^ rs2;
                5: ALU_out = rs1 >> rs2;
                6: ALU_out = rs1 >>> rs2;
                7: ALU_out = rs1 << rs2;
                8: ALU_out = rs1 * rs2;
                9: ALU_out = rs1 % rs2;
                10: begin
                    if (rs1[0] == 0) ALU_out = 1;
                    else ALU_out = 0;
                end
                11: begin
                    if ($signed(rs1) < $signed(rs2)) ALU_out = 1;
                    else ALU_out = 0;
                end
                12: begin
                    if (rs1 < rs2) ALU_out = 1;
                    else ALU_out = 0;
                end
                13: begin
                    if (rs1 == rs2) ALU_out = 1;
                    else ALU_out = 0;
                end
                14: begin
                    if (rs1 != rs2) ALU_out = 1;
                    else ALU_out = 0;
                end
                15: begin
                    if ($signed(rs1) < $signed(rs2)) ALU_out = 1;
                    else ALU_out = 0;
                end
                16: begin
                    if ($signed(rs1) >= $signed(rs2)) ALU_out = 1;
                    else ALU_out = 0;
                end
                17: begin
                    if (rs1 < rs2) ALU_out = 1;
                    else ALU_out = 0;
                end
                18: begin
                    if (rs1 >= rs2) ALU_out = 1;
                    else ALU_out = 0;
                end
            endcase
        end
    end
        
endmodule