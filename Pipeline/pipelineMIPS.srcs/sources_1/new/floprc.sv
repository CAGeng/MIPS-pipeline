`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/12 17:33:05
// Design Name: 
// Module Name: floprc
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


module floprc #(parameter WIDTH = 8)(
input logic clk,reset,clear,
input logic [WIDTH - 1 : 0] d,
output logic [WIDTH - 1 : 0] q
    );
    always_ff @(posedge clk, posedge reset)
        if (reset) q <= 0;
        else if (clear) q <= 0;
        else q <= d;
endmodule

module flopenrc #(parameter WIDTH = 8)(
input clk,reset,
input en,clear,
input [WIDTH - 1 : 0] d,
output  logic [WIDTH - 1 : 0] q);
    always_ff @(posedge clk, posedge reset)
        if (reset) q <= 0;//pc control
        else if(en & ~clear) q <= d;
        else if(en & clear) q <= 0;
        
endmodule

module flopenr #(parameter WIDTH = 8)(
input clk,reset,
input en,
input [WIDTH - 1 : 0] d,
output  logic [WIDTH - 1 : 0] q);
    always_ff @(posedge clk, posedge reset)
        if (reset) q <= 0;
        else if(en) q <= d;
        
endmodule
