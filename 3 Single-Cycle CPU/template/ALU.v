module ALU(

    input wire [2:0] func3,
    input wire [4:0] ALU_cont,
    input wire [31:0] rs1,
    input wire [31:0] rs2,

    output reg [31:0] ALU_out,
    output reg bcond
);

always @(*) begin
    case (ALU_cont)
        0: ALU_out = rs1 + rs2;
        1: ALU_out = rs1 - rs2;
        2: ALU_out = rs1 & rs2;
        3: ALU_out = rs1 | rs2;
        4: ALU_out = ~(rs1 & rs2);
        5: ALU_out = ~(rs1 | rs2);
        6: ALU_out = rs1 ^ rs2;
        7: ALU_out = ~(rs1 ^ rs2);
        8: ALU_out = rs1;
        9: ALU_out = ~rs1;
        10: ALU_out = rs1 >> rs2;
        11: ALU_out = rs1 >>> rs2;
        13: ALU_out = rs1 << rs2;
        16: ALU_out = rs1 * rs2;
        17: ALU_out = rs1 % rs2;
        18: begin
            if (rs1[0] == 0) ALU_out = 1;
            else ALU_out = 0;
        end
        19: begin
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
        20: begin
            if ($signed(rs1) < $signed(rs2)) ALU_out = 1;
            // if (rs1 < rs2) ALU_out = 1;
            else ALU_out = 0;
        end
        21: begin
            if (rs1 < rs2) ALU_out = 1;
            else ALU_out = 0;
        end
    endcase 
end
    
endmodule
