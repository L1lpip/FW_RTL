module FireWall_pkt_fifo #(
	parameter DATA_WIDTH = 8,
	parameter DEPTH      = 512  
)(
	input wire clk,
	input wire rst_n,

	input wire                  wr_en,
	input wire [DATA_WIDTH-1:0] wr_data,
	input wire                  wr_last,
	output wire                 wr_full,

	output reg                  rd_valid,
	output reg [DATA_WIDTH-1:0] rd_data,
	output reg                  rd_last,
	input wire                  rd_ready
);

	localparam PTR_WIDTH = $clog2(DEPTH);


	reg [DATA_WIDTH:0] fifo_mem [0:DEPTH-1];  // bit [DATA_WIDTH] = last


	reg [PTR_WIDTH:0] wr_ptr;
	reg [PTR_WIDTH:0] rd_ptr;

	wire full  = (wr_ptr[PTR_WIDTH]   != rd_ptr[PTR_WIDTH]) &&
	             (wr_ptr[PTR_WIDTH-1:0] == rd_ptr[PTR_WIDTH-1:0]);
	wire empty = (wr_ptr == rd_ptr);

	assign wr_full = full;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			wr_ptr <= 0;
		end else if (wr_en && !full) begin
			fifo_mem[wr_ptr[PTR_WIDTH-1:0]] <= {wr_last, wr_data};
			wr_ptr <= wr_ptr + 1;
		end
	end
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			rd_ptr   <= 0;
			rd_valid <= 0;
			rd_data  <= 0;
			rd_last  <= 0;
		end else begin
			if (rd_valid && rd_ready) begin
				if (!empty) begin
					{rd_last, rd_data} <= fifo_mem[rd_ptr[PTR_WIDTH-1:0]];
					rd_ptr   <= rd_ptr + 1;
					rd_valid <= 1;
				end else begin
					rd_valid <= 0;
					rd_last  <= 0;
				end
			end else if (!rd_valid && !empty) begin
				{rd_last, rd_data} <= fifo_mem[rd_ptr[PTR_WIDTH-1:0]];
				rd_ptr   <= rd_ptr + 1;
				rd_valid <= 1;
			end
		end
	end

endmodule
