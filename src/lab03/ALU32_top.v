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
    output [6:0] segs,           //七段数码管字形输出
    output [7:0] AN,            //七段数码管显示32位运算结果 
    output  [15:0] result_l,       //32位运算结果
    output  zero,             //结果为0标志位
    input   [3:0] data_a,           //4位数据输入，重复8次后送到ALU端口A   
    input   [3:0] data_b,           //4位数据输入，重复8次后送到ALU端口B  
    input   [3:0] aluctr,        //4位ALU操作控制信号
    input   clk
    ); 

    reg [3:0] dis_cur;
    reg [3:0] dis_pos;
    dec7seg led_driver(segs, AN, dis_cur, dis_pos);

    wire [31:0] result_32;

    assign result_l = result_32[15:0];

    wire [31:0] dataa;
    wire [31:0] datab;
    assign dataa = {8{data_a}};
    assign datab = {8{data_b}};

    ALU32 alu(result_32, zero, dataa, datab, aluctr);

    //display buffer
    wire [3:0] display_buffer [0:7];
    assign display_buffer[0] = result_32[3:0];
    assign display_buffer[1] = result_32[7:4];
    assign display_buffer[2] = result_32[11:8];
    assign display_buffer[3] = result_32[15:12];
    assign display_buffer[4] = result_32[19:16];
    assign display_buffer[5] = result_32[23:20];
    assign display_buffer[6] = result_32[27:24];
    assign display_buffer[7] = result_32[31:28];
    reg [15:0] trans;
    reg [3:0] dis_cnt;

    //Display driving loop
    always @(posedge clk) begin
        //Transfer clk signal to acceptable fresh rate.
        if(trans >= 16'd50000)
            trans <= 0;
        else
            trans <= trans + 1;
            
        if(trans == 0) begin
            if(dis_cnt >= 7)
                dis_cnt <= 0;
            else
                dis_cnt <= dis_cnt + 1;
        end
        
        //Display
        dis_pos <= dis_cnt;
        dis_cur <= display_buffer[dis_cnt];
    end


endmodule
