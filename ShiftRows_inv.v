module ShiftRows_inv(
    input [127:0] in,
    output [127:0] out
    );
    
wire [127:0] shift;

//primul rand, ca la ShiftRows, ramane neschimbat.
assign shift[0+:8] = in[0+:8];
assign shift[32+:8] = in[32+:8];
assign shift[64+:8] = in[64+:8];
assign shift[96+:8] = in[96+:8];

//al doilea rand, shiftare la dreapta cu 1 octet.
assign shift[8+:8] = in[104+:8];
assign shift[40+:8] = in[8+:8];
assign shift[72+:8] = in[40+:8];
assign shift[104+:8] = in[72+:8];

//al treilea rand, shiftare la dreapta cu 2 octeti.
assign shift[16+:8] = in[80+:8];
assign shift[48+:8] = in[112+:8];
assign shift[80+:8] = in[16+:8];
assign shift[112+:8] = in[48+:8];

//al patrulea rand, shiftare la dreapta cu 3 octeti.
assign shift[24+:8] = in[56+:8];
assign shift[56+:8] = in[88+:8];
assign shift[88+:8] = in[120+:8];
assign shift[120+:8] = in[24+:8];

assign out = {shift[95:0],shift[127:96]};

endmodule
