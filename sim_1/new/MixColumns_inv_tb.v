module MixColumns_inv_tb();
    reg [127:0] in;
    wire [127:0] out;
    
MixColumns_inv mc_inv(in,out);

initial begin

in = 128'h3e313f6d85acf52d61fad88ba4aaac3e;

end
endmodule
