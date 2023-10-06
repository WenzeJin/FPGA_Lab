`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2023/09/17 13:48:41
// Module Name: DigitalTimer
// Created By: Jin Wenze
//////////////////////////////////////////////////////////////////////////////////


module DigitalTimer(  
    input clk,
    input rst,
    input [1:0] s,        
    input [3:0] data_h,   
    input [3:0] data_l,   
    output [6:0] segs,   
    output [7:0] an,     
    output [2:0] ledout
    ); 
    
    //Display diver.
    wire [3:0] display_buffer [0:7]; //display loop will scan this buffer
    reg [3:0] dis_cur;               //current display number in display loop
    reg [3:0] dis_pos;               //current display position in display loop
                                     //if dis_pos > 8 will display nothing
    reg [3:0] dis_cnt;               //current display bit of LEDs
    reg [15:0] trans;                //control the fresh rate of LEDs
    //Time registers.
    reg [3:0] H_hi;                  //high digit of hour
    reg [3:0] H_lo;
    reg [3:0] M_hi;
    reg [3:0] M_lo;
    reg [3:0] S_hi;
    reg [3:0] S_lo;
    //Assign display buffer to time registers.
    assign display_buffer[7] = H_hi;
    assign display_buffer[6] = H_lo;
    assign display_buffer[5] = 4'b1111;  //will end up display nothing
    assign display_buffer[4] = M_hi;
    assign display_buffer[3] = M_lo;
    assign display_buffer[2] = 4'b1111;
    assign display_buffer[1] = S_hi;
    assign display_buffer[0] = S_lo;
    //RGB
    reg [3:0] remaining;
    reg [2:0] color;
    assign ledout = color;
    
    //1Hz clk signal
    wire clk1hz;
    //Display module
    clkgen transfer(.clkin(clk), .rst(0), .clken(1), .clkout(clk1hz));
    dec7seg disp(.I(dis_cur), .S(dis_pos), .O_seg(segs), .O_led(an));
    
    //Display driving loop
    always @(posedge clk) begin
        //Transfer clk signal to acceptable fresh rate.
        if(trans >= 16'd50000)
            trans <= 0;
        else
            trans <= trans + 1;
            
        if(trans == 0) begin
            if(dis_cnt >= 7)
                dis_cnt <= 0;
            else
                dis_cnt <= dis_cnt + 1;
        end
        
        //Display
        if(display_buffer[dis_cnt] >= 0 && display_buffer[dis_cnt] < 10) begin
            dis_pos <= dis_cnt;
            dis_cur <= display_buffer[dis_cnt];
        end else begin
            dis_pos <= 8;               //end up display nothing
            dis_cur <= display_buffer[dis_cnt];
        end
    end

    
    
    //Time refresh loop.
    always @(posedge clk1hz) begin
        //Time set. Invalid input will be dismissed.
        if(rst) begin
            H_hi <= 4'b0000;
            H_lo <= 4'b0000;
            M_hi <= 4'b0000;
            M_lo <= 4'b0000;
            S_hi <= 4'b0000;
            S_lo <= 4'b0000;
            color <= 3'b000;
            remaining <= 4'b0000;
        end else begin
            if(s == 2'b11) begin
                if(data_h >= 0 && data_h <= 5) begin
                    if(data_l >= 0 && data_l <= 9) begin
                        S_hi <= data_h;
                        S_lo <= data_l;
                end end
            end
            if(s == 2'b10) begin
                if(data_h >= 0 && data_h <= 5) begin
                    if(data_l >= 0 && data_l <= 9) begin
                        M_hi <= data_h;
                        M_lo <= data_l;
                end end
            end
            if(s == 2'b01) begin
                if(data_h == 0 || data_h == 1) begin
                    if(data_l >= 0 && data_l <= 9) begin
                        H_hi <= data_h;
                        H_lo <= data_l;
                end end
                if(data_h == 2) begin
                    if(data_l >= 0 && data_l <= 3) begin
                        H_hi <= data_h;
                        H_lo <= data_l;
                end end
            end
            
            //Timer
            if(s == 2'b00) begin    //previous time
                //RGB control
                if(remaining) begin
                    remaining <= remaining - 1;
                    color <= {color[1:0], color[2]};
                end else begin
                    color <= 3'b000;
                end
            
                if(S_lo == 9) begin //xx:xx:x9
                    if(S_hi == 5) begin //xx:xx:59
                        if(M_lo == 9) begin //xx:x9:59
                            if(M_hi == 5) begin //xx:59:59
                                if(H_lo == 3 && H_hi == 2) begin //23:59:59
                                    remaining <= 9; //RGB trigger
                                    color <= 3'b001;
                                    H_lo <= 0;
                                    H_hi <= 0;
                                end else begin
                                    if(H_lo == 9) begin //x9:59:59
                                        H_lo <= 0;
                                        H_hi <= H_hi + 1;
                                    end else begin
                                        H_lo <= H_lo + 1;
                                    end
                                    remaining <= 4; //RGB Trigger
                                    color <= 3'b001;
                                end
                                M_hi <= 0;
                            end else begin
                                M_hi <= M_hi + 1;
                            end
                            M_lo <= 0;
                        end else begin
                            M_lo <= M_lo + 1;
                        end
                        S_hi <= 0;
                    end else begin
                        S_hi <= S_hi + 1;
                    end
                    S_lo <= 0;
                end else begin
                    S_lo <= S_lo + 1;
                end
            end
        end
    end
endmodule


