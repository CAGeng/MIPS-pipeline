`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/12 19:26:39
// Design Name: 
// Module Name: signext
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


module signext(
input logic [15:0] a,
output logic [31:0] y
    );
    assign y = {{16{a[15]}},a};
endmodule

module signextzero(
input logic [15:0] a,
output logic [31:0] y
    );
    assign y = {16'b0,a};
endmodule

//sll..
module signext2(
input logic [4:0] a,
output logic [31:0] y
);
    assign y = {{27{a[4]}},a};
endmodule
