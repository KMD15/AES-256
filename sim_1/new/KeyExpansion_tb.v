`timescale 1ns / 1ps

module KeyExpansion_tb;
    
reg [255:0] key;  // Cheia inițială de 256 de biți
wire [1919:0] w1;  // Cheile extinse (60 * 32 biți = 1920 biți)


    KeyExpansion #(8, 14) dut (key, w1);

    initial begin
        $monitor("Time=%0t | Key: %h | Expanded Key: %h", $time, key, w1);
        
        key = 256'h1020_3040_5060_7080_90a0_b0c0_d0e0_f010_2030_4050_6070_8090_a0b0_c0d0_e0f0_1020;

        
        #20; 
        $finish;
    end

endmodule

