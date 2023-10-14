`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/05 09:57:33
// Design Name: 
// Module Name: div_32b
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


module div_32b(
    output  [31:0] Q,          //商
    output  [31:0] R,          //余数
    output out_valid,        //除法运算结束时，输出为1
    output in_error,         //被除数或除数为0时，输出为1
    input clk,               //时钟 
    input rst,             //复位信号
    input [31:0] X,           //被除数
    input [31:0] Y,           //除数
    input in_valid          //输入为1时，表示数据就绪，开始除法运算
);

    reg [5:0] cn;               //计数器
    reg [63:0] RDIV;            //中间被除数
    reg [31:0] TempQ;           //商
    reg temp_out_valid;         //输出有效信号
    wire [31:0] diff_result;    //差值
    wire cout;
    wire flag;
    assign in_error = ((X == 0) || (Y == 0)); //预处理，除数和被除数异常检测报错
    assign out_valid = in_error; //如果检测异常，则结束运算

    // cn 是计数器，用于计算商的位数
    always @(posedge clk or negedge rst) begin
        if (!rst) cn <= 0;
        else if (in_valid) cn <= 32;
        else if (cn != 0) cn <= cn - 1;
    end

    // adder32 是32 位加法器模块的实例化，参见实验 3 的设计
    Adder32 my_adder(.f(diff_result),.cout(cout),.x(RDIV[63:32]),.y(Y),.sub(1'b1)); //减法，当cout=0 时，表示有借位。
    divid_test test(.RDIV(RDIV[63:32]),.Y(Y),.div_result(diff_result),.valid(flag));

    // 除法运算
    always @(posedge clk or  negedge rst) begin
        if (!rst) RDIV = 0;  //复位时，中间被除数清零
        else if (in_valid) begin 
            RDIV <= {X[31] ? 32'b1 : 32'b0, X};  //把被除数赋值给中间被除数,在这里要进行符号扩展
            TempQ <= 32'b0;   //把商清零
            temp_out_valid <= 1'b0; //把输出有效信号清零
        end
        else if ((cn >= 0)&&(!out_valid)) begin
            if(flag) begin //判断是否有借位，flag=1，表示够减，没有借位
                RDIV[63:32] <= diff_result[31:0]; //把差值赋值到中间被除数的高 32 位
                TempQ[cn] <= 1'b1; //商在该位置 1
            end
            if(cn>0) 
                RDIV=RDIV <<1;  //中间被除数左移 1 位
            else 
                temp_out_valid <=1'b1;  //输出有效信号
        end
    end

    // 输出
    assign out_valid = temp_out_valid;
    assign Q = TempQ;
    assign R = RDIV[63:32];


endmodule


module divid_test (
    input [31:0] RDIV,
    input [31:0] Y,
    input [31:0] div_result,
    output valid
);
    wire Rsign;
    wire Ysign;
    wire divsign;
    reg r_valid;
    assign Rsign = RDIV[31];
    assign Ysign = Y[31];
    assign divsign = div_result[31];
    assign valid = r_valid;

    always @(*) begin
        case ({Rsign, Ysign, divsign}) 
            3'b000: r_valid = 1;
            3'b001: r_valid = 0;
            3'b010: r_valid = 1;
            3'b011: r_valid = 0;
            3'b100: r_valid = 0;
            3'b101: r_valid = 1;
            3'b110: r_valid = 0;
            3'b111: r_valid = 1;
        endcase
    end

endmodule