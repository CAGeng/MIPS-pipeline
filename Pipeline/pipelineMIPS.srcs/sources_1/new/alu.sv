`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/12 19:28:18
// Design Name: 
// Module Name: alu
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


module alu(
        input [31:0] a,        //OP1
        input [31:0] b,        //OP2
        input [2:0] aluc,    //controller
        output reg [31:0] r   //result
       // output carry,
        //output negative,
        //output overflow
 );    
    logic alessb;
    assign alessb = ((a[31] == 0) & (b[31] == 0) & (a < b)) |
                                ((a[31] == 1) & (b[31] == 1) & (a < b)) |
                                ((a[31] == 1) & (b[31] == 0) ) ;//signed 
    always@(*)
        begin
        case(aluc)
            3'b000: r <= a & b;
            3'b110: r <= a - b;
            3'b010: r <= b + a;
            3'b001: r <= a | b;
            3'b111: r <= alessb?1:0;
            3'b011: r <= b << a; //sll
            3'b100: r <= b >> a; //srl
            3'b101: r <= b >>> a; //sra
            
            default: r <= a + b;
        endcase
        end
    //assign negative=result[31];
    //assign overflow=result[32];
endmodule
