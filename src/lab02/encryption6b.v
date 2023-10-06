`timescale 1ns / 1ps

module encryption6b(
    output [7:0] dataout,
    output reg ready,    
    output [5:0] key,    
    input clk,           
    input load,           
    input [7:0] datain   
    );
    wire  [63:0] seed=64'ha845fd7183ad75c4;     
    reg [2:0] cnt;
    wire [63:0] _dout;
    assign key = _dout[63:58];
    
    lfsr gen(.dout(_dout), .seed(seed), .clk(clk), .load(load));
    assign dataout = datain ^ _dout[63:58];
    
    always @(posedge clk) begin
        if(load) begin
            cnt <= 0;
            ready <= 0;
        end else begin
            if(cnt == 5) begin
                cnt <= 0;
                ready <= 1;
            end else begin
                cnt <= cnt + 1;
                ready <= 0;
            end
        end
    end
endmodule

module lfsr(            
	output reg [63:0] dout,
    input  [63:0]  seed,
	input  clk,
	input  load
	);
    
    always @(posedge clk) begin
        if(load)
            dout <= seed;
        else
            dout <= {dout[4] ^ dout[3] ^ dout[1] ^ dout[0],dout[63:1]};
    end
endmodule
