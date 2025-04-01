module AddRoundKey (
    input   [127:0] in,      
    input   [256:0] round_key,  // AES-256 are 256 de biti dar imparte chei de 128 de biti in 14 runde.
    output  [127:0] out  
);


    assign out = in ^ round_key;
    
endmodule

