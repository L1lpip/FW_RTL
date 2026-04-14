`timescale 1ns / 1ps

module FireWall_total_byte_cnt #(
    parameter CLK_FREQ   = 100_000     
)(
    input  wire        clk,
    input  wire        rst_n,

    input  wire        in_valid,        

    output wire        out_valid,      
    output wire [31:0] total_byte_cnt   
);

    reg [$clog2(CLK_FREQ)-1:0] r_timer;
    reg                       r_tick;   // 1-cycle pulse at end of each window

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

    reg [31:0] r_acc;
    reg [31:0] r_snapshot;
    reg        r_out_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_acc       <= 0;
            r_snapshot  <= 0;
            r_out_valid <= 0;
        end else begin
            r_out_valid <= 0;

            if (r_tick) begin
                r_snapshot  <= r_acc;               
                r_acc       <= in_valid ? 1 : 0;    
                r_out_valid <= 1;
            end else if (in_valid) begin
                r_acc <= r_acc + 1;
            end
        end
    end

    assign total_byte_cnt = r_snapshot;
    assign out_valid      = r_out_valid;

endmodule
