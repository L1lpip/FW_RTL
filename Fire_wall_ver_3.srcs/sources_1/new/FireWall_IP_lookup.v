`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2026 08:41:09 AM
// Design Name: 
// Module Name: pulse_10ms_counter
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


module pulse_10ms_counter#(
    parameter CLK_FREQ_HZ = 245_760_000,
    parameter PULSE_WIDTH = 10
)(
    
    input clk,
    input rst_n,
    input fir_valid,
    output reg pulse_10ms,
    output reg [21:0] counter_debug
    
    );
    
    localparam integer FRAME_CYCLES = CLK_FREQ_HZ / 100;
    localparam integer COUNTER_WIDTH = $clog2(FRAME_CYCLES + 1);
    
    reg [COUNTER_WIDTH - 1: 0] cnt;
    reg [$clog2(PULSE_WIDTH + 1) - 1 : 0] pulse_cnt;
    reg running;
    reg fir_valid_d;
    wire fir_valid_rise = fir_valid & ~fir_valid_d;
     
    always @ (posedge clk or negedge rst_n) begin
        if(!rst_n)
            fir_valid_d <= 1'b0;
        else 
            fir_valid_d <= fir_valid;
    end
    
    always @ (posedge clk or negedge rst_n) begin
        if(!rst_n)
            running <= 0;
        else if (fir_valid_rise)
            running <= 1'b1;
        else if (cnt == FRAME_CYCLES - 1)
            running <= 1'b0;
    end
    
    always @ (posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 0;
            pulse_10ms <= 0;
            pulse_cnt <= 0;
            running <= 0;
        end else begin
            if(pulse_cnt > 0) begin
                pulse_cnt <= pulse_cnt - 1'b1;
                pulse_10ms <= 1'b1;
            end else begin
                pulse_10ms <= 1'b0;
            end
            
            if(!running) begin
                if(fir_valid_rise) begin
                    running <= 1'b1;
                    cnt <= 0;
                    pulse_cnt <= PULSE_WIDTH;
                end           
            end else begin
                if(cnt >= FRAME_CYCLES - 1) begin
                    cnt <= {COUNTER_WIDTH{1'b0}};
                    pulse_10ms <= 1'b1;
				end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end
    
endmodule
