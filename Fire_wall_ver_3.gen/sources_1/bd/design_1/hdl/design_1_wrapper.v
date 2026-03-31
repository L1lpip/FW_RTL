//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
//Date        : Tue Mar 31 22:07:59 2026
//Host        : DucThanh-Ubuntu running 64-bit Ubuntu 24.04.4 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (aclk_0,
    aresetn_0,
    in_data_0,
    in_last_0,
    in_valid_0,
    out_data_0,
    out_last_0,
    out_user_id_0,
    out_valid_0);
  input aclk_0;
  input aresetn_0;
  input [7:0]in_data_0;
  input in_last_0;
  input in_valid_0;
  output [7:0]out_data_0;
  output out_last_0;
  output [15:0]out_user_id_0;
  output out_valid_0;

  wire aclk_0;
  wire aresetn_0;
  wire [7:0]in_data_0;
  wire in_last_0;
  wire in_valid_0;
  wire [7:0]out_data_0;
  wire out_last_0;
  wire [15:0]out_user_id_0;
  wire out_valid_0;

  design_1 design_1_i
       (.aclk_0(aclk_0),
        .aresetn_0(aresetn_0),
        .in_data_0(in_data_0),
        .in_last_0(in_last_0),
        .in_valid_0(in_valid_0),
        .out_data_0(out_data_0),
        .out_last_0(out_last_0),
        .out_user_id_0(out_user_id_0),
        .out_valid_0(out_valid_0));
endmodule
