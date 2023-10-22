`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/09 23:04:22
// Design Name: 
// Module Name: kbcode2ascii
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

module kbcode2ascii(
      output reg [7:0] asciicode,
      input [7:0] kbcode
);  
    always @(kbcode) begin
        case(kbcode)
        8'h0D: asciicode <= 8'h20;
        8'h0E: asciicode <= 8'h60; 
        8'h15: asciicode <= 8'h71; 
        8'h16: asciicode <= 8'h31;
        8'h1A: asciicode <= 8'h7A; 
        8'h1B: asciicode <= 8'h73; 
        8'h1C: asciicode <= 8'h61; 
        8'h1D: asciicode <= 8'h77; 
        8'h1E: asciicode <= 8'h32; 
        8'h21: asciicode <= 8'h63; 
        8'h22: asciicode <= 8'h78; 
        8'h23: asciicode <= 8'h64; 
        8'h24: asciicode <= 8'h65; 
        8'h25: asciicode <= 8'h34; 
        8'h26: asciicode <= 8'h33; 
        8'h29: asciicode <= 8'h20; 
        8'h2A: asciicode <= 8'h76; 
        8'h2B: asciicode <= 8'h66; 
        8'h2C: asciicode <= 8'h74; 
        8'h2D: asciicode <= 8'h72; 
        8'h2E: asciicode <= 8'h35; 
        8'h31: asciicode <= 8'h6E; 
        8'h32: asciicode <= 8'h62; 
        8'h33: asciicode <= 8'h68; 
        8'h34: asciicode <= 8'h67; 
        8'h35: asciicode <= 8'h79; 
        8'h36: asciicode <= 8'h36; 
        8'h3A: asciicode <= 8'h6D; 
        8'h3B: asciicode <= 8'h6A; 
        8'h3C: asciicode <= 8'h75; 
        8'h3D: asciicode <= 8'h37; 
        8'h3E: asciicode <= 8'h38;
        8'h41: asciicode <= 8'h2C ;
        8'h42: asciicode <= 8'h6B ;
        8'h43: asciicode <= 8'h69 ;
        8'h44: asciicode <= 8'h6F ;
        8'h45: asciicode <= 8'h30 ;
        8'h46: asciicode <= 8'h39 ;
        8'h49: asciicode <= 8'h2E ;
        8'h4A: asciicode <= 8'h2F ;
        8'h4B: asciicode <= 8'h6C ;
        8'h4C: asciicode <= 8'h3A ;
        8'h4D: asciicode <= 8'h71 ;
        8'h4E: asciicode <= 8'h2D ;
        8'h52: asciicode <= 8'h27 ;
        8'h54: asciicode <= 8'h5B ;
        8'h55: asciicode <= 8'h3D ;
        8'h5A: asciicode <= 8'h0D ;
        8'h5B: asciicode <= 8'h5D ;
        8'h5D: asciicode <= 8'h5C ;
        8'h66: asciicode <= 8'h08 ;
        8'h69: asciicode <= 8'h31 ;
        8'h6B: asciicode <= 8'h34 ;
        8'h6C: asciicode <= 8'h37 ;
        8'h70: asciicode <= 8'h30 ;
        8'h71: asciicode <= 8'h2E ;
        8'h72: asciicode <= 8'h32 ;
        8'h73: asciicode <= 8'h35 ;
        8'h74: asciicode <= 8'h36 ;
        8'h75: asciicode <= 8'h38 ;
        8'h79: asciicode <= 8'h2B ;
        8'h7A: asciicode <= 8'h33 ;
        8'h7B: asciicode <= 8'h2C ;
        8'h7C: asciicode <= 8'h2A ;
        8'h7D: asciicode <= 8'h39 ;
        default: asciicode <= 8'h00;
        endcase
    end
endmodule
