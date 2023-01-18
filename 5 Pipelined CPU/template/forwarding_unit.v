module forwarding_unit(
    input wire RSTn,

    input wire [4:0] RF_RA1,
    input wire [4:0] RF_RA2,
    input wire [4:0] DE_WA,
    input wire [4:0] EM_WA,
    input wire [4:0] MW_WA,
    input wire DE_WE,
    input wire EM_WE,
    input wire MW_WE,
    input wire [31:0] EM_IR,
    input wire [31:0] DE_IR,
    input wire [4:0] DE_RA1,
    input wire [4:0] DE_RA2,
    input wire [4:0] EM_RA2,

    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB,
    output reg [1:0] ForwardC,
    output reg [1:0] ForwardD,
    output reg [1:0] ForwardE,
    output reg LoadDelaySlot
);

    always @(*) begin
        if (~RSTn) begin
            ForwardA = 0;
            ForwardB = 0;
            ForwardC = 0;
            ForwardD = 0;
            LoadDelaySlot = 0;
        end
        else begin            
            ForwardA = ((RF_RA1 != 0) && (RF_RA1 == MW_WA) && MW_WE) ? 1 : 0;
            ForwardB = ((RF_RA2 != 0) && (RF_RA2 == MW_WA) && MW_WE) ? 1 : 0;

            if ((DE_RA1 != 0) && (DE_RA1 == EM_WA) && EM_WE) ForwardC = 1;
            else if ((DE_RA1 != 0) && (DE_RA1 == MW_WA) && MW_WE) ForwardC = 2;
            else ForwardC = 0;
            
            if ((DE_RA2 != 0) && (DE_RA2 == EM_WA) && EM_WE) ForwardD = 1;
            else if ((DE_RA2 != 0) && (DE_RA2 == MW_WA) && MW_WE) ForwardD = 2;
            else ForwardD = 0;

            ForwardE = ((EM_RA2 != 0) && (EM_RA2 == MW_WA) && MW_WE) ? 1 : 0;

            //LoadDelaySlot
            if (DE_IR[6:0] == 7'b0000011 && (RF_RA1 == DE_WA || RF_RA2 == DE_WA) && DE_WE) LoadDelaySlot = 1;
            else LoadDelaySlot = 0;
        end
    end

endmodule