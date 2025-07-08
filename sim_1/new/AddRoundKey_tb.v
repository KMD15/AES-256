module AddRoundKey_tb;

reg [127:0] in;
reg [127:0] key;
wire [127:0] out;	


AddRoundKey ark (
        .in(in), 
        .round_key(key), 
        .out(out)
    );


initial begin
	$monitor("input= %H, output= %h, key = %h", in, out, key);
	in = 128'h_00112233_44556677_8899aabb_ccddeeff;
	key =128'h_00112233_44556677_8899aabb_ccddeeff;
	#10
	$finish;
	
end
endmodule