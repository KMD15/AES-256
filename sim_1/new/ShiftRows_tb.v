`timescale 1ns / 1ps


module shiftRows_tb;

reg [127:0] in;
wire [127:0] out;	


ShiftRows sr (in,out);


initial begin
	$monitor("input= %H , output= %h",in,out);
in=128'h_00112233_44556677_8899aabb_ccddeeff;
	#10;

end
endmodule
