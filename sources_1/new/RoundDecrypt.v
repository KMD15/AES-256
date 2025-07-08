 module RoundDecrypt(
    input [127:0] in,
    input [127:0] key,
    output [127:0] out
    );

wire [127:0] sr_sb;
wire [127:0] sb_ark;
wire [127:0] ark_mc;

ShiftRows_inv sr_inv(in,sr_sb);
SubByte_inv sb_inv(sr_sb,sb_ark);
AddRoundKey ark(sb_ark,key,ark_mc);
MixColumns_inv mc_inv(ark_mc,out);

endmodule
