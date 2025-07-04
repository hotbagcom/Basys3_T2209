// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun Nov  3 20:21:45 2024
// Host        : Arif running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/arify/WorkSpace/Basys3_T2209/project_test/project_test.srcs/sources_1/bd/design_rx_reg/ip/design_rx_reg_RX_register_0_0/design_rx_reg_RX_register_0_0_stub.v
// Design      : design_rx_reg_RX_register_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "RX_register,Vivado 2020.1" *)
module design_rx_reg_RX_register_0_0(clk, rx_in, RX_serial)
/* synthesis syn_black_box black_box_pad_pin="clk,rx_in,RX_serial[7:0]" */;
  input clk;
  input rx_in;
  output [7:0]RX_serial;
endmodule
