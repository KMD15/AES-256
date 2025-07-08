`timescale 1ns / 1ps

module MixColumns_tb;
reg [127:0] in;
wire [127:0] out;

MixColumns mc(in,out);

initial begin
$monitor("input= %h ,output= %h",in,out);
in=128'h637bc0d27b76d27c76757cc57563c5c0;
#10
$finish;
end
endmodule
