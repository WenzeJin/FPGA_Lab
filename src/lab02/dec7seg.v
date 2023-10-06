`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 21:13:09
// Design Name: 
// Module Name: dec7seg
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


module dec7seg(
    output  reg  [6:0] O_seg,  
    output  reg  [7:0] O_led,  
    input   [3:0] I,           
    input   [3:0] S          
    );  
    always @(*)
    case (I)
        0: O_seg = 7'b1000000;
        1: O_seg = 7'b1111001;
        2: O_seg = 7'b0100100;
        3: O_seg = 7'b0110000;
        4: O_seg = 7'b0011001;
        5: O_seg = 7'b0010010;
        6: O_seg = 7'b0000010;
        7: O_seg = 7'b1111000;
        8: O_seg = 7'b0000000;
        9: O_seg = 7'b0010000;
        10: O_seg = 7'b0001000;
        11: O_seg = 7'b0000011;
        12: O_seg = 7'b1000110;
        13: O_seg = 7'b0100001;
        14: O_seg = 7'b0000110;
        15: O_seg = 7'b0001110;
        default: O_seg = 7'b1111111;
    endcase


    integer i;
    always @(*)
        for (i = 0; i < 8; i = i + 1)
            if(S < 8)
                O_led[i] <=(i!=S);
            else
                O_led[i] <= 1;
            
endmodule
