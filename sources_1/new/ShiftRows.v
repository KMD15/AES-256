module ShiftRows (
    input [127:0] in,
    output [127:0] out
);

wire [127:0] shift;

// !!REGULA GENERALA!!
//      PENTRU A COBORI CATE UN RAND, ADUNAM LA OUT 8 BITI, REGULA DE SHIFTARE PENTRU FIECARE RAND ESTE SA ADUNI NR BITULUI
//       DE LA OUT CU nr_rand*32

    assign shift[0+:8] = in[0+:8];
	assign shift[32+:8] = in[32+:8];
	assign shift[64+:8] = in[64+:8];
   assign shift[96+:8] = in[96+:8];
//Primul rand ramane complet neschimbat la iesire.

   assign shift[8+:8] = in[40+:8];
   assign shift[40+:8] = in[72+:8];
   assign shift[72+:8] = in[104+:8];
   assign shift[104+:8] = in[8+:8];
//Al doilea rand se shifteaza la stanga cu cate un octet.

   assign shift[16+:8] = in[80+:8];
   assign shift[48+:8] = in[112+:8];
   assign shift[80+:8] = in[16+:8];
   assign shift[112+:8] = in[48+:8];
//Al treilea rand se schifteaza la stanga cu cate doi octeti.	

   assign shift[24+:8] = in[120+:8];
   assign shift[56+:8] = in[24+:8];
   assign shift[88+:8] = in[56+:8];
   assign shift[120+:8] = in[88+:8];
//Ultimul rand se shifteaza la stanga cu 3 octeti.
assign out = {shift[31:0],shift[127:32]};
endmodule
