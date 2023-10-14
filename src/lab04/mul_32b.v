`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/02 11:14:03
// Design Name: 
// Module Name: mul_32b
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

//使用Booth两位乘法的乘法器
module mul_32b(
    output [63:0] p,         //乘积
    output out_valid,        //高电平有效时，表示乘法器结束工作
    input clk,              //时钟 
    input rst_n,             //复位信号，低有效
    input [31:0] x,           //被乘数
    input [31:0] y,           //乘数
    input in_valid           //高电平有效，表示乘法器开始工作
); 
    //寄存器
    reg [5:0] cnt;     //移位次数寄存器
    reg [63:0] buffer;      //乘积寄存器
    reg [31:0] op1;         //被乘数寄存器
    reg bufferbooth;        //乘积寄存器的-1位

    //组合逻辑
    wire [1:0] op;          //Booth编码
    wire cout;              //加法器的进位
    wire [31:0] rx, ry; //加法器的两个输入和部分积寄存器
    wire [31:0] Add_result;        //加法器的输出
    assign op = {buffer[0], bufferbooth}; //Booth编码
    assign ry = op1;
    assign rx = buffer[63:32];
    assign p = buffer;
    assign out_valid = (cnt == 0);

    //加法器
    Adder32 adder32_1(
        .x(rx),
        .y((op == 2'b00 || op == 2'b11)? 32'd0 : ry),
        .sub(op == 2'b10),
        .f(Add_result),
        .cout(cout)
    );

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 0;
            buffer <= 0;
            op1 <= 0;
            bufferbooth <= 0;
        end
        else if(in_valid) begin
            cnt <= 32;
            buffer <= {32'd0, y};
            op1 <= x;
            bufferbooth <= 0;
        end
        else if(cnt > 0) begin
            cnt <= cnt - 1;
            buffer <= {Add_result[31], Add_result, buffer[31:1]};
            bufferbooth <= buffer[0];
        end
    end
endmodule
