module Decrypt_tb();
reg [127:0] in;
wire [127:0] out;
reg [255:0] key;


Decrypt #(14,8,256) Dec(in,key,out);


initial begin

$monitor("in= %h, key= %h ,out= %h",in,key,out);

in=128'h7a7e_81cf_1cb7_52ab_eef4_3a3b_1f7f_426a;

key = 256'h1020_3040_5060_7080_90a0_b0c0_d0e0_f010_2030_4050_6070_8090_a0b0_c0d0_e0f0_1020;

            

#100;
end

endmodule