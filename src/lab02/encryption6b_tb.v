`timescale 1ns / 1ps


module encryption6b_tb(
);
    wire [7:0] dataout;
    wire ready;
    wire [5:0] key;
    reg clk;
    reg load;
    reg [7:0] datain;
    reg [7:0] stored;
    encryption6b encryption6b1(.dataout(dataout),.ready(ready),.key(key),.clk(clk),.load(load),.datain(datain));
    integer i;
    always #5 clk=~clk;
    initial begin
        datain=8'b00000000;
        load=1;
        #10;
        clk = 1;
        #10;
        load=0;
        for (i=0;i<12;i=i+1) begin
            #10;
        end
        $stop(1);
    end
endmodule
