`timescale 1ns / 1ps

module KeyboardSim(
    input CLK100MHZ,   //系统时钟信号
    input PS2_CLK,    //来自键盘的时钟信号
    input PS2_DATA,  //来自键盘的串行数据位
    input BTNC,      //Reset
    output [6:0]SEG,
    output [7:0]AN,
    output [15:0] LED   //显示
);
    
    wire [31:0] display_buffer;
    wire [15:0] FLAGS;
    reg [15:0] cnt;
    wire [7:0] ASCIIout;
    reg [7:0] ASCII;
    wire [31:0] key_buffer;

    reg CLK50MHZ = 0;

    reg [7:0] curr_key;
    reg [7:0] prev_key;
 
    reg CapsLock;
    reg NumLock;
    wire Shift;
    wire Control;
    wire Alt;
    reg LShift;
    reg RShift;
    reg LControl;
    reg RControl;
    reg LAlt;
    reg RAlt;
    assign Shift = LShift | RShift;
    assign Control = LControl | RControl;
    assign Alt = LAlt | RAlt;

    wire out_ready;

    assign FLAGS[15] = CapsLock;
    assign FLAGS[14] = NumLock;
    assign FLAGS[13] = Shift;
    assign FLAGS[12] = Control;
    assign FLAGS[11] = Alt;
    assign FLAGS[7:0] = ASCII;
    assign LED = FLAGS;

    assign display_buffer[31:24] = cnt;
    assign display_buffer[23:16] = prev_key;
    assign display_buffer[15:8] = curr_key;
    assign display_buffer[7:0] = ASCII;
    //assign display_buffer = key_buffer;

    wire [7:0] currbyte;
    assign currbyte = key_buffer[7:0];

    //data prefixes
    wire E0Prefix;
    wire F0Prefix;
    

    seg7decimal sevenSeg (
        .x(display_buffer[31:0]),
        .clk(CLK100MHZ),
        .seg(SEG[6:0]),
        .an(AN[7:0]),
        .dp(0) 
    );

    KeyBoardReceiver keyboard_uut(
        .keycodeout(key_buffer[31:0]),
        .ready(out_ready),
        .E0(E0Prefix),
        .F0(F0Prefix),
        .clk(CLK50MHZ),
        .kb_clk(PS2_CLK),
        .kb_data(PS2_DATA)
    );
    
    kbcode2ascii asc(
      .asciicode(ASCIIout),
      .kbcode(curr_key)
    );

    always @(posedge CLK100MHZ) begin
        CLK50MHZ = ~CLK50MHZ;
    end
    
    always @(posedge CLK50MHZ) begin
        if ((CapsLock ^ Shift) && (ASCIIout >= 8'h61 && ASCIIout <= 8'h7A)) begin
            ASCII <= ASCIIout - 32;
        end else begin
            ASCII <= ASCIIout;
        end
    end
    
    always @(posedge out_ready) begin
        //Prefix cases
        if (F0Prefix && E0Prefix) begin
        
            case(currbyte)
            8'h11: RAlt <= 0;
            8'h14: RControl <= 0;
            endcase
            
        end else if (F0Prefix) begin
        
            case(currbyte)
            8'h14: LControl <= 0;
            8'h12: LShift <= 0;
            8'h11: LAlt <= 0;
            8'h59: RShift <= 0;
            endcase
            
        end else if (E0Prefix) begin
            cnt <= cnt + 1;
            
            prev_key <= curr_key;
            curr_key <= currbyte;
            
            case(currbyte)
            8'h11: RAlt <= 1;
            8'h14: RControl <= 1;
            endcase
            
        end else begin
            cnt <= cnt + 1;
            
            prev_key <= curr_key;
            curr_key <= currbyte;
            
            case(currbyte)
            8'h58: CapsLock <= ~CapsLock;
            8'h77: NumLock <= ~NumLock;
            8'h14: LControl <= 1;
            8'h12: LShift <= 1;
            8'h11: LAlt <= 1;
            8'h59: RShift <= 1;
            endcase
            
        end
    end
    
    
        
endmodule
