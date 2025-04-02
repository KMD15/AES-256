 module Encrypt #(parameter nr=14,parameter nk=8,parameter n=256)(
    input [127:0] in,
    input [255:0] key,
    output [127:0] out
);

wire [128*(nr+1) : 0] allkeys; //stocheaza cheile de runda
wire [127:0] state[nr+1:0] ;
wire [127:0] sb_sr;
wire [127:0] sr_ark;

KeyExpansion #(nk,nr) keyexp(key,allkeys);
AddRoundKey ark_start (in,allkeys[((128*(nr+1))-1)-:128],state[0]);//stocam prima cheie de runda;

genvar i;
generate
    for(i=1;i<nr;i=i+1) begin
        RoundEncrypt RE(state[i-1],allkeys[((128*(nr+1)-1)-128*i)-:128],state[i]);
    end
    
    SubByte sb(state[nr-1],sb_sr);
    ShiftRows sr(sb_sr,sr_ark);
    AddRoundKey ark_end(sr_ark,allkeys[127:0], state[nr]);
 
 assign out = state[nr];
    
endgenerate

endmodule