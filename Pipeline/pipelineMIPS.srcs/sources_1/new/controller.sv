`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/12 12:28:43
// Design Name: 
// Module Name: controller
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


module controller(
input clk,reset,
input [5:0] opD,functD,
input flushE,equalD,
output memtoregE,memtoregM,
output memtoregW,memwriteM,
output pcsrcD,branchD,alusrcE,
output regdstE,regwriteE,
output regwriteM,regwriteW,
output jumpD,
output [2:0] alucontrolE,
output isjalE,isjalW,//jal
output issllE,//sll..
output jrjumpD,//jr
output zeroimmD//zeroimm
    );
    
    logic [1:0] aluopD;
    logic memtoregD,memwriteD,alusrcD,regdstD,regwriteD;
    logic [2:0] alucontrolD;
    logic memwriteE;
    logic isjalD,isjalM,issllD;//jal,sll..
    logic pcsrc1,pcsrc2;//bne
    logic [1:0] ialuopD;//I-type
    
    maindec md(opD,memtoregD,memwriteD,branchD,alusrcD,
                        regdstD,regwriteD,jumpD,aluopD,isjalD,zeroimmD,ialuopD);//jal,zeroimm
                        
    aludec ad(functD,aluopD,alucontrolD,issllD,ialuopD);//sll..
    
    assign pcsrc1 = branchD & equalD;  
    assign pcsrc2 = branchD & (~equalD);//bne
    assign pcsrcD = (opD[0] == 0) ? pcsrc1 : pcsrc2;//bne
    assign jrjumpD = ({opD,functD} == 12'b000000_001000) ?  1 : 0; //jr
    
    //pipeline registers
    floprc #(10) regE(clk,reset, flushE,{memtoregD,memwriteD,alusrcD,
                                regdstD,regwriteD,alucontrolD,isjalD,issllD},{memtoregE,
                                memwriteE,alusrcE,regdstE,regwriteE,alucontrolE,isjalE,issllE});//jal,sll..
    flopr #(4) regM(clk,reset, {memtoregE,memwriteE,regwriteE,isjalE},
                                {memtoregM,memwriteM,regwriteM,isjalM});//jal
    flopr #(3) regW(clk,reset,{memtoregM,regwriteM,isjalM},
                                {memtoregW,regwriteW,isjalW});        //jal                    
    
endmodule
