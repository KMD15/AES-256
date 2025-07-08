`timescale 1ns / 1ps

module tb();
  // 1) semnale top-level
  reg         clk_100MHz;
  reg         reset_rtl_0;
  wire [7:0] gpio_rtl_2_tri_o;
  wire  gpio_rtl_0_tri_o;
  reg   gpio_rtl_1_tri_i;
  reg         uart_rtl_0_rxd;
  wire        uart_rtl_0_txd;

  // 2) instanție hardware-ul complet
  design_1_wrapper dut (
    .clk_100MHz       (clk_100MHz),
    .reset_rtl_0      (reset_rtl_0),
    .gpio_rtl_0_tri_o (gpio_rtl_0_tri_o),
    .gpio_rtl_1_tri_i (gpio_rtl_1_tri_i),
    .uart_rtl_0_rxd   (uart_rtl_0_rxd),
    .uart_rtl_0_txd   (uart_rtl_0_txd),
    .gpio_rtl_2_tri_o   (gpio_rtl_2_tri_o)
  );

  // 3) clock 100MHz
  initial begin
    clk_100MHz = 0;
    forever #5 clk_100MHz = ~clk_100MHz;
  end

  // 4) puls de reset active-high 100 ns
  initial begin
    reset_rtl_0 <= 0;
    uart_rtl_0_rxd <=1;
    gpio_rtl_1_tri_i <=0;
    
    repeat(5)
        @(posedge clk_100MHz);
        reset_rtl_0 <= 1;
 
        repeat(500)
        @(posedge clk_100MHz);
        gpio_rtl_1_tri_i <=1;
        
        
        #100000000 $stop();
        
  end

 


endmodule
