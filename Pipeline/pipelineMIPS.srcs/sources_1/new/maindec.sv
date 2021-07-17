`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/12 17:25:15
// Design Name: 
// Module Name: maindec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module maindec(
input logic [5:0] op, 
output logic memtoreg, memwrite, 
output logic branch, alusrc,
output logic regdst, regwrite, 
output logic jump, 
output logic [1:0] aluop,
output logic isjal,//jal
output logic zeroimm,//zeroimm
output logic [1:0] ialuop//I-type
    );
    logic [8:0] controls;
    assign {regwrite, regdst, alusrc, branch, memwrite, memtoreg,
                jump, aluop} =  controls;
         
    always_comb
        case(op)
            6'b000000: controls <= 9'b110000010; // RTYPE
            6'b100011: controls <= 9'b101001000; // LW
            6'b101011: controls <= 9'b001010000; //SW
            6'b000100: controls <= 9'b000100001; //BEQ
            6'b000101: controls <= 9'b000100001; //BNE
            6'b001000: controls <= 9'b101000011; //ADDI
            6'b001100: controls <= 9'b101000011; //ANDI
            6'b001101: controls <= 9'b101000011; //ORI
            6'b001010: controls <= 9'b101000011; //SLTI
            6'b000010: controls <= 9'b000000100; //J
            6'b000011: controls <= 9'b100000100; //Jal
            default:      controls <= 9'bxxxxxxxxx; //illegal
         endcase
         
      always_comb
        case(op)
            6'b001000: ialuop <= 2'b00; //ADDI
            6'b001100: ialuop <= 2'b01; //ANDI
            6'b001101: ialuop <= 2'b10; //ORI
            6'b001010: ialuop <= 2'b11; //SLTI
         endcase
         
      assign isjal = (op == 6'b000011)? 1 : 0;//jal
      assign zeroimm = (op == 6'b001101) | (op == 6'b001100);//zeroimm
  endmodule
