module MixColumns(
    input [127:0] in,
    output [127:0] out
    );


//MULTIPLICARE CU 2 (ECHIVALENT CU SHIFT LA STANGA, PUNEM CONDITIE PENTRU MSB, DACA E 1 SE FACE SHIFT CU XOR LA 1b)
function [7:0] mult_2;
    input[7:0] a;
        begin
        if(a[7] == 1) //VERIFICARE MSB = 1;
            mult_2 = ( (a<<1) ^ 8'h1b); //XOR cu (1b = x^4 + x^3 + x + 1 = 0001 1011);
            else mult_2 = a<<1; 
end
endfunction

//MULTIPLICARE CU 3 (ECHIVALENT CU MULTIPLICAREA CU 2, FACAND INCA UN XOR CU FUNCTIA RESPECTIVA)
function [7:0] mult_3;
    input [7:0] b;
    begin mult_3 = mult_2(b) ^ b;
end
endfunction 

genvar i; //declar cu genvar pentru ca isi schimba valoarea pe parcursul compilarii
generate 
// GENEREZ FIECARE LINIE PRIN INTERMEDIUL MATRICEI DATE
for (i=0;i<4;i=i+1) begin : mc

  assign out[ (i*32 + 24) +:8]=  mult_2(in[(i*32 + 24) +:8]) ^ mult_3(in[(i*32 + 16) +:8]) 
                            ^ in[(i*32 + 8) +:8] ^ in[(i*32) +:8];

  assign out[(i*32 +16) +:8] = in[(i*32 + 24) +:8] ^ mult_2(in[(i*32 + 16) +:8])
                   ^ mult_3(in[(i*32 + 8) +:8]) ^in[(i*32) +:8];

  assign out[(i*32 + 8) +:8] = in[(i*32 + 24) +:8] ^ in[(i*32 + 16) +:8] ^ mult_2(in[(i*32 + 8) +:8])
                    ^ mult_3(in[(i*32) +:8]);

  assign out[(i*32) +:8] = mult_3(in[(i*32 + 24) +:8]) ^ in[(i*32 + 16) +:8]
                    ^ in[(i*32 + 8) +:8] ^ mult_2(in[(i*32) +:8]);                          
end

endgenerate

//S0: [127:120]  [119:112]  [111:104]  [103:96]  
//S1: [ 95:88 ]  [ 87:80 ]  [ 79:72 ]  [ 71:64]  
//S2: [ 63:56 ]  [ 55:48 ]  [ 47:40 ]  [ 39:32]  
//S3: [ 31:24 ]  [ 23:16 ]  [ 15:8  ]  [  7:0 ] 


endmodule
