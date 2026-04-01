module FireWall_IP_lookup #(
	parameter ADDR_WIDTH = 32,
	parameter DATA_WIDTH = 32,
	parameter DEPTH      = 128
)(
	input wire clk,
	input wire rst_n,

	input wire [DATA_WIDTH-1:0] src_ip,
	input wire                  src_ip_valid,

	output reg match
);

	localparam PTR_WIDTH = $clog2(DEPTH);
	reg [255:0] ip_storage [0:DEPTH-1];
	reg [PTR_WIDTH-1:0] rd_ptr;

	always @(posedge clk) begin
		if (!rst_n) begin
			rd_ptr <= 0;
			match  <= 0;
		end else if (src_ip_valid) begin
			// Simple linear search through IP storage
			match <= 0; // default to no match
			for (int i = 0; i < DEPTH; i++) begin
				if (ip_storage[i][31:0] == src_ip) begin
					match <= 1; // found a match
					break;
				end
			end
		end else begin
			match <= 0; // no valid IP to check
		end
	end