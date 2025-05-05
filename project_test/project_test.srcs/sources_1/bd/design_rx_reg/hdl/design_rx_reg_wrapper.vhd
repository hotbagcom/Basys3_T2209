--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
--Date        : Sun Nov  3 20:21:10 2024
--Host        : Arif running 64-bit major release  (build 9200)
--Command     : generate_target design_rx_reg_wrapper.bd
--Design      : design_rx_reg_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_rx_reg_wrapper is
  port (
    clk_100MHz : in STD_LOGIC;
    led0_out8 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    rx_in : in STD_LOGIC
  );
end design_rx_reg_wrapper;

architecture STRUCTURE of design_rx_reg_wrapper is
  component design_rx_reg is
  port (
    led0_out8 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    rx_in : in STD_LOGIC;
    clk_100MHz : in STD_LOGIC
  );
  end component design_rx_reg;
begin
design_rx_reg_i: component design_rx_reg
     port map (
      clk_100MHz => clk_100MHz,
      led0_out8(7 downto 0) => led0_out8(7 downto 0),
      rx_in => rx_in
    );
end STRUCTURE;
