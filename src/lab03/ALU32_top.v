`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:03:44
// Design Name: 
// Module Name: ALU32_top
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


module ALU32_top(
output [6:0] segs,           //�߶�������������
output [7:0] AN,            //�߶��������ʾ32λ������ 
output  [15:0] result_l,       //32λ������
output  zero,             //���Ϊ0��־λ
input   [3:0] data_a,           //4λ�������룬�ظ�8�κ��͵�ALU�˿�A   
input   [3:0] data_b,           //4λ�������룬�ظ�8�κ��͵�ALU�˿�B  
input   [3:0] aluctr,        //4λALU���������ź�
input   clk
); 
//add your code here

endmodule
