`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/12 12:28:43
// Design Name: 
// Module Name: mips
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


module mips(
input clk,reset,
output [31:0] pc,
input [31:0] instr,
output memwrite,
output [31:0] aluout,writedata,
input [31:0] readdata
    );
    
    logic [5:0] opD,functD;
    logic regdstE,alusrcE,pcsrcD,memtoregE,memtoregM,memtoregW,
                regwriteE,regwriteM,regwriteW;
    logic [2:0] alucontrolE;
    logic flushE,equalD;
    logic branchD,jumpD;//
    logic isjalE,isjalW;//jal
    logic issllE;//sll..
    logic jrjumpD;//jr
    logic zeroimmD;//zeroimm
    
    controller c(clk,reset,opD,functD,flushE,equalD,memtoregE,memtoregM,
                        memtoregW,memwrite,pcsrcD,branchD,alusrcE,regdstE,
                       regwriteE,regwriteM,regwriteW,jumpD,alucontrolE,
                       isjalE,isjalW,issllE,jrjumpD,zeroimmD);//jal,sll..,zeroimm
                       
    datapath dp(clk,reset,memtoregE,memtoregM,memtoregW,pcsrcD,
                            branchD,alusrcE,regdstE,regwriteE,regwriteM,regwriteW,
                            jumpD,alucontrolE,equalD, pc,instr,aluout,writedata,
                            readdata,opD,functD,flushE,isjalE,isjalW,issllE,
                            jrjumpD,zeroimmD);//jal,sll..,zeroimm
                        
endmodule
