`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:03:26
// Design Name: 
// Module Name: ALU32
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


module ALU32(
    output  [31:0] result,      //32位运算结果
    output  zero,               //结果为0标志位
    input   [31:0] dataa,       //32位数据输入，送到ALU端口A   
    input   [31:0] datab,       //32位数据输入，送到ALU端口B  
    input   [3:0] aluctr        //4位ALU操作控制信号
    ); 

    reg [31:0] _result;
    assign result = _result;

    reg sub;
    wire [31:0] adder_result;
    wire OF, SF, ZF, CF;
    wire real_OF;
    wire [31:0] real_y;
    assign _zero = ZF;
    wire cout;
    assign  real_y = sub ? ~datab : datab;
    assign real_OF = (~dataa[31] & ~real_y[31] & adder_result[31]) | (dataa[31] & real_y[31] & ~adder_result[31]);

    wire [31:0] sft_result;
    reg LR, AL;

    reg SIG;
    wire [31:0] cmp_result;
    assign cmp_result = {31'b0, (SIG ? (real_OF ^ SF) : CF)};

    Adder32 my_adder(adder_result, OF, SF, ZF, CF, cout, dataa, datab, sub);

    barrelsft32 my_barrel(sft_result, dataa, datab[4:0], LR, AL);

    always @(*) begin
        case(aluctr) 
            4'b0000: begin  //and
                sub = 0;
                _result = adder_result;
            end
            4'b0001: begin  //left shift
                LR = 1; AL = 0;
                _result = sft_result;
            end
            4'b0010: begin  //signed cmp
                sub = 1; SIG = 1;
                _result = cmp_result;
            end
            4'b0011: begin  //unsigned cmp
                sub = 1; SIG = 0;
                _result = cmp_result;
            end
            4'b0100: begin  //xor
                _result = dataa ^ datab;
            end
            4'b0101: begin  //right shift
                LR = 0; AL = 0;
                _result = sft_result;
            end
            4'b0110: begin
                _result = dataa | datab;
            end
            4'b1000: begin  //sub
                sub = 1;
                _result = adder_result;
            end
            4'b1101: begin  //al right shift
                LR = 0; AL = 1;
                _result = sft_result;
            end
            4'b1111: begin //load imm(datab)
                _result = datab;
            end
            default: begin
                _result = 32'd0;
            end
        endcase
    end

endmodule
