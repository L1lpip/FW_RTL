module FireWall_pkt_fifo #(
	parameter DATA_WIDTH = 8,
	parameter DEPTH      = 2048
)(
	input wire clk,
	input wire rst_n,

	input wire                  wr_en,
	input wire [DATA_WIDTH-1:0] wr_data,
	input wire                  wr_last,

	output reg                  rd_valid,
	output reg [DATA_WIDTH-1:0] rd_data,
	output reg                  rd_last,
	input wire                  rd_ready
);

	localparam PTR_WIDTH = $clog2(DEPTH);
	reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];
	reg [PTR_WIDTH-1:0] wr_ptr;
	reg [PTR_WIDTH-1:0] rd_ptr;
	wire full;
	wire empty;

	assign full  = (wr_ptr == 2047) ? 1'b1 : 1'b0;
	assign empty = (wr_ptr == rd_ptr) ? 1'b1 : 1'b0;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			wr_ptr   <= 0;
			rd_ptr   <= 0;
			rd_valid <= 0;
			rd_data  <= 0;
			rd_last  <= 0;
		end else begin
			if (wr_en && !full) begin
				fifo_mem[wr_ptr] <= wr_data;
				wr_ptr <= wr_ptr + 1;
			end

			if (rd_ready && !empty) begin
				rd_data  <= fifo_mem[rd_ptr];
				rd_last  <= (rd_ptr == wr_ptr - 1) ? wr_last : 0; 
				rd_valid <= 1;
				rd_ptr   <= rd_ptr + 1;
			end else begin
				rd_valid <= 0; 
			end
		end
	end
endmodule