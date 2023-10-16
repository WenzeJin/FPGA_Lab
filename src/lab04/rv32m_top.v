`timescale 1ns / 1ps

module rv32m_top(
    output [15:0] rd_l,        //运算结果的低16位
    output out_valid,         //运算结束时，输出为1
    output in_error,          //运算出错时，输出为1
    output [6:0] segs,        // 7段数值
    output [7:0] AN,         //数码管选择
    input clk,               //时钟 
    input rst,               //复位信号，低有效
    input [3:0] x,           //操作数1，重复8次后作为rs1
    input [3:0] y,           //操作数2，重复8次后作为rs2
    input [2:0] funct3,        //3位功能选择码
    input in_valid          //输入为1时，表示数据就绪，开始运算
);
    
    wire [31:0] rd;
    wire [31:0] rs1;
    wire [31:0] rs2;

    assign rd_l = rd[15:0];
    assign rs1 = {4{x}};
    assign rs2 = {4{y}};
    
    rv32m core(.rd(rd), .out_valid(out_valid), .in_error(in_error), .clk(clk), .rst(rst), .rs1(rs1), .rs2(rs2), .funct3(funct3), .in_valid(in_valid));

    //display buffer
    wire [3:0] display_buffer [0:7];
    assign display_buffer[0] = rd[3:0];
    assign display_buffer[1] = rd[7:4];
    assign display_buffer[2] = rd[11:8];
    assign display_buffer[3] = rd[15:12];
    assign display_buffer[4] = rd[19:16];
    assign display_buffer[5] = rd[23:20];
    assign display_buffer[6] = rd[27:24];
    assign display_buffer[7] = rd[31:28];
    reg [15:0] trans;
    reg [3:0] dis_cnt;
    reg [3:0] dis_cur;
    reg [3:0] dis_pos;
    dec7seg led_driver(segs, AN, dis_cur, dis_pos);

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
