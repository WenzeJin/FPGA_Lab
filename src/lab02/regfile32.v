`timescale 1ns / 1ps

module regfile32(
   output  [31:0] busa,
   output  [31:0] busb,
   input [31:0] busw,
   input [4:0] ra,
   input [4:0] rb,
   input [4:0] rw,
   input clk, we
);

reg [31:0] registers [0:31];  
always @(posedge clk) begin
    if (we) begin
        registers[rw] <= busw;
    end
end

assign busa = registers[ra];
assign busb = registers[rb];

endmodule

