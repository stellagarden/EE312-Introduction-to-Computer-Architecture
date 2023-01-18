module ALU(
    
    input wire RSTn,
    input wire [2:0] func3,
    input wire [4:0] ALU_cont,
    input wire [31:0] rs1,
    input wire [31:0] rs2,
    input wire [3:0] state,

    output reg [31:0] ALU_out,
    output reg bcond
);

parameter IF  = 1;
parameter ID  = 2;
parameter EX  = 3;
parameter MEM = 4;
parameter WB  = 5;

always @(*) begin
    if (~RSTn) begin
        ALU_out = 0;
        bcond = 0;
    end else begin
        if (state == EX) begin
            bcond = 0;  // 초기값 지정
            // 안 쓰는 ALU_cont 없애고 숫자 맞춤
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
                    case (func3)
                        3'b000: begin
                            if (rs1 == rs2) bcond = 1;
                            else bcond = 0;
                        end
                        3'b001: begin
                            if (rs1 != rs2) bcond = 1;
                            else bcond = 0;
                        end
                        3'b100: begin
                            if ($signed(rs1) < $signed(rs2)) bcond = 1;
                            else bcond = 0;
                        end
                        3'b101: begin
                            if ($signed(rs1) >= $signed(rs2)) bcond = 1;
                            else bcond = 0;
                        end
                        3'b110: begin
                            if (rs1 < rs2) bcond = 1;
                            else bcond = 0;
                        end
                        3'b111: begin
                            if (rs1 >= rs2) bcond = 1;
                            else bcond = 0;
                        end
                    endcase
                end
                12: begin
                    if ($signed(rs1) < $signed(rs2)) ALU_out = 1;
                    else ALU_out = 0;
                end
                13: begin
                    if (rs1 < rs2) ALU_out = 1;
                    else ALU_out = 0;
                end
            endcase
        end
    end
end
    
endmodule
