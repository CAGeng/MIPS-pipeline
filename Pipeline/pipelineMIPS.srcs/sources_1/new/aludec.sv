module aludec(
input logic [5:0] funct,
input logic [1:0] aluop,
output logic [2:0] alucontrol,
output logic issll,//sll..
input logic [1:0] ialuopD//I-type
    );
    always_comb
        case(aluop)
            2'b00: alucontrol <= 3'b010;//+
            2'b01: alucontrol <= 3'b110;//-
            2'b11: case(ialuopD)//I-type
                2'b00: alucontrol <= 3'b010;//+
                2'b01: alucontrol <= 3'b000;//&
                2'b10: alucontrol <= 3'b001;//|
                2'b11: alucontrol <= 3'b111;//slt
                    endcase
            default: case(funct)//r-type
                6'b100000: alucontrol <= 3'b010;
                6'b100010: alucontrol <= 3'b110;
                6'b100100: alucontrol <= 3'b000;//&
                6'b100101: alucontrol <= 3'b001;//|
                6'b101010: alucontrol <= 3'b111;
                6'b000000: alucontrol <= 3'b011;//sll
                6'b000010: alucontrol <= 3'b100;//srl
                6'b000011: alucontrol <= 3'b101;//sra
                default: alucontrol <= 3'bxxx;
            endcase
        endcase
        assign issll = ((aluop == 2'b10) &
                 ((funct == 6'b000000) | (funct == 6'b000010) |(funct == 6'b000011))) ? 1 : 0;//sll..*/
endmodule