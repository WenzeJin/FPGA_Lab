`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:02:49
// Design Name: 
// Module Name: barrelsft32
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


module barrelsft32(
    output [31:0] dout,
    input [31:0] din,
    input [4:0] shamt,     //移动位数
    input LR,           // LR=1时左移，LR=0时右移
    input AL            // AL=1时算术右移，AR=0时逻辑右移
	);

    wire [31:0] ALR;
    assign ALR = din[31] ? (din >> shamt) | (32'hFFFFFFFF << (32 - shamt)) : din >> shamt;
    assign dout = LR ? din << shamt : (AL ? ALR : din >> shamt);

endmodule
