`timescale 1ns / 1ps

module Encrypt_tb();

    reg clk;
    reg reset;
    reg start;
    reg [127:0] in;
    reg [255:0] key;
    wire [127:0] out;
    wire done;

    // Instanțierea modulului Encrypt
    Encrypt uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .in(in),
        .key(key),
        .out(out),
        .done(done)
    );

    // Generare semnal de ceas
    always #5 clk = ~clk;

    initial begin
        // Inițializări
        clk = 0;
        reset = 1;
        start = 0;
        in = 128'h00112233445566778899AABBCCDDEEFF;
        key = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;

        // Reset activ pentru câțiva timpi
        #20;
        reset = 0;

        // Dăm start criptării
        #10;
        start = 1;
        #10;
        start = 0;

        // Așteptăm până când se setează semnalul done
        wait(done);

        // După ce se termină criptarea, afișăm rezultatul
        $display("OUT: %h", out);

        // Terminăm simularea
        #50;
        $finish;
    end

endmodule
