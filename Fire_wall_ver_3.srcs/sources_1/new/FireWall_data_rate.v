`timescale 1ns / 1ps

module FireWall_data_rate #(
    parameter CLK_FREQ   = 100_000
)(
    input wire clk,
    input wire rst_n,
    input wire [8:0]  i_user_id,
    input wire [31:0] i_byte_cnt,

    output reg        o_valid,
    output reg [8:0]  o_user_id,
    output reg [31:0] o_byte_cnt
);

    reg [$clog2(CLK_FREQ)-1:0] r_timer;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_timer    <= 0;
            o_valid    <= 0;
            o_user_id  <= 0;
            o_byte_cnt <= 0;
        end else begin
            o_valid <= 0;
            if (r_timer == CLK_FREQ - 1) begin
                r_timer    <= 0;
                o_valid    <= 1;
                o_user_id  <= i_user_id;
                o_byte_cnt <= i_byte_cnt;
            end else begin
                r_timer <= r_timer + 1;
            end
        end
    end

endmodule
