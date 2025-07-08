module SubByte_inv_tb();

reg [127:0] in;
wire [127:0] out;

SubByte_inv sbi(in,out);
initial begin

in=128'h73d9_9473_763e_2968_100c_7ffc_9b4b_d9d2;

#10
$finish;

end
endmodule
