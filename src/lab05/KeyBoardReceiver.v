`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/13 10:56:11
// Design Name: 
// Module Name: KeyBoardReceiver
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

module KeyBoardReceiver(
    output [31:0] keycodeout,           //接收到连续4个键盘扫描码
    output ready,                     //数据就绪标志位
    output F0,
    output E0,
    input clk,                        //系统时钟 
    input kb_clk,                    //键盘 时钟信号
    input kb_data                    //键盘 串行数据
    );


    reg [7:0]datacur;              //当前扫描码
    reg [3:0]cnt;                //收到串行位数
    reg [31:0]keycode;            //扫描码
    reg readyflag;

    reg F0Prefix;
    reg E0Prefix;
    reg pressed[0:255];
    reg E0pressed[0:255];
    reg E0_out;
    reg F0_out;
    assign E0 = E0_out;
    assign F0 = F0_out;


//    reg error;                   //错误标志位
    initial begin                 //初始化
        keycode[7:0]<=8'b00000000;
        cnt<=4'b0000;
    end
    //debouncer debounce( .clk(clk), .I0(kb_clk), .I1(kb_data), .O0(kclkf), .O1(kdataf));  //消除按键抖动
    always@(posedge kb_clk)begin
        case(cnt)
            0:readyflag<=1'b0;                       //开始位
            1:datacur[0]<=kb_data;
            2:datacur[1]<=kb_data;
            3:datacur[2]<=kb_data;
            4:datacur[3]<=kb_data;
            5:datacur[4]<=kb_data;
            6:datacur[5]<=kb_data;
            7:datacur[6]<=kb_data;
            8:datacur[7]<=kb_data;
            9:begin
                if (E0Prefix) begin
                    if (F0Prefix) begin
                        F0Prefix <= 0;
                        E0Prefix <= 0;
                        E0pressed[datacur] <= 0;    //release a key with E0
                        E0_out <= 1; F0_out <= 1; keycode <= {keycode[23:0], datacur}; 
                        readyflag <= 1;
                        //push the release key into keybuffer with signal E0 F0
                    end else begin
                        E0Prefix <= 0;
                        E0pressed[datacur] <= 1;
                        if (!E0pressed[datacur]) begin
                            E0pressed[datacur] <= 1;
                            E0_out <= 1; F0_out <= 0; keycode <= {keycode[23:0], datacur};
                            readyflag <= 1;
                        end
                    end
                end else if (F0Prefix) begin
                    if (datacur == 8'hE0) begin
                        E0Prefix <= 1;
                    end else begin
                        F0Prefix <= 0;
                        pressed[datacur] <= 0;
                        E0_out <= 0; F0_out <= 1; keycode <= {keycode[23:0], datacur}; 
                        readyflag <= 1;
                    end
                end else begin
                    if (datacur == 8'hF0) begin
                        F0Prefix <= 1;
                    end else if (datacur == 8'hE0) begin
                        E0Prefix <= 1;
                    end else begin
                        if (!pressed[datacur]) begin
                            pressed[datacur] <= 1;
                            E0_out <= 0; F0_out <= 0; keycode <= {keycode[23:0], datacur};
                            readyflag <= 1;
                        end
                    end
                end
            end
            10:readyflag <= 1'b0;       //结束位
        endcase
        if(cnt<=9) cnt<=cnt+1;
        else if(cnt==10)  cnt<=0;
    end

    assign keycodeout = keycode;
    assign ready = readyflag;    
endmodule

module debouncer(
    input clk,
    input I0,
    input I1,
    output reg O0,
    output reg O1
    );
    reg [4:0]cnt0, cnt1;
    reg Iv0=0,Iv1=0;
    reg out0, out1;
    always@(posedge(clk))begin
    if (I0==Iv0)begin
        if (cnt0==19) O0<=I0;   //接收到20次相同数据
        else cnt0<=cnt0+1;
      end
    else begin
        cnt0<="00000";
        Iv0<=I0;
    end
    if (I1==Iv1)begin
            if (cnt1==19) O1<=I1;  //接收到20次相同数据
            else cnt1<=cnt1+1;
          end
        else begin
            cnt1<="00000";
            Iv1<=I1;
        end
    end
endmodule
