module RoundEncrypt_tb();

    reg [127:0] in;
    reg [127:0] key;
    wire [127:0] out;

RoundEncrypt re(in,key,out);

initial begin
in = 128'h2010_0070_6050_40b0_a090_80f0_e0d0_c020;
key = 128'h102030405060708090a0b0c0d0e0f0102030405060708090a0b0c0d0e0f01020;

end
endmodule
