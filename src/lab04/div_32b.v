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

    reg [5:0] cnt;               //计数器
    reg [63:0] buffer;            //被除数寄存器
    reg temp_out_valid;         //输出有效信号
    reg initial_rsign;
    reg initial_ysign;
    assign in_error = ((X == 0) || (Y == 0)); //预处理，除数和被除数异常检测报错
    assign out_valid = temp_out_valid | in_error;
    assign Q = buffer[31:0];
    assign R = buffer[63:32];
    wire rsign;
    wire ysign;
    wire signed [31:0] y;
    wire signed [31:0] r;
    wire signed [31:0] q;
    assign y = Y;
    assign r = R;
    assign q = Q;
    assign rsign = buffer[63];
    assign ysign = Y[31];
    wire signed [31:0] diff_res, add_res, two_diff_res, two_add_res;
    assign diff_res = r - y;
    assign add_res = r + y;
    wire [31:0] qplusone;
    assign qplusone = q + 1;
    
    

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            buffer <= 0;
            cnt <= 0;
            temp_out_valid <= 0;
        end
        else if(in_valid) begin
            buffer <= {{32{X[31]}}, X};
            cnt <= 34;
            temp_out_valid <= 0;
            initial_rsign = X[31];
            initial_ysign = Y[31];
        end
        else if(cnt == 34) begin
            if(rsign == ysign) begin
                if(diff_res[31] == ysign) begin
                    buffer <= {diff_res[30:0], buffer[31:0], 1'b1};
                end else begin
                    buffer <= {diff_res[30:0], buffer[31:0], 1'b0};
                end
            end else begin
                if(add_res[31] == ysign) begin
                    buffer <= {add_res[30:0], buffer[31:0], 1'b1};
                end else begin
                    buffer <= {add_res[30:0], buffer[31:0], 1'b0};
                end
            end
            cnt <= cnt - 1;
        end
        else if(cnt > 2) begin
            if(buffer[0]) begin
                buffer <= {diff_res[30:0], buffer[31:0], (diff_res[31] == ysign? 1'b1 : 1'b0)};
            end else begin
                buffer <= {add_res[30:0], buffer[31:0], (add_res[31] == ysign? 1'b1 : 1'b0)};
            end
            cnt <= cnt - 1;
        end
        else if(cnt == 2) begin
            if(buffer[0]) begin
                buffer <= {diff_res[31:0], buffer[30:0], (diff_res[31] == ysign || diff_res == 0? 1'b1 : 1'b0)};
            end else begin
                buffer <= {add_res[31:0], buffer[30:0], (add_res[31] == ysign || add_res == 0? 1'b1 : 1'b0)};
            end
            cnt <= cnt - 1;
        end
        else if(cnt == 1) begin
            if(initial_rsign == initial_ysign || r == 0) begin    //商不需要修正
                if(rsign == initial_rsign || r == 0) begin        //余数不需要修正
                    buffer <= buffer;
                end else begin
                    buffer <= {add_res, buffer[31:0]};
                end
            end 
            else begin
                if(rsign == initial_rsign || r == 0) begin        //余数不需要修正
                    buffer <= {buffer[63:32], qplusone};
                end else begin
                    buffer <= {diff_res, qplusone};
                end
            end
            cnt <= cnt - 1;
            temp_out_valid <= 1;
        end
    end

endmodule