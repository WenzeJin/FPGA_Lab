`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:03:26
// Design Name: 
// Module Name: ALU32
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


module ALU32(
output  [31:0] result,      //32λ������
output  zero,               //���Ϊ0��־λ
input   [31:0] dataa,       //32λ�������룬�͵�ALU�˿�A   
input   [31:0] datab,       //32λ�������룬�͵�ALU�˿�B  
input   [3:0] aluctr        //4λALU���������ź�
); 
//add your code here


Adder32 my_adder();

barrelsft32 my_barrel();

endmodule
