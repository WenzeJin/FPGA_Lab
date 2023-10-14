`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/02 00:39:53
// Design Name: 
// Module Name: mul_32p
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

//Quick multiplier with LUT and without * operator



module mul_32k(
    input [31:0] X, Y,
    output [63:0] P       // output variable for assignment
    );

    assign P = X * Y;     // assign output variable

endmodule

