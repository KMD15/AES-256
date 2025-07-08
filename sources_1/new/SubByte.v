module SubByte (
    input  wire [127:0] in,
    output wire [127:0] out
);
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 8) begin : sb_inst
            sbox u_sbox (
                .a(in[i +: 8]),   
                .y(out[i +: 8])   
            );
        end
    endgenerate
endmodule
