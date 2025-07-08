module AES_256(
    input [127:0] in,
    input [127:0] key,
    output [127:0] out
    );
 wire [127:0] pass;
 
Encrypt #(14,8,256) enc (in,key,pass);

Decrypt #(14,8,256) dec (pass,key,out);

endmodule
