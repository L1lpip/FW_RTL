module FireWall_IP_storage #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter DEPTH      = 128  // 128 indices x 256 bits = 512 MAC entries
) (
    input wire clk,
    input wire rst_n,

    input wire [DATA_WIDTH-1:0] prdata,
    input wire                  pready,
    input wire                  pslverr,
    input wire [ADDR_WIDTH-1:0] reg_addr,
    input wire                  reg_wr,
    input wire                  reg_rd,
    input wire [DATA_WIDTH-1:0] reg_wdata,
    input wire [           2:0] reg_pprot,
    input wire [           3:0] reg_pstrb,

    input  wire        src_ip_valid,
    output reg         valid_IP,
    input  wire [47:0] src_ip,
    output reg  [15:0] User_ID,

    output wire full,
    output wire empty

);

    localparam MAC_LO_ADDR = 32'h0;
    localparam MAC_HI_ID_VALID_ADDR = 32'h4;

    localparam PTR_WIDTH = $clog2(DEPTH);
    reg [      255:0] mac_storage    [0:DEPTH-1];
    reg [PTR_WIDTH:0] wr_ptr;
    reg [        1:0] sub_idx;
    reg [       31:0] mac_lo_buf;
    reg               mac_lo_written;

    assign empty = (wr_ptr == 0) && (sub_idx == 0);
    assign full  = (wr_ptr[PTR_WIDTH] == 1'b1);

    always @(posedge clk) begin
        if (!rst_n) begin
            wr_ptr         <= 0;
            sub_idx        <= 2'd0;
            mac_lo_buf     <= 32'd0;
            mac_lo_written <= 1'b0;
        end else if (reg_wr && !full) begin
            case (reg_addr)
                MAC_LO_ADDR: begin
                    mac_lo_buf     <= reg_wdata;
                    mac_lo_written <= 1'b1;
                end
                MAC_HI_ID_VALID_ADDR: begin
                    if (mac_lo_written) begin
                        mac_storage[wr_ptr[PTR_WIDTH-1:0]][sub_idx*64+:64] <= {mac_lo_buf, reg_wdata};
                        mac_lo_written                                     <= 1'b0;
                        if (sub_idx == 2'd3) begin
                            wr_ptr  <= wr_ptr + 1;
                            sub_idx <= 2'd0;
                        end else begin
                            sub_idx <= sub_idx + 1;
                        end
                    end
                end

                default: ;
            endcase
        end
    end


   reg [PTR_WIDTH-1:0] search_idx;
    reg                 searching;

    integer j;
    reg [63:0] entry;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_IP   <= 0;
            User_ID    <= 0;
            searching  <= 0;
            search_idx <= 0;
        end else begin


            if (src_ip_valid && !searching) begin
                searching  <= 1'b1;
                search_idx <= 0;
                valid_IP   <= 1'b0;
            end
            else if (searching) begin
                valid_IP <= 1'b0; 
                for (j = 0; j < 4; j = j + 1) begin
                    entry = mac_storage[search_idx][j*64 +: 64];
                    if ((entry[63:16] == src_ip) && entry[0]) begin
                        valid_IP  <= 1'b1;
                        User_ID   <= {1'b0, entry[15:1]};
                        searching <= 1'b0; 
                    end
                end
                if (searching) begin
                    search_idx <= search_idx + 1;
                    if (search_idx == DEPTH-1) begin
                        searching <= 1'b0; 
                    end
                end
            end
        end
    end

endmodule
