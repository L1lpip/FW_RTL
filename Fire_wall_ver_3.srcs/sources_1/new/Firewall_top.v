`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2026 09:40:30 PM
// Design Name: 
// Module Name: Fire_wall_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Fire_wall_top #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input wire clk,
    input wire rst_n,

    input  wire [ADDR_WIDTH-1:0] paddr,
    input  wire                  psel,
    input  wire                  penable,
    input  wire                  pwrite,
    input  wire [DATA_WIDTH-1:0] pwdata,
    input  wire [           2:0] pprot,
    input  wire [           3:0] pstrb,
    output wire [DATA_WIDTH-1:0] prdata,
    output wire                  pready,
    output wire                  pslverr,

    input wire       in_valid,
    input wire       in_last,
    input wire [7:0] in_data,

	output wire       out_valid,
	output wire       out_last,
	output wire [7:0] out_data,
	output wire [15:0] out_user_id
);


    // APB interface
    wire [ADDR_WIDTH-1:0] w_reg_addr;
    wire                  w_reg_wr;
    wire                  w_reg_rd;
    wire [DATA_WIDTH-1:0] w_reg_wdata;
    wire [           2:0] w_reg_pprot;
    wire [           3:0] w_reg_pstrb;
    wire [DATA_WIDTH-1:0] w_reg_rdata;

    wire                  w_out_valid;
    wire                  w_out_last;
    wire [           7:0] w_out_data;
    wire [          47:0] w_dst_mac;
    wire [          47:0] w_src_mac;
    wire [          15:0] w_ether_type;
    wire                  w_header_valid;

    wire                  valid_IP;

	wire w_src_ready;

    apb_slave #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) apb_if (
        .clk(clk),
        .rst_n(rst_n),
        .paddr(paddr),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .pprot(pprot),
        .pstrb(pstrb),
        .prdata(prdata),
        .pready(pready),
        .pslverr(pslverr),
        .reg_addr(w_reg_addr),
        .reg_wr(w_reg_wr),
        .reg_rd(w_reg_rd),
        .reg_wdata(w_reg_wdata),
        .reg_pprot(w_reg_pprot),
        .reg_pstrb(w_reg_pstrb),
        .reg_rdata(w_reg_rdata)
    );

    // IP storage module
    FireWall_IP_storage #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) ip_storage (
        .clk(clk),
        .rst_n(rst_n),
        .prdata(prdata),
        .pready(pready),
        .pslverr(pslverr),
        .reg_addr(w_reg_addr),
        .reg_wr(w_reg_wr),
        .reg_rd(w_reg_rd),
        .reg_wdata(w_reg_wdata),
        .reg_pprot(w_reg_pprot),
        .reg_pstrb(w_reg_pstrb),
		.src_ip_valid(w_src_ready),
        .valid_IP(valid_IP),
        .src_ip(w_src_mac),
        .User_ID(out_user_id)
    );

    // Packet parsing module
    eth_packet_read pkt_reader (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in_last(in_last),
        .in_data(in_data),
        .out_valid(w_out_valid),
        .out_last(w_out_last),
        .out_data(w_out_data),
        .dst_mac(w_dst_mac),
        .src_mac(w_src_mac),
		.src_ready(w_src_ready),
        .ether_type(w_ether_type),
        .header_valid(w_header_valid)
    );

    FireWall_pkt_fifo pkt_fifo (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(w_out_valid),
        .wr_data(w_out_data),
        .wr_last(w_out_last),
        .rd_data(out_data),
        .rd_last(out_last),
        .rd_ready(valid_IP),
		.rd_valid(out_valid)
    );

    // Additional logic for matching against IP storage and forwarding/dropping packets would go here

endmodule
