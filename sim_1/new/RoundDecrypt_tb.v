module RoundDecrypt_tb();

    reg [127:0] in;
    reg [127:0] key;
    wire [127:0] out;

RoundDecrypt rd(in,key,out);

initial begin
in = 128'h63ed08731adbdbc773dffdf516ca8579;
key =128'h00102030405060708090a0b0c0d0e0f0;

end
endmodule
