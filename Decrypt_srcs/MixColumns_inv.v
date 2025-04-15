module MixColumns_inv(
    input [127:0] in,
    output [127:0] out
    );
    
function [7:0] mult_n; //functie pentru multiplicarea cu 2 de n ori, ne va ajuta in realizarea multiplicarilor cu 09,0b,0d,0e
    input[7:0] a;
    input integer n;
    integer i;
        begin
        for(i = 0; i<n; i=i+1) begin
        if(a[7] == 1) //VERIFICARE MSB = 1;
            a = ( (a<<1) ^ 8'h1b); //XOR cu (1b = x^4 + x^3 + x + 1 = 0001 1011);
            else a = a<<1; 
         end
    mult_n = a;
    
end
endfunction   
// De ce nu am salvat direct in mult_n? Pentru ca "a" este prelucrat de mai multe ori, daca nu il inlocuiesc la fiecare loop, adios. 
 
 function [7:0] mult_09;
    input[7:0] a;
    begin
    mult_09 = mult_n(a,3) ^ a; //2^3 + 1 = 9
 end
 endfunction
 
 
  function [7:0] mult_0b;
    input[7:0] a;
    begin
    mult_0b = mult_n(a,3) ^ mult_n(a,1) ^ a; // 2^3 + 2^1 + 1 = 8 + 2 + 1 = b;
 end
 endfunction
 
 
  function [7:0] mult_0d;
    input[7:0] a;
    begin
    mult_0d = mult_n(a,3) ^ mult_n(a,2) ^ a; // 2^3 + 2^2 + 1 = 8 + 4 + 1 = d;
 end
 endfunction

 
function [7:0] mult_0e;  //multplicarea cu 0e;
    input [7:0] a;  
    begin
        mult_0e = mult_n(a,3) ^ mult_n(a,2) ^ mult_n(a,1);// 2^3 + 2^2+ 2^1 = 8 + 4 + 2 = e;
    end
endfunction 


genvar i; //declar cu genvar pentru ca isi schimba valoarea pe parcursul compilarii
generate 
// GENEREZ FIECARE LINIE PRIN INTERMEDIUL MATRICEI DATE
for (i=0;i<4;i=i+1) begin : mc

  assign out[ (i*32 + 24) +:8]=  mult_0e(in[(i*32 + 24) +:8]) ^ mult_0b(in[(i*32 + 16) +:8]) 
                            ^ mult_0d(in[(i*32 + 8) +:8]) ^ mult_09(in[(i*32) +:8]);

  assign out[(i*32 +16) +:8] = mult_09(in[(i*32 + 24) +:8]) ^ mult_0e(in[(i*32 + 16) +:8])
                   ^ mult_0b(in[(i*32 + 8) +:8]) ^ mult_0d(in[(i*32) +:8]);

  assign out[(i*32 + 8) +:8] = mult_0d(in[(i*32 + 24) +:8]) ^ mult_09(in[(i*32 + 16) +:8]) 
  ^ mult_0e(in[(i*32 + 8) +:8]) ^ mult_0b(in[(i*32) +:8]);

  assign out[(i*32) +:8] = mult_0b(in[(i*32 + 24) +:8]) ^ mult_0d(in[(i*32 + 16) +:8])
                    ^ mult_09(in[(i*32 + 8) +:8]) ^ mult_0e(in[(i*32) +:8]);                          
end

endgenerate 

//     S0         S1         S1         S2
// [127:120]  [119:112]  [111:104]  [103:96]  
// [ 95:88 ]  [ 87:80 ]  [ 79:72 ]  [ 71:64]  
// [ 63:56 ]  [ 55:48 ]  [ 47:40 ]  [ 39:32]  
// [ 31:24 ]  [ 23:16 ]  [ 15:8  ]  [  7:0 ] 
endmodule
