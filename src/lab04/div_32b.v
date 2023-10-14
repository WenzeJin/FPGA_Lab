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

    reg [5:0] cn;               //������
    reg [63:0] RDIV;            //�м䱻����
    reg [31:0] TempQ;           //��
    reg temp_out_valid;         //�����Ч�ź�
    wire [31:0] diff_result;    //��ֵ
    wire cout;
    wire flag;
    assign in_error = ((X == 0) || (Y == 0)); //Ԥ���������ͱ������쳣��ⱨ��
    assign out_valid = in_error; //�������쳣�����������

    // cn �Ǽ����������ڼ����̵�λ��
    always @(posedge clk or negedge rst) begin
        if (!rst) cn <= 0;
        else if (in_valid) cn <= 32;
        else if (cn != 0) cn <= cn - 1;
    end

    // adder32 ��32 λ�ӷ���ģ���ʵ�������μ�ʵ�� 3 �����
    Adder32 my_adder(.f(diff_result),.cout(cout),.x(RDIV[63:32]),.y(Y),.sub(1'b1)); //��������cout=0 ʱ����ʾ�н�λ��
    divid_test test(.RDIV(RDIV[63:32]),.Y(Y),.div_result(diff_result),.valid(flag));

    // ��������
    always @(posedge clk or  negedge rst) begin
        if (!rst) RDIV = 0;  //��λʱ���м䱻��������
        else if (in_valid) begin 
            RDIV <= {X[31] ? 32'b1 : 32'b0, X};  //�ѱ�������ֵ���м䱻����,������Ҫ���з�����չ
            TempQ <= 32'b0;   //��������
            temp_out_valid <= 1'b0; //�������Ч�ź�����
        end
        else if ((cn >= 0)&&(!out_valid)) begin
            if(flag) begin //�ж��Ƿ��н�λ��flag=1����ʾ������û�н�λ
                RDIV[63:32] <= diff_result[31:0]; //�Ѳ�ֵ��ֵ���м䱻�����ĸ� 32 λ
                TempQ[cn] <= 1'b1; //���ڸ�λ�� 1
            end
            if(cn>0) 
                RDIV=RDIV <<1;  //�м䱻�������� 1 λ
            else 
                temp_out_valid <=1'b1;  //�����Ч�ź�
        end
    end

    // ���
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