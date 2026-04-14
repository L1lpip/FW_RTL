`timescale 1ns / 1ps

module FireWall_data_rate #(
    parameter CLK_FREQ   = 100_000
)(
    input wire clk,
    input wire rst_n,
    input wire [8:0]  i_user_id,
    input wire [31:0] i_byte_cnt,
    input wire [31:0] i_total_byte_cnt,

    output wire [31:0] data_rate,
    output wire        o_rd_to_bram,
    output wire [8:0]  o_user_id,
    output wire        o_wr_to_bram
);

    reg [$clog2(CLK_FREQ)-1:0] r_timer;
    reg                   r_tick;     

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_timer <= 0;
            r_tick  <= 0;
        end else begin
            r_tick <= 0;
            if (r_timer == CLK_FREQ - 1) begin
                r_timer <= 0;
                r_tick  <= 1;
            end else begin
                r_timer <= r_timer + 1;
            end
        end
    end

    localparam IDLE  = 2'd0;  
    localparam READ  = 2'd1;  
    localparam LATCH = 2'd2;  

    reg [1:0]  r_state;
    reg [31:0] r_data_rate;
    reg        r_rd_to_bram;
    reg [8:0]  r_user_id;
    reg        r_wr_to_bram;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_state      <= IDLE;
            r_data_rate  <= 0;
            r_rd_to_bram <= 0;
            r_user_id    <= 0;
            r_wr_to_bram <= 0;
        end else begin
            r_rd_to_bram <= 0;
            r_wr_to_bram <= 0;

            case (r_state)
                IDLE: begin
                    if (r_tick) begin
                        r_user_id    <= i_user_id;
                        r_rd_to_bram <= 1;        
                        r_state      <= READ;
                    end
                end

                READ: begin
                    r_state <= LATCH;
                end

                LATCH: begin
                    r_data_rate  <= i_byte_cnt / i_total_byte_cnt;  
                    r_wr_to_bram <= 1;               
                    r_state      <= IDLE;
                end

                default: r_state <= IDLE;
            endcase
        end
    end

    assign data_rate    = r_data_rate;
    assign o_rd_to_bram = r_rd_to_bram;
    assign o_user_id    = r_user_id;
    assign o_wr_to_bram = r_wr_to_bram;

endmodule
