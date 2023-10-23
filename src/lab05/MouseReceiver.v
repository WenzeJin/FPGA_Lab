`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/13 23:05:31
// Design Name: 
// Module Name: MouseReceiver
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


module MouseReceiver(
    output [6:0]SEG,
    output [7:0]AN,
    output DP,
    output LeftButton,   //左键按下
    output MiddleButton,
    output RightButton,  //左键按下
    input CLK100MHZ,
    input PS2_CLK,
    input PS2_DATA
    );

    reg [7:0]datacur;              //当前扫描码
    reg [3:0]cnt;                //收到串行位数
    reg [1:0]bytecnt;
    reg INIT;
    reg ID;
    reg scroll;
    reg readyflag;
    
    reg XOVF;
    reg YOVF;
    reg MBTN;
    reg LBTN;
    reg RBTN;

    reg [8:0] XData;
    reg [8:0] YData;
    reg [3:0] ZData;

    assign LeftButton = LBTN;
    assign RightButton = RBTN;
    assign MiddleButton = MBTN;

    seg7decimal segs(
        .x(XData),
        .y(YData),
        .z(ZData),
        .clk(CLK100MHZ),
        .seg(SEG),
        .an(AN),
        .dp(DP)
    );


    always @(posedge PS2_CLK) begin
        case(cnt)
            0:readyflag<=1'b0;                       //开始位
            1:datacur[0]<=PS2_DATA;
            2:datacur[1]<=PS2_DATA;
            3:datacur[2]<=PS2_DATA;
            4:datacur[3]<=PS2_DATA;
            5:datacur[4]<=PS2_DATA;
            6:datacur[5]<=PS2_DATA;
            7:datacur[6]<=PS2_DATA;
            8:datacur[7]<=PS2_DATA;
            9:begin
                if (!INIT) begin
                    if (datacur == 8'hAA) begin
                        INIT <= 1;
                    end else begin
                        INIT <= 0;
                    end
                end else if (!ID) begin
                    ID <= 1;
                    if (datacur == 8'h03) begin
                        scroll <= 1 ;
                    end
                end else begin
                    case(bytecnt)
                    0: begin
                        YOVF <= datacur[7]; XOVF <= datacur[6]; YData[8] <= datacur[5]; XData[8] <= datacur[4]; 
                        MBTN <= datacur[2]; RBTN <= datacur[1]; LBTN <= datacur[0];
                        bytecnt <= 1;
                    end
                    1: begin
                        XData[7:0] <= datacur;
                        bytecnt <= 2;
                    end
                    2: begin
                        YData[7:0] <= datacur;
                        if (scroll) begin
                            bytecnt <= 3;
                        end else begin
                            bytecnt <= 0;
                        end
                    end
                    3: begin
                        ZData[3:0] <= datacur[3:0];
                        bytecnt <= 0;
                    end
                    endcase
                end
            end
            10:readyflag <= 1'b0;       //结束位
        endcase
        if(cnt<=9) cnt <= cnt+1;
        else if(cnt==10)  cnt<=0;
    end
    
endmodule


module seg7decimal(
	input signed [8:0] x,
    input signed [8:0] y,
    input signed [3:0] z,
    input clk,
    output reg [6:0] seg,
    output reg [7:0] an,
    output wire dp 
	 );

    wire [8:0] real_x;
    wire [8:0] real_y;
    wire [3:0] real_z;

    assign real_x = (x < 0) ? 0 - x : x;
    assign real_y = (y < 0) ? 0 - y : y;
    assign real_z = (z < 0) ? 0 - z : z;

	wire [2:0] s;	 
	reg [4:0] digit;
	wire [7:0] aen;
	reg [19:0] clkdiv;

	assign dp = 1;
	assign s = clkdiv[19:17];
	assign aen = 8'b11111111; // all turned off initially

	// quad 4to1 MUX.


	always @(posedge clk)// or posedge clr)
		case(s)
		0:digit = {1'b0, real_z[3:0]}; // s is 00 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
		1:digit = z[3] ? 'h11: 'h10; // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
		2:digit = {1'b0, real_y[3:0]}; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8
		3:digit = {1'b0, real_y[7:4]}; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]
		4:digit = y[8] ? 'h11: 'h10; // s is 00 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
		5:digit = {1'b0, real_x[3:0]}; // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
		6:digit = {1'b0, real_x[7:4]}; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8]
		7:digit = x[8] ? 'h11: 'h10; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]
		default:digit = x[3:0];
		endcase
		
	//decoder or truth-table for 7seg display values
	always @(*)
		case(digit)
		//////////<---MSB-LSB<---
		//////////////gfedcba////////////////////////////////////////////           a
		0:seg = 7'b1000000;////0000												   __					
		1:seg = 7'b1111001;////0001												f/	  /b
		2:seg = 7'b0100100;////0010												  g
		//                                                                       __	
		3:seg = 7'b0110000;////0011										 	 e /   /c
		4:seg = 7'b0011001;////0100										       __
		5:seg = 7'b0010010;////0101                                            d  
		6:seg = 7'b0000010;////0110
		7:seg = 7'b1111000;////0111
		8:seg = 7'b0000000;////1000
		9:seg = 7'b0010000;////1001
		'hA:seg = 7'b0001000; 
		'hB:seg = 7'b0000011; 
		'hC:seg = 7'b1000110;
		'hD:seg = 7'b0100001;
		'hE:seg = 7'b0000110;
		'hF:seg = 7'b0001110;
        'h10:seg = 7'b1111111;
        'h11:seg = 7'b0111111;
		default: seg = 7'b0000000; // U
		endcase


	always @(*) begin
		an = 8'b11111111;
		if(aen[s] == 1)
			an[s] = 0;
	end


	//clkdiv

	always @(posedge clk) begin
		clkdiv <= clkdiv+1;
	end
endmodule
