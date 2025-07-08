
`timescale 1 ns / 1 ps

	module aes256_wrapper #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface SlaveAES_AXI
		parameter integer C_SlaveAES_AXI_DATA_WIDTH	= 32,
		parameter integer C_SlaveAES_AXI_ADDR_WIDTH	= 7
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface SlaveAES_AXI
		input wire  slaveaes_axi_aclk,
		input wire  slaveaes_axi_aresetn,
		input wire [C_SlaveAES_AXI_ADDR_WIDTH-1 : 0] slaveaes_axi_awaddr,
		input wire [2 : 0] slaveaes_axi_awprot,
		input wire  slaveaes_axi_awvalid,
		output wire  slaveaes_axi_awready,
		input wire [C_SlaveAES_AXI_DATA_WIDTH-1 : 0] slaveaes_axi_wdata,
		input wire [(C_SlaveAES_AXI_DATA_WIDTH/8)-1 : 0] slaveaes_axi_wstrb,
		input wire  slaveaes_axi_wvalid,
		output wire  slaveaes_axi_wready,
		output wire [1 : 0] slaveaes_axi_bresp,
		output wire  slaveaes_axi_bvalid,
		input wire  slaveaes_axi_bready,
		input wire [C_SlaveAES_AXI_ADDR_WIDTH-1 : 0] slaveaes_axi_araddr,
		input wire [2 : 0] slaveaes_axi_arprot,
		input wire  slaveaes_axi_arvalid,
		output wire  slaveaes_axi_arready,
		output wire [C_SlaveAES_AXI_DATA_WIDTH-1 : 0] slaveaes_axi_rdata,
		output wire [1 : 0] slaveaes_axi_rresp,
		output wire  slaveaes_axi_rvalid,
		input wire  slaveaes_axi_rready
	);

wire [127:0] data_in;
wire [255:0] data_key;
wire [127:0] data_out;
wire data_start;
wire data_done;

// Instantiation of Axi Bus Interface SlaveAES_AXI
	axil_interface # ( 
		.C_S_AXI_DATA_WIDTH(C_SlaveAES_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_SlaveAES_AXI_ADDR_WIDTH)
	) axil_interface_inst (
		.S_AXI_ACLK(slaveaes_axi_aclk),
		.S_AXI_ARESETN(slaveaes_axi_aresetn),
		.S_AXI_AWADDR(slaveaes_axi_awaddr),
		.S_AXI_AWPROT(slaveaes_axi_awprot),
		.S_AXI_AWVALID(slaveaes_axi_awvalid),
		.S_AXI_AWREADY(slaveaes_axi_awready),
		.S_AXI_WDATA(slaveaes_axi_wdata),
		.S_AXI_WSTRB(slaveaes_axi_wstrb),
		.S_AXI_WVALID(slaveaes_axi_wvalid),
		.S_AXI_WREADY(slaveaes_axi_wready),
		.S_AXI_BRESP(slaveaes_axi_bresp),
		.S_AXI_BVALID(slaveaes_axi_bvalid),
		.S_AXI_BREADY(slaveaes_axi_bready),
		.S_AXI_ARADDR(slaveaes_axi_araddr),
		.S_AXI_ARPROT(slaveaes_axi_arprot),
		.S_AXI_ARVALID(slaveaes_axi_arvalid),
		.S_AXI_ARREADY(slaveaes_axi_arready),
		.S_AXI_RDATA(slaveaes_axi_rdata),
		.S_AXI_RRESP(slaveaes_axi_rresp),
		.S_AXI_RVALID(slaveaes_axi_rvalid),
		.S_AXI_RREADY(slaveaes_axi_rready),
		
		.data_in(data_in),
		.data_out(data_out),
		.data_key(data_key),
		.data_start(data_start),
		.data_done(data_done),
		.data_reset(data_reset)
	);

	// Add user logic here
    Encrypt #(
  .nr(14),   
  .nk(8)     
) Encrypt(
        .in(data_in),
        .key(data_key),
        .out(data_out),
        .reset(~slaveaes_axi_aresetn),
        .clk(slaveaes_axi_aclk),
        .start(data_start),
        .done(data_done)
    );
	// User logic ends
endmodule

