`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/12 17:33:59
// Design Name: 
// Module Name: datapath
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


module datapath(
input clk,reset,
input memtoregE,memtoregM,memtoregW,
input pcsrcD,branchD,
input alusrcE,regdstE,
input regwriteE,regwriteM,regwriteW,
input jumpD,
input [2:0] alucontrolE,
output equalD,
output [31:0] pcF,
input [31:0] instrF,
output [31:0] aluoutM,writedataM,
input [31:0] readdataM,
output [5:0] opD,functD,
output flushE,
input isjalE,isjalW,//jal
input issllE,//sll..
input jrjumpD,//jr
input zeroimmD//zeroimm
    );
    
    logic forwardaD,forwardbD;
    logic [1:0] forwardaE,forwardbE;
    logic stallF,stallD;
    logic [4:0] rsD,rtD,rdD,rsE,rtE,rdE;
    logic [4:0] writeregE,writeregM,writeregW;
    logic [4:0] writeregEE;//jal
    logic flushD;
    logic [31:0] pcnextFD,pcnextbrFD,pcplus4F,pcbranchD;
    logic [31:0] signimmD,signimmE,signimmshD;
    logic [31:0] srcaD,srca2D,srcaE,srca2E;
    logic [31:0] srcbD,srcb2D,srcbE,srcb2E,srcb3E;
    logic [31:0] pcplus4D,instrD;
    logic [31:0] pcplus4E,pcplus4M,pcplus4W;//jal
    logic [31:0] aluoutE, aluoutW;
    logic [31:0] readdataW,resultW;
    logic [31:0] resultWW,signimm2D,signimm2E,srcaEE;//jal,sll..
    logic [31:0] jradD,pcnextFDD;//jr
    logic [31:0] immD,signimmD0;//zeroimm
    
    hazard haz(rsD,rtD,rsE,rtE,writeregE,writeregM,writeregW,regwriteE,
                    regwriteM,regwriteW,memtoregE,memtoregM,branchD,
                    forwardaD,forwardbD,forwardaE,forwardbE,
                    stallF,stallD,flushE,jrjumpD);
                    
    mux2 #(32) pcbrmux(pcplus4F,pcbranchD,pcsrcD,pcnextbrFD);
    mux2 #(32) pcmux(pcnextbrFD,{pcplus4D[31:28],instrD[25:0],
                                    2'b00},jumpD,pcnextFDD);
    mux2 #(32)  pcjrmux(pcnextFDD,jradD,jrjumpD,pcnextFD);//jr                             
    
                                    
    regfile rf(clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);
    
    //fetch
    flopenr #(32) pcreg(clk,reset,~stallF,pcnextFD,pcF);
    adder pcadd1(pcF,32'b100,pcplus4F);
    
    //decode
    flopenrc #(32) r1D(clk,reset,~stallD,flushD,pcplus4F,pcplus4D);
    flopenrc #(32) r2D(clk,reset,~stallD,flushD,instrF,instrD);
    signext se(instrD[15:0],signimmD);
    signext2 se2(instrD[10:6],signimm2D);//sll..
    signextzero se3(instrD[15:0],signimmD0);//zeroimm
    mux2 #(32) immmux(signimmD,signimmD0,zeroimmD,immD);
    sl2 immsh(signimmD,signimmshD);
    adder pcadd2(pcplus4D,signimmshD,pcbranchD);
    mux2 #(32) forwardadmux(srcaD,aluoutM,forwardaD,srca2D);
    mux2 #(32) forwardbdmux(srcbD,aluoutM,forwardbD,srcb2D);
    eqcmp comp(srca2D,srcb2D,equalD);
    assign jradD = srca2D;//jr
    
    assign opD  = instrD[31:26];
    assign functD = instrD[5:0];
    assign rsD = instrD[25:21];
    assign rtD = instrD[20:16];
    assign rdD = instrD[15:11];
    
    assign flushD = pcsrcD | jumpD | jrjumpD;//jr
    
    //execute 
    floprc #(32) r1E(clk,reset, flushE,srcaD,srcaEE);//sll..
    floprc #(32) r2E(clk,reset, flushE,srcbD,srcbE);
    floprc #(32) r3E(clk,reset,flushE,immD,signimmE);//zeroimm
    floprc #(32) rsllE(clk,reset,flushE,signimm2D,signimm2E);//sll..
    floprc #(5) r4E(clk,reset,flushE,rsD,rsE);
    floprc #(5) r5E(clk,reset,flushE,rtD,rtE);
    floprc #(5) r6E(clk,reset,flushE,rdD,rdE);
    floprc #(32) pcE(clk,reset,flushE,pcplus4D,pcplus4E);//jal
    mux2 #(32) sllmux(srcaEE,signimm2E,issllE,srcaE);//sll..
    mux3 #(32) forwardaemux(srcaE,resultW,aluoutM,forwardaE,srca2E);
    mux3 #(32) forwardbemux(srcbE,resultW,aluoutM,forwardbE,srcb2E);
    mux2 #(32) srcbmux(srcb2E,signimmE,alusrcE,srcb3E);
    alu alu(srca2E,srcb3E,alucontrolE,aluoutE);
    mux2 #(5) wrmux(rtE,rdE,regdstE,writeregEE);
    mux2 #(5) jalmux(writeregEE,5'b11111,isjalE,writeregE);//jal
    
    //memory
    flopr #(32) r1M(clk,reset, srcb2E,writedataM);
    flopr #(32) r2M(clk,reset,aluoutE,aluoutM);
    flopr #(5) r3M(clk,reset,writeregE,writeregM);
    flopr #(32) pcM(clk,reset,pcplus4E,pcplus4M);//jal
    
    //write
    flopr #(32) r1W(clk,reset,aluoutM,aluoutW);
    flopr #(32) r2W(clk,reset,readdataM,readdataW);
    flopr #(5) r3W(clk,reset,writeregM,writeregW);
    flopr #(32) pcW(clk,reset,pcplus4M,pcplus4W);//jal
    mux2 #(32) resmux(aluoutW,readdataW,memtoregW,resultWW);
    mux2 #(32) resmux2(resultWW,pcplus4W,isjalW,resultW);//jal
                    
endmodule
