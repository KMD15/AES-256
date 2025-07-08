module AES_256_tb(
   );

reg [127:0] in;
reg [255:0] key;
wire [127:0] out;

AES_256 a_256(in,key,out);

initial begin

$monitor("in= %h, key= %h ,out= %h",in,key,out);

in=128'h3030_3030_3030_3030_3030_3030_3030_3030;

key = 256'h3030_3030_3030_3030_3030_3030_3030_3030_3030_3030_3030_3030_3030_3030_3030_3030;

end 
endmodule
