// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun Nov  3 20:21:45 2024
// Host        : Arif running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/arify/WorkSpace/Basys3_T2209/project_test/project_test.srcs/sources_1/bd/design_rx_reg/ip/design_rx_reg_RX_register_0_0/design_rx_reg_RX_register_0_0_sim_netlist.v
// Design      : design_rx_reg_RX_register_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_rx_reg_RX_register_0_0,RX_register,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* ip_definition_source = "module_ref" *) 
(* x_core_info = "RX_register,Vivado 2020.1" *) 
(* NotValidForBitStream *)
module design_rx_reg_RX_register_0_0
   (clk,
    rx_in,
    RX_serial);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0" *) input clk;
  input rx_in;
  output [7:0]RX_serial;

  wire [7:0]RX_serial;
  wire clk;
  wire rx_in;

  design_rx_reg_RX_register_0_0_RX_register U0
       (.RX_serial(RX_serial),
        .clk(clk),
        .rx_in(rx_in));
endmodule

(* ORIG_REF_NAME = "RX_register" *) 
module design_rx_reg_RX_register_0_0_RX_register
   (RX_serial,
    clk,
    rx_in);
  output [7:0]RX_serial;
  input clk;
  input rx_in;

  wire \FSM_sequential_S_state[0]_i_1_n_0 ;
  wire \FSM_sequential_S_state[1]_i_1_n_0 ;
  wire \FSM_sequential_S_state[1]_i_2_n_0 ;
  wire \FSM_sequential_S_state[2]_i_1_n_0 ;
  wire \FSM_sequential_S_state[2]_i_2_n_0 ;
  wire \FSM_sequential_S_state[2]_i_3_n_0 ;
  wire \FSM_sequential_S_state[2]_i_4_n_0 ;
  wire \FSM_sequential_S_state[2]_i_5_n_0 ;
  wire \FSM_sequential_S_state[2]_i_6_n_0 ;
  wire \FSM_sequential_S_state[2]_i_7_n_0 ;
  wire \FSM_sequential_S_state[2]_i_8_n_0 ;
  wire \FSM_sequential_S_state[2]_i_9_n_0 ;
  wire [7:0]RX_serial;
  wire \RX_serial[7]_i_1_n_0 ;
  wire \RX_serial[7]_i_2_n_0 ;
  wire \RX_serial[7]_i_3_n_0 ;
  wire \RX_serial[7]_i_4_n_0 ;
  wire S_bit_index;
  wire \S_bit_index[0]_i_1_n_0 ;
  wire \S_bit_index[1]_i_1_n_0 ;
  wire \S_bit_index[2]_i_1_n_0 ;
  wire \S_bit_index[3]_i_2_n_0 ;
  wire \S_bit_index_reg_n_0_[0] ;
  wire \S_bit_index_reg_n_0_[1] ;
  wire \S_bit_index_reg_n_0_[2] ;
  wire \S_bit_index_reg_n_0_[3] ;
  wire S_ready_i_1_n_0;
  wire S_ready_i_2_n_0;
  wire S_ready_i_3_n_0;
  wire S_ready_reg_n_0;
  wire \S_rx_data[0]_i_1_n_0 ;
  wire \S_rx_data[1]_i_1_n_0 ;
  wire \S_rx_data[2]_i_1_n_0 ;
  wire \S_rx_data[3]_i_1_n_0 ;
  wire \S_rx_data[4]_i_1_n_0 ;
  wire \S_rx_data[5]_i_1_n_0 ;
  wire \S_rx_data[6]_i_1_n_0 ;
  wire \S_rx_data[7]_i_1_n_0 ;
  wire \S_rx_data[7]_i_2_n_0 ;
  wire \S_rx_data[8]_i_1_n_0 ;
  wire \S_rx_data_reg_n_0_[0] ;
  wire \S_rx_data_reg_n_0_[1] ;
  wire \S_rx_data_reg_n_0_[7] ;
  wire [2:0]S_state__0;
  wire S_timer;
  wire S_timer0_carry__0_n_0;
  wire S_timer0_carry__0_n_1;
  wire S_timer0_carry__0_n_2;
  wire S_timer0_carry__0_n_3;
  wire S_timer0_carry__1_n_0;
  wire S_timer0_carry__1_n_1;
  wire S_timer0_carry__1_n_2;
  wire S_timer0_carry__1_n_3;
  wire S_timer0_carry__2_n_0;
  wire S_timer0_carry__2_n_1;
  wire S_timer0_carry__2_n_2;
  wire S_timer0_carry__2_n_3;
  wire S_timer0_carry__3_n_0;
  wire S_timer0_carry__3_n_1;
  wire S_timer0_carry__3_n_2;
  wire S_timer0_carry__3_n_3;
  wire S_timer0_carry__4_n_0;
  wire S_timer0_carry__4_n_1;
  wire S_timer0_carry__4_n_2;
  wire S_timer0_carry__4_n_3;
  wire S_timer0_carry__5_n_0;
  wire S_timer0_carry__5_n_1;
  wire S_timer0_carry__5_n_2;
  wire S_timer0_carry__5_n_3;
  wire S_timer0_carry__6_n_2;
  wire S_timer0_carry__6_n_3;
  wire S_timer0_carry_n_0;
  wire S_timer0_carry_n_1;
  wire S_timer0_carry_n_2;
  wire S_timer0_carry_n_3;
  wire \S_timer[0]_i_1_n_0 ;
  wire \S_timer[0]_i_2_n_0 ;
  wire \S_timer[0]_i_3_n_0 ;
  wire \S_timer[0]_i_4_n_0 ;
  wire \S_timer[0]_i_5_n_0 ;
  wire \S_timer[0]_i_6_n_0 ;
  wire \S_timer[0]_i_7_n_0 ;
  wire \S_timer[0]_i_8_n_0 ;
  wire \S_timer[0]_i_9_n_0 ;
  wire \S_timer[31]_i_1_n_0 ;
  wire \S_timer[31]_i_3_n_0 ;
  wire \S_timer[31]_i_4_n_0 ;
  wire \S_timer[31]_i_5_n_0 ;
  wire \S_timer_reg_n_0_[0] ;
  wire \S_timer_reg_n_0_[10] ;
  wire \S_timer_reg_n_0_[11] ;
  wire \S_timer_reg_n_0_[12] ;
  wire \S_timer_reg_n_0_[13] ;
  wire \S_timer_reg_n_0_[14] ;
  wire \S_timer_reg_n_0_[15] ;
  wire \S_timer_reg_n_0_[16] ;
  wire \S_timer_reg_n_0_[17] ;
  wire \S_timer_reg_n_0_[18] ;
  wire \S_timer_reg_n_0_[19] ;
  wire \S_timer_reg_n_0_[1] ;
  wire \S_timer_reg_n_0_[20] ;
  wire \S_timer_reg_n_0_[21] ;
  wire \S_timer_reg_n_0_[22] ;
  wire \S_timer_reg_n_0_[23] ;
  wire \S_timer_reg_n_0_[24] ;
  wire \S_timer_reg_n_0_[25] ;
  wire \S_timer_reg_n_0_[26] ;
  wire \S_timer_reg_n_0_[27] ;
  wire \S_timer_reg_n_0_[28] ;
  wire \S_timer_reg_n_0_[29] ;
  wire \S_timer_reg_n_0_[2] ;
  wire \S_timer_reg_n_0_[30] ;
  wire \S_timer_reg_n_0_[31] ;
  wire \S_timer_reg_n_0_[3] ;
  wire \S_timer_reg_n_0_[4] ;
  wire \S_timer_reg_n_0_[5] ;
  wire \S_timer_reg_n_0_[6] ;
  wire \S_timer_reg_n_0_[7] ;
  wire \S_timer_reg_n_0_[8] ;
  wire \S_timer_reg_n_0_[9] ;
  wire clk;
  wire [31:1]data0;
  wire p_0_in;
  wire p_1_in;
  wire p_2_in;
  wire p_3_in;
  wire p_4_in;
  wire p_5_in;
  wire rx_in;
  wire [3:2]NLW_S_timer0_carry__6_CO_UNCONNECTED;
  wire [3:3]NLW_S_timer0_carry__6_O_UNCONNECTED;

  LUT5 #(
    .INIT(32'h00FF1300)) 
    \FSM_sequential_S_state[0]_i_1 
       (.I0(S_ready_reg_n_0),
        .I1(S_state__0[2]),
        .I2(S_state__0[1]),
        .I3(\FSM_sequential_S_state[2]_i_3_n_0 ),
        .I4(S_state__0[0]),
        .O(\FSM_sequential_S_state[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAEAAFFFFAEAA0000)) 
    \FSM_sequential_S_state[1]_i_1 
       (.I0(\FSM_sequential_S_state[1]_i_2_n_0 ),
        .I1(S_state__0[0]),
        .I2(S_state__0[2]),
        .I3(\FSM_sequential_S_state[2]_i_2_n_0 ),
        .I4(\FSM_sequential_S_state[2]_i_3_n_0 ),
        .I5(S_state__0[1]),
        .O(\FSM_sequential_S_state[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h015A010A010A015A)) 
    \FSM_sequential_S_state[1]_i_2 
       (.I0(S_state__0[0]),
        .I1(S_ready_reg_n_0),
        .I2(S_state__0[2]),
        .I3(S_state__0[1]),
        .I4(p_0_in),
        .I5(\RX_serial[7]_i_3_n_0 ),
        .O(\FSM_sequential_S_state[1]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00FF0800)) 
    \FSM_sequential_S_state[2]_i_1 
       (.I0(S_state__0[1]),
        .I1(S_state__0[0]),
        .I2(\FSM_sequential_S_state[2]_i_2_n_0 ),
        .I3(\FSM_sequential_S_state[2]_i_3_n_0 ),
        .I4(S_state__0[2]),
        .O(\FSM_sequential_S_state[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hFEFF)) 
    \FSM_sequential_S_state[2]_i_2 
       (.I0(\S_bit_index_reg_n_0_[0] ),
        .I1(\S_bit_index_reg_n_0_[1] ),
        .I2(\S_bit_index_reg_n_0_[2] ),
        .I3(\S_bit_index_reg_n_0_[3] ),
        .O(\FSM_sequential_S_state[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFAAAFAAAE)) 
    \FSM_sequential_S_state[2]_i_3 
       (.I0(\FSM_sequential_S_state[2]_i_4_n_0 ),
        .I1(\FSM_sequential_S_state[2]_i_5_n_0 ),
        .I2(\S_timer_reg_n_0_[0] ),
        .I3(\S_timer[0]_i_2_n_0 ),
        .I4(\FSM_sequential_S_state[2]_i_6_n_0 ),
        .I5(\FSM_sequential_S_state[2]_i_7_n_0 ),
        .O(\FSM_sequential_S_state[2]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h000D)) 
    \FSM_sequential_S_state[2]_i_4 
       (.I0(rx_in),
        .I1(S_state__0[2]),
        .I2(S_state__0[1]),
        .I3(S_state__0[0]),
        .O(\FSM_sequential_S_state[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0400000000000000)) 
    \FSM_sequential_S_state[2]_i_5 
       (.I0(\S_timer_reg_n_0_[6] ),
        .I1(\S_timer_reg_n_0_[5] ),
        .I2(\S_timer_reg_n_0_[9] ),
        .I3(\S_timer_reg_n_0_[11] ),
        .I4(S_state__0[1]),
        .I5(\FSM_sequential_S_state[2]_i_8_n_0 ),
        .O(\FSM_sequential_S_state[2]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0400000000000000)) 
    \FSM_sequential_S_state[2]_i_6 
       (.I0(\S_timer_reg_n_0_[5] ),
        .I1(\S_timer_reg_n_0_[6] ),
        .I2(\S_timer_reg_n_0_[11] ),
        .I3(\S_timer_reg_n_0_[9] ),
        .I4(S_state__0[0]),
        .I5(\FSM_sequential_S_state[2]_i_9_n_0 ),
        .O(\FSM_sequential_S_state[2]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h40)) 
    \FSM_sequential_S_state[2]_i_7 
       (.I0(S_state__0[2]),
        .I1(S_state__0[0]),
        .I2(S_state__0[1]),
        .O(\FSM_sequential_S_state[2]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h0400)) 
    \FSM_sequential_S_state[2]_i_8 
       (.I0(S_state__0[2]),
        .I1(\S_timer_reg_n_0_[4] ),
        .I2(\S_timer_reg_n_0_[12] ),
        .I3(\S_timer_reg_n_0_[13] ),
        .O(\FSM_sequential_S_state[2]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h0100)) 
    \FSM_sequential_S_state[2]_i_9 
       (.I0(\S_timer_reg_n_0_[4] ),
        .I1(S_state__0[2]),
        .I2(\S_timer_reg_n_0_[13] ),
        .I3(\S_timer_reg_n_0_[12] ),
        .O(\FSM_sequential_S_state[2]_i_9_n_0 ));
  (* FSM_ENCODED_STATES = "strt:001,receive:011,check:100,rdy:000,waiting:010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_S_state_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\FSM_sequential_S_state[0]_i_1_n_0 ),
        .Q(S_state__0[0]),
        .R(1'b0));
  (* FSM_ENCODED_STATES = "strt:001,receive:011,check:100,rdy:000,waiting:010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_S_state_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\FSM_sequential_S_state[1]_i_1_n_0 ),
        .Q(S_state__0[1]),
        .R(1'b0));
  (* FSM_ENCODED_STATES = "strt:001,receive:011,check:100,rdy:000,waiting:010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_S_state_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\FSM_sequential_S_state[2]_i_1_n_0 ),
        .Q(S_state__0[2]),
        .R(1'b0));
  LUT5 #(
    .INIT(32'h00000060)) 
    \RX_serial[7]_i_1 
       (.I0(\RX_serial[7]_i_3_n_0 ),
        .I1(p_0_in),
        .I2(S_state__0[2]),
        .I3(S_state__0[0]),
        .I4(S_state__0[1]),
        .O(\RX_serial[7]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \RX_serial[7]_i_2 
       (.I0(S_state__0[1]),
        .I1(S_state__0[0]),
        .I2(S_state__0[2]),
        .O(\RX_serial[7]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h96696996)) 
    \RX_serial[7]_i_3 
       (.I0(p_2_in),
        .I1(p_3_in),
        .I2(\S_rx_data_reg_n_0_[1] ),
        .I3(p_1_in),
        .I4(\RX_serial[7]_i_4_n_0 ),
        .O(\RX_serial[7]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \RX_serial[7]_i_4 
       (.I0(p_5_in),
        .I1(p_4_in),
        .I2(\S_rx_data_reg_n_0_[0] ),
        .I3(\S_rx_data_reg_n_0_[7] ),
        .O(\RX_serial[7]_i_4_n_0 ));
  FDSE #(
    .INIT(1'b0)) 
    \RX_serial_reg[0] 
       (.C(clk),
        .CE(\RX_serial[7]_i_2_n_0 ),
        .D(\S_rx_data_reg_n_0_[0] ),
        .Q(RX_serial[0]),
        .S(\RX_serial[7]_i_1_n_0 ));
  FDSE #(
    .INIT(1'b0)) 
    \RX_serial_reg[1] 
       (.C(clk),
        .CE(\RX_serial[7]_i_2_n_0 ),
        .D(\S_rx_data_reg_n_0_[1] ),
        .Q(RX_serial[1]),
        .S(\RX_serial[7]_i_1_n_0 ));
  FDSE #(
    .INIT(1'b0)) 
    \RX_serial_reg[2] 
       (.C(clk),
        .CE(\RX_serial[7]_i_2_n_0 ),
        .D(p_1_in),
        .Q(RX_serial[2]),
        .S(\RX_serial[7]_i_1_n_0 ));
  FDSE #(
    .INIT(1'b0)) 
    \RX_serial_reg[3] 
       (.C(clk),
        .CE(\RX_serial[7]_i_2_n_0 ),
        .D(p_2_in),
        .Q(RX_serial[3]),
        .S(\RX_serial[7]_i_1_n_0 ));
  FDSE #(
    .INIT(1'b0)) 
    \RX_serial_reg[4] 
       (.C(clk),
        .CE(\RX_serial[7]_i_2_n_0 ),
        .D(p_3_in),
        .Q(RX_serial[4]),
        .S(\RX_serial[7]_i_1_n_0 ));
  FDSE #(
    .INIT(1'b0)) 
    \RX_serial_reg[5] 
       (.C(clk),
        .CE(\RX_serial[7]_i_2_n_0 ),
        .D(p_4_in),
        .Q(RX_serial[5]),
        .S(\RX_serial[7]_i_1_n_0 ));
  FDSE #(
    .INIT(1'b0)) 
    \RX_serial_reg[6] 
       (.C(clk),
        .CE(\RX_serial[7]_i_2_n_0 ),
        .D(p_5_in),
        .Q(RX_serial[6]),
        .S(\RX_serial[7]_i_1_n_0 ));
  FDSE #(
    .INIT(1'b0)) 
    \RX_serial_reg[7] 
       (.C(clk),
        .CE(\RX_serial[7]_i_2_n_0 ),
        .D(rx_in),
        .Q(RX_serial[7]),
        .S(\RX_serial[7]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \S_bit_index[0]_i_1 
       (.I0(S_state__0[1]),
        .I1(\S_bit_index_reg_n_0_[0] ),
        .O(\S_bit_index[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h28)) 
    \S_bit_index[1]_i_1 
       (.I0(S_state__0[1]),
        .I1(\S_bit_index_reg_n_0_[1] ),
        .I2(\S_bit_index_reg_n_0_[0] ),
        .O(\S_bit_index[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h2888)) 
    \S_bit_index[2]_i_1 
       (.I0(S_state__0[1]),
        .I1(\S_bit_index_reg_n_0_[2] ),
        .I2(\S_bit_index_reg_n_0_[0] ),
        .I3(\S_bit_index_reg_n_0_[1] ),
        .O(\S_bit_index[2]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h00C1)) 
    \S_bit_index[3]_i_1 
       (.I0(rx_in),
        .I1(S_state__0[1]),
        .I2(S_state__0[0]),
        .I3(S_state__0[2]),
        .O(S_bit_index));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h28888888)) 
    \S_bit_index[3]_i_2 
       (.I0(S_state__0[1]),
        .I1(\S_bit_index_reg_n_0_[3] ),
        .I2(\S_bit_index_reg_n_0_[1] ),
        .I3(\S_bit_index_reg_n_0_[0] ),
        .I4(\S_bit_index_reg_n_0_[2] ),
        .O(\S_bit_index[3]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_bit_index_reg[0] 
       (.C(clk),
        .CE(S_bit_index),
        .D(\S_bit_index[0]_i_1_n_0 ),
        .Q(\S_bit_index_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \S_bit_index_reg[1] 
       (.C(clk),
        .CE(S_bit_index),
        .D(\S_bit_index[1]_i_1_n_0 ),
        .Q(\S_bit_index_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \S_bit_index_reg[2] 
       (.C(clk),
        .CE(S_bit_index),
        .D(\S_bit_index[2]_i_1_n_0 ),
        .Q(\S_bit_index_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \S_bit_index_reg[3] 
       (.C(clk),
        .CE(S_bit_index),
        .D(\S_bit_index[3]_i_2_n_0 ),
        .Q(\S_bit_index_reg_n_0_[3] ),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hBBBBBBFF000000F4)) 
    S_ready_i_1
       (.I0(\S_timer[31]_i_3_n_0 ),
        .I1(S_ready_i_2_n_0),
        .I2(S_state__0[2]),
        .I3(S_state__0[0]),
        .I4(S_state__0[1]),
        .I5(S_ready_reg_n_0),
        .O(S_ready_i_1_n_0));
  LUT5 #(
    .INIT(32'h00100000)) 
    S_ready_i_2
       (.I0(S_state__0[2]),
        .I1(\S_timer_reg_n_0_[4] ),
        .I2(S_state__0[0]),
        .I3(S_state__0[1]),
        .I4(S_ready_i_3_n_0),
        .O(S_ready_i_2_n_0));
  LUT6 #(
    .INIT(64'h0000002000000000)) 
    S_ready_i_3
       (.I0(\S_timer_reg_n_0_[9] ),
        .I1(\S_timer_reg_n_0_[11] ),
        .I2(\S_timer_reg_n_0_[6] ),
        .I3(\S_timer_reg_n_0_[5] ),
        .I4(\S_timer_reg_n_0_[13] ),
        .I5(\S_timer_reg_n_0_[12] ),
        .O(S_ready_i_3_n_0));
  FDRE #(
    .INIT(1'b0)) 
    S_ready_reg
       (.C(clk),
        .CE(1'b1),
        .D(S_ready_i_1_n_0),
        .Q(S_ready_reg_n_0),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFB00000008)) 
    \S_rx_data[0]_i_1 
       (.I0(rx_in),
        .I1(\S_rx_data[7]_i_2_n_0 ),
        .I2(\S_bit_index_reg_n_0_[0] ),
        .I3(\S_bit_index_reg_n_0_[1] ),
        .I4(\S_bit_index_reg_n_0_[2] ),
        .I5(\S_rx_data_reg_n_0_[0] ),
        .O(\S_rx_data[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFEFFFFFF02000000)) 
    \S_rx_data[1]_i_1 
       (.I0(rx_in),
        .I1(\S_bit_index_reg_n_0_[1] ),
        .I2(\S_bit_index_reg_n_0_[2] ),
        .I3(\S_bit_index_reg_n_0_[0] ),
        .I4(\S_rx_data[7]_i_2_n_0 ),
        .I5(\S_rx_data_reg_n_0_[1] ),
        .O(\S_rx_data[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFEFFFFF00200000)) 
    \S_rx_data[2]_i_1 
       (.I0(rx_in),
        .I1(\S_bit_index_reg_n_0_[0] ),
        .I2(\S_bit_index_reg_n_0_[1] ),
        .I3(\S_bit_index_reg_n_0_[2] ),
        .I4(\S_rx_data[7]_i_2_n_0 ),
        .I5(p_1_in),
        .O(\S_rx_data[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hEFFFFFFF20000000)) 
    \S_rx_data[3]_i_1 
       (.I0(rx_in),
        .I1(\S_bit_index_reg_n_0_[2] ),
        .I2(\S_bit_index_reg_n_0_[0] ),
        .I3(\S_bit_index_reg_n_0_[1] ),
        .I4(\S_rx_data[7]_i_2_n_0 ),
        .I5(p_2_in),
        .O(\S_rx_data[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFEFFFFFF02000000)) 
    \S_rx_data[4]_i_1 
       (.I0(rx_in),
        .I1(\S_bit_index_reg_n_0_[1] ),
        .I2(\S_bit_index_reg_n_0_[0] ),
        .I3(\S_bit_index_reg_n_0_[2] ),
        .I4(\S_rx_data[7]_i_2_n_0 ),
        .I5(p_3_in),
        .O(\S_rx_data[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hEFFFFFFF20000000)) 
    \S_rx_data[5]_i_1 
       (.I0(rx_in),
        .I1(\S_bit_index_reg_n_0_[1] ),
        .I2(\S_bit_index_reg_n_0_[0] ),
        .I3(\S_bit_index_reg_n_0_[2] ),
        .I4(\S_rx_data[7]_i_2_n_0 ),
        .I5(p_4_in),
        .O(\S_rx_data[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hEFFFFFFF20000000)) 
    \S_rx_data[6]_i_1 
       (.I0(rx_in),
        .I1(\S_bit_index_reg_n_0_[0] ),
        .I2(\S_bit_index_reg_n_0_[1] ),
        .I3(\S_bit_index_reg_n_0_[2] ),
        .I4(\S_rx_data[7]_i_2_n_0 ),
        .I5(p_5_in),
        .O(\S_rx_data[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBFFFFFFF80000000)) 
    \S_rx_data[7]_i_1 
       (.I0(rx_in),
        .I1(\S_bit_index_reg_n_0_[2] ),
        .I2(\S_rx_data[7]_i_2_n_0 ),
        .I3(\S_bit_index_reg_n_0_[1] ),
        .I4(\S_bit_index_reg_n_0_[0] ),
        .I5(\S_rx_data_reg_n_0_[7] ),
        .O(\S_rx_data[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h0008)) 
    \S_rx_data[7]_i_2 
       (.I0(S_state__0[1]),
        .I1(S_state__0[0]),
        .I2(S_state__0[2]),
        .I3(\S_bit_index_reg_n_0_[3] ),
        .O(\S_rx_data[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFBF00000080)) 
    \S_rx_data[8]_i_1 
       (.I0(rx_in),
        .I1(S_state__0[1]),
        .I2(S_state__0[0]),
        .I3(S_state__0[2]),
        .I4(\FSM_sequential_S_state[2]_i_2_n_0 ),
        .I5(p_0_in),
        .O(\S_rx_data[8]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_rx_data_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\S_rx_data[0]_i_1_n_0 ),
        .Q(\S_rx_data_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \S_rx_data_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\S_rx_data[1]_i_1_n_0 ),
        .Q(\S_rx_data_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \S_rx_data_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\S_rx_data[2]_i_1_n_0 ),
        .Q(p_1_in),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \S_rx_data_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(\S_rx_data[3]_i_1_n_0 ),
        .Q(p_2_in),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \S_rx_data_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(\S_rx_data[4]_i_1_n_0 ),
        .Q(p_3_in),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \S_rx_data_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(\S_rx_data[5]_i_1_n_0 ),
        .Q(p_4_in),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \S_rx_data_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(\S_rx_data[6]_i_1_n_0 ),
        .Q(p_5_in),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \S_rx_data_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(\S_rx_data[7]_i_1_n_0 ),
        .Q(\S_rx_data_reg_n_0_[7] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \S_rx_data_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(\S_rx_data[8]_i_1_n_0 ),
        .Q(p_0_in),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 S_timer0_carry
       (.CI(1'b0),
        .CO({S_timer0_carry_n_0,S_timer0_carry_n_1,S_timer0_carry_n_2,S_timer0_carry_n_3}),
        .CYINIT(\S_timer_reg_n_0_[0] ),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[4:1]),
        .S({\S_timer_reg_n_0_[4] ,\S_timer_reg_n_0_[3] ,\S_timer_reg_n_0_[2] ,\S_timer_reg_n_0_[1] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 S_timer0_carry__0
       (.CI(S_timer0_carry_n_0),
        .CO({S_timer0_carry__0_n_0,S_timer0_carry__0_n_1,S_timer0_carry__0_n_2,S_timer0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[8:5]),
        .S({\S_timer_reg_n_0_[8] ,\S_timer_reg_n_0_[7] ,\S_timer_reg_n_0_[6] ,\S_timer_reg_n_0_[5] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 S_timer0_carry__1
       (.CI(S_timer0_carry__0_n_0),
        .CO({S_timer0_carry__1_n_0,S_timer0_carry__1_n_1,S_timer0_carry__1_n_2,S_timer0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[12:9]),
        .S({\S_timer_reg_n_0_[12] ,\S_timer_reg_n_0_[11] ,\S_timer_reg_n_0_[10] ,\S_timer_reg_n_0_[9] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 S_timer0_carry__2
       (.CI(S_timer0_carry__1_n_0),
        .CO({S_timer0_carry__2_n_0,S_timer0_carry__2_n_1,S_timer0_carry__2_n_2,S_timer0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[16:13]),
        .S({\S_timer_reg_n_0_[16] ,\S_timer_reg_n_0_[15] ,\S_timer_reg_n_0_[14] ,\S_timer_reg_n_0_[13] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 S_timer0_carry__3
       (.CI(S_timer0_carry__2_n_0),
        .CO({S_timer0_carry__3_n_0,S_timer0_carry__3_n_1,S_timer0_carry__3_n_2,S_timer0_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[20:17]),
        .S({\S_timer_reg_n_0_[20] ,\S_timer_reg_n_0_[19] ,\S_timer_reg_n_0_[18] ,\S_timer_reg_n_0_[17] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 S_timer0_carry__4
       (.CI(S_timer0_carry__3_n_0),
        .CO({S_timer0_carry__4_n_0,S_timer0_carry__4_n_1,S_timer0_carry__4_n_2,S_timer0_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[24:21]),
        .S({\S_timer_reg_n_0_[24] ,\S_timer_reg_n_0_[23] ,\S_timer_reg_n_0_[22] ,\S_timer_reg_n_0_[21] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 S_timer0_carry__5
       (.CI(S_timer0_carry__4_n_0),
        .CO({S_timer0_carry__5_n_0,S_timer0_carry__5_n_1,S_timer0_carry__5_n_2,S_timer0_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[28:25]),
        .S({\S_timer_reg_n_0_[28] ,\S_timer_reg_n_0_[27] ,\S_timer_reg_n_0_[26] ,\S_timer_reg_n_0_[25] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 S_timer0_carry__6
       (.CI(S_timer0_carry__5_n_0),
        .CO({NLW_S_timer0_carry__6_CO_UNCONNECTED[3:2],S_timer0_carry__6_n_2,S_timer0_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_S_timer0_carry__6_O_UNCONNECTED[3],data0[31:29]}),
        .S({1'b0,\S_timer_reg_n_0_[31] ,\S_timer_reg_n_0_[30] ,\S_timer_reg_n_0_[29] }));
  LUT6 #(
    .INIT(64'h0000FFFFFFF40000)) 
    \S_timer[0]_i_1 
       (.I0(S_state__0[2]),
        .I1(\S_timer[0]_i_2_n_0 ),
        .I2(\S_timer[0]_i_3_n_0 ),
        .I3(\S_timer[31]_i_4_n_0 ),
        .I4(S_timer),
        .I5(\S_timer_reg_n_0_[0] ),
        .O(\S_timer[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \S_timer[0]_i_2 
       (.I0(\S_timer[0]_i_4_n_0 ),
        .I1(\S_timer[0]_i_5_n_0 ),
        .I2(\S_timer[0]_i_6_n_0 ),
        .I3(\S_timer[0]_i_7_n_0 ),
        .I4(\S_timer[0]_i_8_n_0 ),
        .I5(\S_timer[0]_i_9_n_0 ),
        .O(\S_timer[0]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h06)) 
    \S_timer[0]_i_3 
       (.I0(\S_timer_reg_n_0_[13] ),
        .I1(\S_timer_reg_n_0_[4] ),
        .I2(S_state__0[2]),
        .O(\S_timer[0]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \S_timer[0]_i_4 
       (.I0(\S_timer_reg_n_0_[25] ),
        .I1(\S_timer_reg_n_0_[24] ),
        .I2(\S_timer_reg_n_0_[27] ),
        .I3(\S_timer_reg_n_0_[26] ),
        .O(\S_timer[0]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \S_timer[0]_i_5 
       (.I0(\S_timer_reg_n_0_[29] ),
        .I1(\S_timer_reg_n_0_[28] ),
        .I2(\S_timer_reg_n_0_[31] ),
        .I3(\S_timer_reg_n_0_[30] ),
        .O(\S_timer[0]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \S_timer[0]_i_6 
       (.I0(\S_timer_reg_n_0_[17] ),
        .I1(\S_timer_reg_n_0_[16] ),
        .I2(\S_timer_reg_n_0_[19] ),
        .I3(\S_timer_reg_n_0_[18] ),
        .O(\S_timer[0]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \S_timer[0]_i_7 
       (.I0(\S_timer_reg_n_0_[21] ),
        .I1(\S_timer_reg_n_0_[20] ),
        .I2(\S_timer_reg_n_0_[23] ),
        .I3(\S_timer_reg_n_0_[22] ),
        .O(\S_timer[0]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \S_timer[0]_i_8 
       (.I0(\S_timer_reg_n_0_[10] ),
        .I1(\S_timer_reg_n_0_[8] ),
        .I2(\S_timer_reg_n_0_[15] ),
        .I3(\S_timer_reg_n_0_[14] ),
        .O(\S_timer[0]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'hFFEF)) 
    \S_timer[0]_i_9 
       (.I0(\S_timer_reg_n_0_[2] ),
        .I1(\S_timer_reg_n_0_[1] ),
        .I2(\S_timer_reg_n_0_[7] ),
        .I3(\S_timer_reg_n_0_[3] ),
        .O(\S_timer[0]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00000000A2A0A0A2)) 
    \S_timer[31]_i_1 
       (.I0(S_timer),
        .I1(\S_timer[31]_i_3_n_0 ),
        .I2(S_state__0[2]),
        .I3(\S_timer_reg_n_0_[4] ),
        .I4(\S_timer_reg_n_0_[13] ),
        .I5(\S_timer[31]_i_4_n_0 ),
        .O(\S_timer[31]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h06)) 
    \S_timer[31]_i_2 
       (.I0(S_state__0[1]),
        .I1(S_state__0[0]),
        .I2(S_state__0[2]),
        .O(S_timer));
  LUT2 #(
    .INIT(4'hE)) 
    \S_timer[31]_i_3 
       (.I0(\S_timer[0]_i_2_n_0 ),
        .I1(\S_timer_reg_n_0_[0] ),
        .O(\S_timer[31]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hAABFAAFE)) 
    \S_timer[31]_i_4 
       (.I0(\S_timer[31]_i_5_n_0 ),
        .I1(\S_timer_reg_n_0_[5] ),
        .I2(\S_timer_reg_n_0_[4] ),
        .I3(S_state__0[2]),
        .I4(S_state__0[1]),
        .O(\S_timer[31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00FE00FF00FF007F)) 
    \S_timer[31]_i_5 
       (.I0(\S_timer_reg_n_0_[9] ),
        .I1(\S_timer_reg_n_0_[6] ),
        .I2(\S_timer_reg_n_0_[12] ),
        .I3(S_state__0[2]),
        .I4(\S_timer_reg_n_0_[4] ),
        .I5(\S_timer_reg_n_0_[11] ),
        .O(\S_timer[31]_i_5_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\S_timer[0]_i_1_n_0 ),
        .Q(\S_timer_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[10] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[10]),
        .Q(\S_timer_reg_n_0_[10] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[11] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[11]),
        .Q(\S_timer_reg_n_0_[11] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[12] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[12]),
        .Q(\S_timer_reg_n_0_[12] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[13] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[13]),
        .Q(\S_timer_reg_n_0_[13] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[14] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[14]),
        .Q(\S_timer_reg_n_0_[14] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[15] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[15]),
        .Q(\S_timer_reg_n_0_[15] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[16] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[16]),
        .Q(\S_timer_reg_n_0_[16] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[17] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[17]),
        .Q(\S_timer_reg_n_0_[17] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[18] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[18]),
        .Q(\S_timer_reg_n_0_[18] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[19] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[19]),
        .Q(\S_timer_reg_n_0_[19] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[1] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[1]),
        .Q(\S_timer_reg_n_0_[1] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[20] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[20]),
        .Q(\S_timer_reg_n_0_[20] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[21] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[21]),
        .Q(\S_timer_reg_n_0_[21] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[22] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[22]),
        .Q(\S_timer_reg_n_0_[22] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[23] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[23]),
        .Q(\S_timer_reg_n_0_[23] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[24] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[24]),
        .Q(\S_timer_reg_n_0_[24] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[25] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[25]),
        .Q(\S_timer_reg_n_0_[25] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[26] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[26]),
        .Q(\S_timer_reg_n_0_[26] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[27] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[27]),
        .Q(\S_timer_reg_n_0_[27] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[28] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[28]),
        .Q(\S_timer_reg_n_0_[28] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[29] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[29]),
        .Q(\S_timer_reg_n_0_[29] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[2] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[2]),
        .Q(\S_timer_reg_n_0_[2] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[30] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[30]),
        .Q(\S_timer_reg_n_0_[30] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[31] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[31]),
        .Q(\S_timer_reg_n_0_[31] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[3] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[3]),
        .Q(\S_timer_reg_n_0_[3] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[4] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[4]),
        .Q(\S_timer_reg_n_0_[4] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[5] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[5]),
        .Q(\S_timer_reg_n_0_[5] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[6] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[6]),
        .Q(\S_timer_reg_n_0_[6] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[7] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[7]),
        .Q(\S_timer_reg_n_0_[7] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[8] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[8]),
        .Q(\S_timer_reg_n_0_[8] ),
        .R(\S_timer[31]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \S_timer_reg[9] 
       (.C(clk),
        .CE(S_timer),
        .D(data0[9]),
        .Q(\S_timer_reg_n_0_[9] ),
        .R(\S_timer[31]_i_1_n_0 ));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
