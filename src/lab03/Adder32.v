`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 22:02:10
// Design Name: 
// Module Name: Adder32
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


module Adder32(
      output [31:0] f,
      output OF, SF, ZF, CF,
      output cout,
      input [31:0] x, y,
      input sub
	);
//add your code here

endmodule
module CLA_16(
       output wire [15:0] f,
       output wire  cout, 
       input [15:0] x, y,
       input cin
  );
 //add your code here


 endmodule
module CLA_group (
     output [3:0] f,
     output pg,gg,
     input [3:0] x, y,
      input cin
);


endmodule

module CLU (
      output [4:1] c,
      input [4:1] p, g,
      input c0
);


endmodule
module FA_PG (
     output f, p, g,
     input x, y, cin
	);

	
	endmodule
