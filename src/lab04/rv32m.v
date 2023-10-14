`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/05 10:12:50
// Design Name: 
// Module Name: rv32m
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


module rv32m(
    output  [31:0] rd,        //运算结果
    output out_valid,         //运算结束时，输出为1
    output in_error,          //运算出错时，输出为1
    input clk,               //时钟 
    input rst,               //复位信号，低有效
    input [31:0] rs1,          //操作数rs1
    input [31:0] rs2,          //操作数rs2
    input [2:0] funct3,        //3位功能选择码
    input in_valid           //输入为1时，表示数据就绪
    );
    
    wire [31:0] div_u_q;
    wire [31:0] div_u_r;
    wire [31:0] div_b_q;
    wire [31:0] div_b_r;
    wire [63:0] mul_u;
    wire [63:0] mul_b;

    reg [31:0] res;
    assign rd = res;

    mul_32u my_mul_32u(clk, rst, rs1, rs2, in_valid, mul_u, out_valid);
    div_32u my_div_32u(div_u_q, div_u_r, out_valid, in_error, clk, rst, rs1, rs2, in_valid);
    div_32b my_div_32b(div_b_q, div_b_r, out_valid, in_error, clk, rst, rs1, rs2, in_valid); 
    mul_32b my_mul_32b(mul_b, out_valid, clk, rst, rs1, rs2, in_valid);

    always @(funct3) begin
        case(funct3)
        3'b000: res = mul_b[31:0];
        3'b001: res = mul_b[63:32];
        3'b010: res = mul_u[63:32];
        3'b011: res = mul_u[63:32];
        3'b100: res = div_b_q;
        3'b101: res = div_u_q;
        3'b110: res = div_b_r;
        3'b111: res = div_u_r;
        endcase
        $display("funct3=%b, res=%h, rs1=%h, rs2=%h, mul_u=%h, mul_b=%h, div_u_q=%h, div_u_r=%h, div_b_q=%h, div_b_r=%h", funct3, res, rs1, rs2, mul_u, mul_b, div_u_q, div_u_r, div_b_q, div_b_r);
    end

endmodule
