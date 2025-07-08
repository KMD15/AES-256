`timescale 1ns / 1ps
module SubBytes_tb;
reg [127:0] in;
wire [127:0]out;

SubByte sb(in,out);

initial begin

in=128'h00112233_4a5b6a7b_8c9dacbd_ccddeeff;
#10;
$finish;
end
endmodule
