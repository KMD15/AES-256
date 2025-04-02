module RoundEncrypt(
    input [127:0] in,
    input [127:0] key,
    output [127:0] out
    );

wire [127:0] sb_sr;
wire [127:0] sr_mc;
wire [127:0] mc_ark;

SubByte SB(in,sb_sr);
ShiftRows SR(sb_sr, sr_mc);
MixColumns MC(sr_mc,mc_ark);
AddRoundKey ARK(mc_ark, key, out);

endmodule
