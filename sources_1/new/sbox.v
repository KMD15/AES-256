module sbox (
    input  wire [7:0] a,   
    output wire [7:0] y    
);
    //Functie pentru inmultirea a doi octeti in GF
    function [7:0] gf_mul8(input [7:0] a_in, input [7:0] b_in);
        reg [7:0] p; //rezultatul partial al produsului
        reg [7:0] a_temp;  //memorare octet a temporara
        reg [7:0] b_temp;  //memorare octet b temporara
        integer i;
        begin
        //initializare valori
            p = 8'h00;
            a_temp = a_in;
            b_temp = b_in;
            // algoritm de inmultire GF
            for (i = 0; i < 8; i = i + 1) begin //prelucram fiecare bit al lui b_temp
                if (b_temp[0] == 1'b1)       
                    p = p ^ a_temp; //daca LSB e 1, XOR cu p
                b_temp = b_temp >> 1;        // trecere la urmatorul bit
                
                if (a_temp[7] == 1'b1)  //daca MSB este 1, shift la stanga + XOR cu 1B
                    a_temp = (a_temp << 1) ^ 8'h1B;
                else
                    a_temp = a_temp << 1; //doar shift daca nu
            end
            gf_mul8 = p; //memoram valoarea finala
        end
    endfunction

    // Calculul puterilor lui a: a^2, a^4, a^8..
    wire [7:0] a2   = gf_mul8(a, a);
    wire [7:0] a4   = gf_mul8(a2, a2);
    wire [7:0] a8   = gf_mul8(a4, a4);
    wire [7:0] a16  = gf_mul8(a8, a8);
    wire [7:0] a32  = gf_mul8(a16, a16);
    wire [7:0] a64  = gf_mul8(a32, a32);
    wire [7:0] a128 = gf_mul8(a64, a64);

    // Combinații pentru a^{-1} = a^254 = a^(128+64+32+16+8+4+2)
    wire [7:0] temp1 = gf_mul8(a128, a64);    // a^192
    wire [7:0] temp2 = gf_mul8(a32, a16);     // a^48
    wire [7:0] temp3 = gf_mul8(a8, a4);       // a^12
    wire [7:0] temp4 = gf_mul8(temp3, a2);    // a^14
    wire [7:0] temp5 = gf_mul8(temp1, temp2); // a^240
    wire [7:0] a_inv = gf_mul8(temp5, temp4); // a^254 (inversul multiplicativ al lui a)

    // Aplicarea transformării afine (rotații bit și XOR cu 0x63)
    wire [7:0] rot1 = {a_inv[6:0], a_inv[7]};       // rotație circulară cu 1 bit
    wire [7:0] rot2 = {a_inv[5:0], a_inv[7:6]};     // rotație cu 2 biți
    wire [7:0] rot3 = {a_inv[4:0], a_inv[7:5]};     // rotație cu 3 biți
    wire [7:0] rot4 = {a_inv[3:0], a_inv[7:4]};     // rotație cu 4 biți

    assign y = a_inv ^ rot1 ^ rot2 ^ rot3 ^ rot4 ^ 8'h63;  // ieșirea S-Box
endmodule
