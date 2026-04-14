module FireWall_byte_cnt #(
    parameter DATA_WIDTH = 8
) (
    input wire clk,
    input wire rst_n,

    input wire       in_valid,
    input wire       in_last,

    output wire        out_valid,
    output wire        out_last,
    output reg  [31:0] byte_cnt
);
    reg [31:0] cnt;
    reg        r_out_valid;
    reg        r_out_last;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_out_valid <= 0;
            r_out_last  <= 0;
            byte_cnt    <= 0;
            cnt         <= 0;
        end else begin
            r_out_valid <= 0;
            r_out_last  <= 0;
            if (in_valid) begin
                cnt      <= cnt + 1;
                byte_cnt <= cnt;
                if (in_last) begin
                    r_out_valid <= 1;
                    r_out_last  <= 1;
                end
            end else begin
                cnt      <= 0;
                byte_cnt <= 0;
            end
            if (r_out_valid) begin
                cnt      <= 0;
                byte_cnt <= 0;
            end
        end
    end

    assign out_valid = r_out_valid;
    assign out_last  = r_out_last;

endmodule
