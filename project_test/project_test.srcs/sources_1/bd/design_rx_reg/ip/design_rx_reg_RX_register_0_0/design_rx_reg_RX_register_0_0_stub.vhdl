-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
-- Date        : Sun Nov  3 20:21:45 2024
-- Host        : Arif running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/arify/WorkSpace/Basys3_T2209/project_test/project_test.srcs/sources_1/bd/design_rx_reg/ip/design_rx_reg_RX_register_0_0/design_rx_reg_RX_register_0_0_stub.vhdl
-- Design      : design_rx_reg_RX_register_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_rx_reg_RX_register_0_0 is
  Port ( 
    clk : in STD_LOGIC;
    rx_in : in STD_LOGIC;
    RX_serial : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );

end design_rx_reg_RX_register_0_0;

architecture stub of design_rx_reg_RX_register_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,rx_in,RX_serial[7:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "RX_register,Vivado 2020.1";
begin
end;
