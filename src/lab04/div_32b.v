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
    output  [31:0] Q,          //��
    output  [31:0] R,          //����
    output out_valid,        //�����������ʱ�����Ϊ1
    output in_error,         //�����������Ϊ0ʱ�����Ϊ1
    input clk,               //ʱ�� 
    input rst,             //��λ�ź�
    input [31:0] X,           //������
    input [31:0] Y,           //����
    input in_valid          //����Ϊ1ʱ����ʾ���ݾ�������ʼ��������
);

    reg [5:0] cnt;               //������
    reg [63:0] buffer;            //�������Ĵ���
    reg temp_out_valid;         //�����Ч�ź�
    reg initial_rsign;
    reg initial_ysign;
    assign in_error = ((X == 0) || (Y == 0)); //Ԥ���������ͱ������쳣��ⱨ��
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
            if(initial_rsign == initial_ysign || r == 0) begin    //�̲���Ҫ����
                if(rsign == initial_rsign || r == 0) begin        //��������Ҫ����
                    buffer <= buffer;
                end else begin
                    buffer <= {add_res, buffer[31:0]};
                end
            end 
            else begin
                if(rsign == initial_rsign || r == 0) begin        //��������Ҫ����
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