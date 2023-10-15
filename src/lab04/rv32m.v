`timescale 1ns / 1ps

module rv32m(
    output [31:0] rd,          //������
    output out_valid,           //�������ʱ�����Ϊ1
    output in_error,            //�������ʱ�����Ϊ1
    input clk,                  //ʱ�� 
    input rst,                  //��λ�źţ�����Ч
    input [31:0] rs1,           //������rs1
    input [31:0] rs2,           //������rs2
    input [2:0] funct3,         //3λ����ѡ����
    input in_valid              //����Ϊ1ʱ����ʾ���ݾ���
);
    
    wire [31:0] div_u_q;
    wire [31:0] div_u_r;
    wire [31:0] div_b_q;
    wire [31:0] div_b_r;
    wire [63:0] mul_u;
    wire [63:0] mul_b;

    wire signed [31:0] rs1s;
    wire signed [31:0] rs2s;
    assign rs1s = rs1;
    assign rs2s = rs2;
    wire valid_mul_u;
    wire valid_mul_b;
    wire valid_div_u;
    wire valid_div_b;

    wire error_div;

    wire [63:0] ers1;
    wire [63:0] ers2;
    assign ers1 = {32'b0, rs1};
    assign ers2 = {32'b0, rs2};
    
    wire signed [63:0] ers1s;
    wire signed [63:0] ers2s;
    assign ers1s = {{32{rs1[31]}}, rs1};
    assign ers2s = {{32{rs2[31]}}, rs2};

    reg [31:0] res;
    assign rd = res;

    reg valid;
    assign out_valid = valid;

    reg error;
    assign in_error = error;

    mul_32u my_mul_32u(clk, rst, rs1, rs2, in_valid, mul_u, valid_mul_u);
    div_32u my_div_32u(div_u_q, div_u_r, valid_div_u, error_div, clk, rst, rs1, rs2, in_valid);
    div_32b my_div_32b(div_b_q, div_b_r, valid_div_b, error_div, clk, rst, rs1, rs2, in_valid); 
    mul_32b my_mul_32b(mul_b, valid_mul_b, clk, rst, rs1, rs2, in_valid);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            res <= 0;
            valid <= 0;
            error <= 0;
        end
        case(funct3)
        3'b000: begin res <= mul_u[31:0]; valid <= valid_mul_u; error <= 0; end
        3'b001: begin res <= mul_b[63:32]; valid <= valid_mul_b; error <= 0; end
        3'b010: begin res <= (ers1s * ers2) >> 32; valid <= valid_mul_u; error <= 0; end
        3'b011: begin res <= mul_u[63:32]; valid <= valid_mul_u; error <= 0; end
        3'b100: begin res <= div_b_q; valid <= valid_div_b; error <= error_div; end
        3'b101: begin res <= div_u_q; valid <= valid_div_u; error <= error_div; end
        3'b110: begin res <= div_b_r; valid <= valid_div_b; error <= error_div; end
        3'b111: begin res <= div_u_r; valid <= valid_div_u; error <= error_div; end
        endcase
    end



endmodule
