`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/12 19:12:51
// Design Name: 
// Module Name: mux3
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


module mux3#(parameter WIDTH = 8)(
input logic [WIDTH - 1 : 0] d0,d1,d2,
input logic [1:0] s,
output logic [WIDTH - 1: 0] y
    );
    always@(*)
        if(s == 2'b00)y <= d0;
        else if(s == 2'b01) y<= d1;
        else  y<= d2;
   
endmodule
