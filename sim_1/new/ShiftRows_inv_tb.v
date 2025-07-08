module ShiftRows_inv_tb();
reg [127:0] in;
wire [127:0] out;

ShiftRows_inv sri(in,out);

initial begin
 $monitor ("in = %h,out = %h",in,out);
 in = 128'h733e7fd2760cd973104b94689bd929fc;
end
endmodule
