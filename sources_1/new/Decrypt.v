module Decrypt#(parameter nr=14,parameter nk=8,parameter n=256)(
input [127:0] in,
input [255:0] key,
output [127:0] out
);
wire [(128*(nr+1))-1 :0] allkeys;
wire [127:0] state [nr+1:0] ;
wire [127:0] sr_sb;
wire [127:0] sb_ark;

KeyExpansion #(nk,nr) ke (key,allkeys);

AddRoundKey addrk1 (in,allkeys[127:0], state[0]);

genvar i;
generate
	
	for(i=1; i<nr ;i=i+1)begin : loop
		RoundDecrypt dr(state[i-1],allkeys[i*128+:128],state[i]);
		
		end
		ShiftRows_inv sr_inv(state[nr-1],sr_sb);
		SubByte_inv sb_inv(sr_sb,sb_ark);
		AddRoundKey addrk2(sb_ark,allkeys[((128*(nr+1))-1)-:128],state[nr]);

assign out=state[nr];

endgenerate
endmodule