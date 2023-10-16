`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/02 12:05:22
// Design Name: 
// Module Name: div_32u
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


module div_32u(
    output [31:0] Q,          //��
    output [31:0] R,          //����
    output out_valid,        //�����������ʱ�����Ϊ1
    output in_error,         //�����������Ϊ0ʱ�����Ϊ1
    input clk,               //ʱ�� 
    input rst,             //��λ�ź�
    input [31:0] X,           //������
    input [31:0] Y,           //����
    input in_valid          //����Ϊ1ʱ����ʾ���ݾ�������ʼ��������
);

    reg [5:0] cn;
    reg [63:0] RDIV;
    reg temp_out_valid;
    wire [31:0] diff_result;
    wire cout;
    assign in_error = ((X == 0) || (Y == 0)); //Ԥ���������ͱ������쳣��ⱨ��
    assign out_valid = in_error | temp_out_valid; //�������쳣�����������
    assign Q = RDIV[31:0];
    assign R = RDIV[63:32];

    // adder32 ��32 λ�ӷ���ģ���ʵ�������μ�ʵ�� 3 �����

    Adder32 my_adder(.f(diff_result),.cout(cout),.x(R),.y(Y),.sub(1'b1)); //��������cout=0 ʱ����ʾ�н�λ��

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            RDIV <= 0;
            cn <= 0;
        end
        else if (in_valid) begin 
            RDIV <= {32'b0, X};
            temp_out_valid<=1'b0; 
            cn <= 32;
        end
        else if ((cn >= 0) && (!out_valid)) begin
            if(cout) begin
                if(cn > 0) begin
                    RDIV <= {diff_result[30:0], RDIV[31:0], 1'b1};
                end else begin
                    RDIV <= {diff_result[31:0], RDIV[30:0], 1'b1};
                    temp_out_valid <= 1'b1;
                end
            end else begin
                if(cn > 0) begin
                    RDIV <= {RDIV[62:0], 1'b0};
                end else begin
                    RDIV <= {RDIV[63:32], RDIV[30:0], 1'b0};
                    temp_out_valid <= 1'b1;
                end
            end
            if(cn != 0) begin
                cn <= cn - 1;
            end
        end
    end
endmodule
