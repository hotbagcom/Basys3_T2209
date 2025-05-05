--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
--Date        : Sun Nov  3 20:21:10 2024
--Host        : Arif running 64-bit major release  (build 9200)
--Command     : generate_target design_rx_reg.bd
--Design      : design_rx_reg
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_rx_reg is
  port (
    clk_100MHz : in STD_LOGIC;
    led0_out8 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    rx_in : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_rx_reg : entity is "design_rx_reg,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_rx_reg,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=1,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of design_rx_reg : entity is "design_rx_reg.hwdef";
end design_rx_reg;

architecture STRUCTURE of design_rx_reg is
  component design_rx_reg_clk_wiz_0_0 is
  port (
    reset : in STD_LOGIC;
    clk_in1 : in STD_LOGIC;
    clk_out1 : out STD_LOGIC;
    locked : out STD_LOGIC
  );
  end component design_rx_reg_clk_wiz_0_0;
  component design_rx_reg_ila_0_0 is
  port (
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe1 : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component design_rx_reg_ila_0_0;
  component design_rx_reg_RX_register_0_0 is
  port (
    clk : in STD_LOGIC;
    rx_in : in STD_LOGIC;
    RX_serial : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component design_rx_reg_RX_register_0_0;
  signal RX_register_0_RX_serial : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal clk_in1_0_1 : STD_LOGIC;
  signal clk_wiz_0_clk_out1 : STD_LOGIC;
  signal rx_in_0_1 : STD_LOGIC;
  signal NLW_clk_wiz_0_locked_UNCONNECTED : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk_100MHz : signal is "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk_100MHz : signal is "XIL_INTERFACENAME CLK.CLK_100MHZ, CLK_DOMAIN design_rx_reg_clk_in1_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000";
begin
  clk_in1_0_1 <= clk_100MHz;
  led0_out8(7 downto 0) <= RX_register_0_RX_serial(7 downto 0);
  rx_in_0_1 <= rx_in;
RX_register_0: component design_rx_reg_RX_register_0_0
     port map (
      RX_serial(7 downto 0) => RX_register_0_RX_serial(7 downto 0),
      clk => clk_wiz_0_clk_out1,
      rx_in => rx_in_0_1
    );
clk_wiz_0: component design_rx_reg_clk_wiz_0_0
     port map (
      clk_in1 => clk_in1_0_1,
      clk_out1 => clk_wiz_0_clk_out1,
      locked => NLW_clk_wiz_0_locked_UNCONNECTED,
      reset => '0'
    );
ila_0: component design_rx_reg_ila_0_0
     port map (
      clk => clk_wiz_0_clk_out1,
      probe0(0) => rx_in_0_1,
      probe1(7 downto 0) => RX_register_0_RX_serial(7 downto 0)
    );
end STRUCTURE;
