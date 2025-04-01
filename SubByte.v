module SubByte(
    input [127:0] in,
    output [127:0] out
);

genvar i; //variabila pentru generate loop, permite schimbarea valorii pe perioada compilarii.
generate 

for(i=0;i<128;i=i+8) begin :sub_bytes //parcurgere fiecarui octet de biti/bloc, denumirea instantelor
	sbox s(in[i +:8],out[i +:8]);  //instantierea sbox pentru fiecare octet, realizeaza substitutia, se stocheaza in out rezultatul substitutiei.


end
endgenerate
endmodule