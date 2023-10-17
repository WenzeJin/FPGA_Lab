`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/10 09:38:14
// Design Name: 
// Module Name: KeyboardSim
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


module KeyboardSim(
    input CLK100MHZ,   //ϵͳʱ���ź�
    input PS2_CLK,    //���Լ��̵�ʱ���ź�
    input PS2_DATA,  //���Լ��̵Ĵ�������λ
    input BTNC,      //Reset
    output [6:0]SEG,
    output [7:0]AN,
    output [15:0] LED   //��ʾ
    );
    
// Add your code here

seg7decimal sevenSeg (
.x(seg7_data[31:0]),
.clk(CLK100MHZ),
.seg(SEG[6:0]),
.an(AN[7:0]),
.dp(0) 
);
endmodule
