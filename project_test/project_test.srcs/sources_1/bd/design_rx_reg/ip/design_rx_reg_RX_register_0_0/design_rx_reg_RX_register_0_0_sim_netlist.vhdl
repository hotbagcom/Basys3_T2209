-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
-- Date        : Sun Nov  3 20:21:45 2024
-- Host        : Arif running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Users/arify/WorkSpace/Basys3_T2209/project_test/project_test.srcs/sources_1/bd/design_rx_reg/ip/design_rx_reg_RX_register_0_0/design_rx_reg_RX_register_0_0_sim_netlist.vhdl
-- Design      : design_rx_reg_RX_register_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_rx_reg_RX_register_0_0_RX_register is
  port (
    RX_serial : out STD_LOGIC_VECTOR ( 7 downto 0 );
    clk : in STD_LOGIC;
    rx_in : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_rx_reg_RX_register_0_0_RX_register : entity is "RX_register";
end design_rx_reg_RX_register_0_0_RX_register;

architecture STRUCTURE of design_rx_reg_RX_register_0_0_RX_register is
  signal \FSM_sequential_S_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_S_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_S_state[1]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_sequential_S_state[2]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_S_state[2]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_sequential_S_state[2]_i_3_n_0\ : STD_LOGIC;
  signal \FSM_sequential_S_state[2]_i_4_n_0\ : STD_LOGIC;
  signal \FSM_sequential_S_state[2]_i_5_n_0\ : STD_LOGIC;
  signal \FSM_sequential_S_state[2]_i_6_n_0\ : STD_LOGIC;
  signal \FSM_sequential_S_state[2]_i_7_n_0\ : STD_LOGIC;
  signal \FSM_sequential_S_state[2]_i_8_n_0\ : STD_LOGIC;
  signal \FSM_sequential_S_state[2]_i_9_n_0\ : STD_LOGIC;
  signal \RX_serial[7]_i_1_n_0\ : STD_LOGIC;
  signal \RX_serial[7]_i_2_n_0\ : STD_LOGIC;
  signal \RX_serial[7]_i_3_n_0\ : STD_LOGIC;
  signal \RX_serial[7]_i_4_n_0\ : STD_LOGIC;
  signal S_bit_index : STD_LOGIC;
  signal \S_bit_index[0]_i_1_n_0\ : STD_LOGIC;
  signal \S_bit_index[1]_i_1_n_0\ : STD_LOGIC;
  signal \S_bit_index[2]_i_1_n_0\ : STD_LOGIC;
  signal \S_bit_index[3]_i_2_n_0\ : STD_LOGIC;
  signal \S_bit_index_reg_n_0_[0]\ : STD_LOGIC;
  signal \S_bit_index_reg_n_0_[1]\ : STD_LOGIC;
  signal \S_bit_index_reg_n_0_[2]\ : STD_LOGIC;
  signal \S_bit_index_reg_n_0_[3]\ : STD_LOGIC;
  signal S_ready_i_1_n_0 : STD_LOGIC;
  signal S_ready_i_2_n_0 : STD_LOGIC;
  signal S_ready_i_3_n_0 : STD_LOGIC;
  signal S_ready_reg_n_0 : STD_LOGIC;
  signal \S_rx_data[0]_i_1_n_0\ : STD_LOGIC;
  signal \S_rx_data[1]_i_1_n_0\ : STD_LOGIC;
  signal \S_rx_data[2]_i_1_n_0\ : STD_LOGIC;
  signal \S_rx_data[3]_i_1_n_0\ : STD_LOGIC;
  signal \S_rx_data[4]_i_1_n_0\ : STD_LOGIC;
  signal \S_rx_data[5]_i_1_n_0\ : STD_LOGIC;
  signal \S_rx_data[6]_i_1_n_0\ : STD_LOGIC;
  signal \S_rx_data[7]_i_1_n_0\ : STD_LOGIC;
  signal \S_rx_data[7]_i_2_n_0\ : STD_LOGIC;
  signal \S_rx_data[8]_i_1_n_0\ : STD_LOGIC;
  signal \S_rx_data_reg_n_0_[0]\ : STD_LOGIC;
  signal \S_rx_data_reg_n_0_[1]\ : STD_LOGIC;
  signal \S_rx_data_reg_n_0_[7]\ : STD_LOGIC;
  signal \S_state__0\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal S_timer : STD_LOGIC;
  signal \S_timer0_carry__0_n_0\ : STD_LOGIC;
  signal \S_timer0_carry__0_n_1\ : STD_LOGIC;
  signal \S_timer0_carry__0_n_2\ : STD_LOGIC;
  signal \S_timer0_carry__0_n_3\ : STD_LOGIC;
  signal \S_timer0_carry__1_n_0\ : STD_LOGIC;
  signal \S_timer0_carry__1_n_1\ : STD_LOGIC;
  signal \S_timer0_carry__1_n_2\ : STD_LOGIC;
  signal \S_timer0_carry__1_n_3\ : STD_LOGIC;
  signal \S_timer0_carry__2_n_0\ : STD_LOGIC;
  signal \S_timer0_carry__2_n_1\ : STD_LOGIC;
  signal \S_timer0_carry__2_n_2\ : STD_LOGIC;
  signal \S_timer0_carry__2_n_3\ : STD_LOGIC;
  signal \S_timer0_carry__3_n_0\ : STD_LOGIC;
  signal \S_timer0_carry__3_n_1\ : STD_LOGIC;
  signal \S_timer0_carry__3_n_2\ : STD_LOGIC;
  signal \S_timer0_carry__3_n_3\ : STD_LOGIC;
  signal \S_timer0_carry__4_n_0\ : STD_LOGIC;
  signal \S_timer0_carry__4_n_1\ : STD_LOGIC;
  signal \S_timer0_carry__4_n_2\ : STD_LOGIC;
  signal \S_timer0_carry__4_n_3\ : STD_LOGIC;
  signal \S_timer0_carry__5_n_0\ : STD_LOGIC;
  signal \S_timer0_carry__5_n_1\ : STD_LOGIC;
  signal \S_timer0_carry__5_n_2\ : STD_LOGIC;
  signal \S_timer0_carry__5_n_3\ : STD_LOGIC;
  signal \S_timer0_carry__6_n_2\ : STD_LOGIC;
  signal \S_timer0_carry__6_n_3\ : STD_LOGIC;
  signal S_timer0_carry_n_0 : STD_LOGIC;
  signal S_timer0_carry_n_1 : STD_LOGIC;
  signal S_timer0_carry_n_2 : STD_LOGIC;
  signal S_timer0_carry_n_3 : STD_LOGIC;
  signal \S_timer[0]_i_1_n_0\ : STD_LOGIC;
  signal \S_timer[0]_i_2_n_0\ : STD_LOGIC;
  signal \S_timer[0]_i_3_n_0\ : STD_LOGIC;
  signal \S_timer[0]_i_4_n_0\ : STD_LOGIC;
  signal \S_timer[0]_i_5_n_0\ : STD_LOGIC;
  signal \S_timer[0]_i_6_n_0\ : STD_LOGIC;
  signal \S_timer[0]_i_7_n_0\ : STD_LOGIC;
  signal \S_timer[0]_i_8_n_0\ : STD_LOGIC;
  signal \S_timer[0]_i_9_n_0\ : STD_LOGIC;
  signal \S_timer[31]_i_1_n_0\ : STD_LOGIC;
  signal \S_timer[31]_i_3_n_0\ : STD_LOGIC;
  signal \S_timer[31]_i_4_n_0\ : STD_LOGIC;
  signal \S_timer[31]_i_5_n_0\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[0]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[10]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[11]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[12]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[13]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[14]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[15]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[16]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[17]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[18]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[19]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[1]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[20]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[21]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[22]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[23]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[24]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[25]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[26]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[27]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[28]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[29]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[2]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[30]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[31]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[3]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[4]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[5]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[6]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[7]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[8]\ : STD_LOGIC;
  signal \S_timer_reg_n_0_[9]\ : STD_LOGIC;
  signal data0 : STD_LOGIC_VECTOR ( 31 downto 1 );
  signal p_0_in : STD_LOGIC;
  signal p_1_in : STD_LOGIC;
  signal p_2_in : STD_LOGIC;
  signal p_3_in : STD_LOGIC;
  signal p_4_in : STD_LOGIC;
  signal p_5_in : STD_LOGIC;
  signal \NLW_S_timer0_carry__6_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_S_timer0_carry__6_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_S_state[2]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \FSM_sequential_S_state[2]_i_2\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \FSM_sequential_S_state[2]_i_4\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \FSM_sequential_S_state[2]_i_7\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \FSM_sequential_S_state[2]_i_8\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \FSM_sequential_S_state[2]_i_9\ : label is "soft_lutpair3";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_S_state_reg[0]\ : label is "strt:001,receive:011,check:100,rdy:000,waiting:010";
  attribute FSM_ENCODED_STATES of \FSM_sequential_S_state_reg[1]\ : label is "strt:001,receive:011,check:100,rdy:000,waiting:010";
  attribute FSM_ENCODED_STATES of \FSM_sequential_S_state_reg[2]\ : label is "strt:001,receive:011,check:100,rdy:000,waiting:010";
  attribute SOFT_HLUTNM of \S_bit_index[1]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \S_bit_index[2]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \S_bit_index[3]_i_2\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \S_rx_data[7]_i_2\ : label is "soft_lutpair2";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of S_timer0_carry : label is 35;
  attribute ADDER_THRESHOLD of \S_timer0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \S_timer0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \S_timer0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \S_timer0_carry__3\ : label is 35;
  attribute ADDER_THRESHOLD of \S_timer0_carry__4\ : label is 35;
  attribute ADDER_THRESHOLD of \S_timer0_carry__5\ : label is 35;
  attribute ADDER_THRESHOLD of \S_timer0_carry__6\ : label is 35;
begin
\FSM_sequential_S_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00FF1300"
    )
        port map (
      I0 => S_ready_reg_n_0,
      I1 => \S_state__0\(2),
      I2 => \S_state__0\(1),
      I3 => \FSM_sequential_S_state[2]_i_3_n_0\,
      I4 => \S_state__0\(0),
      O => \FSM_sequential_S_state[0]_i_1_n_0\
    );
\FSM_sequential_S_state[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AEAAFFFFAEAA0000"
    )
        port map (
      I0 => \FSM_sequential_S_state[1]_i_2_n_0\,
      I1 => \S_state__0\(0),
      I2 => \S_state__0\(2),
      I3 => \FSM_sequential_S_state[2]_i_2_n_0\,
      I4 => \FSM_sequential_S_state[2]_i_3_n_0\,
      I5 => \S_state__0\(1),
      O => \FSM_sequential_S_state[1]_i_1_n_0\
    );
\FSM_sequential_S_state[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"015A010A010A015A"
    )
        port map (
      I0 => \S_state__0\(0),
      I1 => S_ready_reg_n_0,
      I2 => \S_state__0\(2),
      I3 => \S_state__0\(1),
      I4 => p_0_in,
      I5 => \RX_serial[7]_i_3_n_0\,
      O => \FSM_sequential_S_state[1]_i_2_n_0\
    );
\FSM_sequential_S_state[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00FF0800"
    )
        port map (
      I0 => \S_state__0\(1),
      I1 => \S_state__0\(0),
      I2 => \FSM_sequential_S_state[2]_i_2_n_0\,
      I3 => \FSM_sequential_S_state[2]_i_3_n_0\,
      I4 => \S_state__0\(2),
      O => \FSM_sequential_S_state[2]_i_1_n_0\
    );
\FSM_sequential_S_state[2]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FEFF"
    )
        port map (
      I0 => \S_bit_index_reg_n_0_[0]\,
      I1 => \S_bit_index_reg_n_0_[1]\,
      I2 => \S_bit_index_reg_n_0_[2]\,
      I3 => \S_bit_index_reg_n_0_[3]\,
      O => \FSM_sequential_S_state[2]_i_2_n_0\
    );
\FSM_sequential_S_state[2]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFAAAFAAAE"
    )
        port map (
      I0 => \FSM_sequential_S_state[2]_i_4_n_0\,
      I1 => \FSM_sequential_S_state[2]_i_5_n_0\,
      I2 => \S_timer_reg_n_0_[0]\,
      I3 => \S_timer[0]_i_2_n_0\,
      I4 => \FSM_sequential_S_state[2]_i_6_n_0\,
      I5 => \FSM_sequential_S_state[2]_i_7_n_0\,
      O => \FSM_sequential_S_state[2]_i_3_n_0\
    );
\FSM_sequential_S_state[2]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"000D"
    )
        port map (
      I0 => rx_in,
      I1 => \S_state__0\(2),
      I2 => \S_state__0\(1),
      I3 => \S_state__0\(0),
      O => \FSM_sequential_S_state[2]_i_4_n_0\
    );
\FSM_sequential_S_state[2]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0400000000000000"
    )
        port map (
      I0 => \S_timer_reg_n_0_[6]\,
      I1 => \S_timer_reg_n_0_[5]\,
      I2 => \S_timer_reg_n_0_[9]\,
      I3 => \S_timer_reg_n_0_[11]\,
      I4 => \S_state__0\(1),
      I5 => \FSM_sequential_S_state[2]_i_8_n_0\,
      O => \FSM_sequential_S_state[2]_i_5_n_0\
    );
\FSM_sequential_S_state[2]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0400000000000000"
    )
        port map (
      I0 => \S_timer_reg_n_0_[5]\,
      I1 => \S_timer_reg_n_0_[6]\,
      I2 => \S_timer_reg_n_0_[11]\,
      I3 => \S_timer_reg_n_0_[9]\,
      I4 => \S_state__0\(0),
      I5 => \FSM_sequential_S_state[2]_i_9_n_0\,
      O => \FSM_sequential_S_state[2]_i_6_n_0\
    );
\FSM_sequential_S_state[2]_i_7\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \S_state__0\(2),
      I1 => \S_state__0\(0),
      I2 => \S_state__0\(1),
      O => \FSM_sequential_S_state[2]_i_7_n_0\
    );
\FSM_sequential_S_state[2]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0400"
    )
        port map (
      I0 => \S_state__0\(2),
      I1 => \S_timer_reg_n_0_[4]\,
      I2 => \S_timer_reg_n_0_[12]\,
      I3 => \S_timer_reg_n_0_[13]\,
      O => \FSM_sequential_S_state[2]_i_8_n_0\
    );
\FSM_sequential_S_state[2]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0100"
    )
        port map (
      I0 => \S_timer_reg_n_0_[4]\,
      I1 => \S_state__0\(2),
      I2 => \S_timer_reg_n_0_[13]\,
      I3 => \S_timer_reg_n_0_[12]\,
      O => \FSM_sequential_S_state[2]_i_9_n_0\
    );
\FSM_sequential_S_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \FSM_sequential_S_state[0]_i_1_n_0\,
      Q => \S_state__0\(0),
      R => '0'
    );
\FSM_sequential_S_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \FSM_sequential_S_state[1]_i_1_n_0\,
      Q => \S_state__0\(1),
      R => '0'
    );
\FSM_sequential_S_state_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \FSM_sequential_S_state[2]_i_1_n_0\,
      Q => \S_state__0\(2),
      R => '0'
    );
\RX_serial[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000060"
    )
        port map (
      I0 => \RX_serial[7]_i_3_n_0\,
      I1 => p_0_in,
      I2 => \S_state__0\(2),
      I3 => \S_state__0\(0),
      I4 => \S_state__0\(1),
      O => \RX_serial[7]_i_1_n_0\
    );
\RX_serial[7]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"10"
    )
        port map (
      I0 => \S_state__0\(1),
      I1 => \S_state__0\(0),
      I2 => \S_state__0\(2),
      O => \RX_serial[7]_i_2_n_0\
    );
\RX_serial[7]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_2_in,
      I1 => p_3_in,
      I2 => \S_rx_data_reg_n_0_[1]\,
      I3 => p_1_in,
      I4 => \RX_serial[7]_i_4_n_0\,
      O => \RX_serial[7]_i_3_n_0\
    );
\RX_serial[7]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => p_5_in,
      I1 => p_4_in,
      I2 => \S_rx_data_reg_n_0_[0]\,
      I3 => \S_rx_data_reg_n_0_[7]\,
      O => \RX_serial[7]_i_4_n_0\
    );
\RX_serial_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \RX_serial[7]_i_2_n_0\,
      D => \S_rx_data_reg_n_0_[0]\,
      Q => RX_serial(0),
      S => \RX_serial[7]_i_1_n_0\
    );
\RX_serial_reg[1]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \RX_serial[7]_i_2_n_0\,
      D => \S_rx_data_reg_n_0_[1]\,
      Q => RX_serial(1),
      S => \RX_serial[7]_i_1_n_0\
    );
\RX_serial_reg[2]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \RX_serial[7]_i_2_n_0\,
      D => p_1_in,
      Q => RX_serial(2),
      S => \RX_serial[7]_i_1_n_0\
    );
\RX_serial_reg[3]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \RX_serial[7]_i_2_n_0\,
      D => p_2_in,
      Q => RX_serial(3),
      S => \RX_serial[7]_i_1_n_0\
    );
\RX_serial_reg[4]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \RX_serial[7]_i_2_n_0\,
      D => p_3_in,
      Q => RX_serial(4),
      S => \RX_serial[7]_i_1_n_0\
    );
\RX_serial_reg[5]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \RX_serial[7]_i_2_n_0\,
      D => p_4_in,
      Q => RX_serial(5),
      S => \RX_serial[7]_i_1_n_0\
    );
\RX_serial_reg[6]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \RX_serial[7]_i_2_n_0\,
      D => p_5_in,
      Q => RX_serial(6),
      S => \RX_serial[7]_i_1_n_0\
    );
\RX_serial_reg[7]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \RX_serial[7]_i_2_n_0\,
      D => rx_in,
      Q => RX_serial(7),
      S => \RX_serial[7]_i_1_n_0\
    );
\S_bit_index[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \S_state__0\(1),
      I1 => \S_bit_index_reg_n_0_[0]\,
      O => \S_bit_index[0]_i_1_n_0\
    );
\S_bit_index[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"28"
    )
        port map (
      I0 => \S_state__0\(1),
      I1 => \S_bit_index_reg_n_0_[1]\,
      I2 => \S_bit_index_reg_n_0_[0]\,
      O => \S_bit_index[1]_i_1_n_0\
    );
\S_bit_index[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2888"
    )
        port map (
      I0 => \S_state__0\(1),
      I1 => \S_bit_index_reg_n_0_[2]\,
      I2 => \S_bit_index_reg_n_0_[0]\,
      I3 => \S_bit_index_reg_n_0_[1]\,
      O => \S_bit_index[2]_i_1_n_0\
    );
\S_bit_index[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"00C1"
    )
        port map (
      I0 => rx_in,
      I1 => \S_state__0\(1),
      I2 => \S_state__0\(0),
      I3 => \S_state__0\(2),
      O => S_bit_index
    );
\S_bit_index[3]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"28888888"
    )
        port map (
      I0 => \S_state__0\(1),
      I1 => \S_bit_index_reg_n_0_[3]\,
      I2 => \S_bit_index_reg_n_0_[1]\,
      I3 => \S_bit_index_reg_n_0_[0]\,
      I4 => \S_bit_index_reg_n_0_[2]\,
      O => \S_bit_index[3]_i_2_n_0\
    );
\S_bit_index_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_bit_index,
      D => \S_bit_index[0]_i_1_n_0\,
      Q => \S_bit_index_reg_n_0_[0]\,
      R => '0'
    );
\S_bit_index_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_bit_index,
      D => \S_bit_index[1]_i_1_n_0\,
      Q => \S_bit_index_reg_n_0_[1]\,
      R => '0'
    );
\S_bit_index_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_bit_index,
      D => \S_bit_index[2]_i_1_n_0\,
      Q => \S_bit_index_reg_n_0_[2]\,
      R => '0'
    );
\S_bit_index_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_bit_index,
      D => \S_bit_index[3]_i_2_n_0\,
      Q => \S_bit_index_reg_n_0_[3]\,
      R => '0'
    );
S_ready_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBBBBBFF000000F4"
    )
        port map (
      I0 => \S_timer[31]_i_3_n_0\,
      I1 => S_ready_i_2_n_0,
      I2 => \S_state__0\(2),
      I3 => \S_state__0\(0),
      I4 => \S_state__0\(1),
      I5 => S_ready_reg_n_0,
      O => S_ready_i_1_n_0
    );
S_ready_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00100000"
    )
        port map (
      I0 => \S_state__0\(2),
      I1 => \S_timer_reg_n_0_[4]\,
      I2 => \S_state__0\(0),
      I3 => \S_state__0\(1),
      I4 => S_ready_i_3_n_0,
      O => S_ready_i_2_n_0
    );
S_ready_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000002000000000"
    )
        port map (
      I0 => \S_timer_reg_n_0_[9]\,
      I1 => \S_timer_reg_n_0_[11]\,
      I2 => \S_timer_reg_n_0_[6]\,
      I3 => \S_timer_reg_n_0_[5]\,
      I4 => \S_timer_reg_n_0_[13]\,
      I5 => \S_timer_reg_n_0_[12]\,
      O => S_ready_i_3_n_0
    );
S_ready_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => S_ready_i_1_n_0,
      Q => S_ready_reg_n_0,
      R => '0'
    );
\S_rx_data[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFB00000008"
    )
        port map (
      I0 => rx_in,
      I1 => \S_rx_data[7]_i_2_n_0\,
      I2 => \S_bit_index_reg_n_0_[0]\,
      I3 => \S_bit_index_reg_n_0_[1]\,
      I4 => \S_bit_index_reg_n_0_[2]\,
      I5 => \S_rx_data_reg_n_0_[0]\,
      O => \S_rx_data[0]_i_1_n_0\
    );
\S_rx_data[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEFFFFFF02000000"
    )
        port map (
      I0 => rx_in,
      I1 => \S_bit_index_reg_n_0_[1]\,
      I2 => \S_bit_index_reg_n_0_[2]\,
      I3 => \S_bit_index_reg_n_0_[0]\,
      I4 => \S_rx_data[7]_i_2_n_0\,
      I5 => \S_rx_data_reg_n_0_[1]\,
      O => \S_rx_data[1]_i_1_n_0\
    );
\S_rx_data[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFEFFFFF00200000"
    )
        port map (
      I0 => rx_in,
      I1 => \S_bit_index_reg_n_0_[0]\,
      I2 => \S_bit_index_reg_n_0_[1]\,
      I3 => \S_bit_index_reg_n_0_[2]\,
      I4 => \S_rx_data[7]_i_2_n_0\,
      I5 => p_1_in,
      O => \S_rx_data[2]_i_1_n_0\
    );
\S_rx_data[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EFFFFFFF20000000"
    )
        port map (
      I0 => rx_in,
      I1 => \S_bit_index_reg_n_0_[2]\,
      I2 => \S_bit_index_reg_n_0_[0]\,
      I3 => \S_bit_index_reg_n_0_[1]\,
      I4 => \S_rx_data[7]_i_2_n_0\,
      I5 => p_2_in,
      O => \S_rx_data[3]_i_1_n_0\
    );
\S_rx_data[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEFFFFFF02000000"
    )
        port map (
      I0 => rx_in,
      I1 => \S_bit_index_reg_n_0_[1]\,
      I2 => \S_bit_index_reg_n_0_[0]\,
      I3 => \S_bit_index_reg_n_0_[2]\,
      I4 => \S_rx_data[7]_i_2_n_0\,
      I5 => p_3_in,
      O => \S_rx_data[4]_i_1_n_0\
    );
\S_rx_data[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EFFFFFFF20000000"
    )
        port map (
      I0 => rx_in,
      I1 => \S_bit_index_reg_n_0_[1]\,
      I2 => \S_bit_index_reg_n_0_[0]\,
      I3 => \S_bit_index_reg_n_0_[2]\,
      I4 => \S_rx_data[7]_i_2_n_0\,
      I5 => p_4_in,
      O => \S_rx_data[5]_i_1_n_0\
    );
\S_rx_data[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EFFFFFFF20000000"
    )
        port map (
      I0 => rx_in,
      I1 => \S_bit_index_reg_n_0_[0]\,
      I2 => \S_bit_index_reg_n_0_[1]\,
      I3 => \S_bit_index_reg_n_0_[2]\,
      I4 => \S_rx_data[7]_i_2_n_0\,
      I5 => p_5_in,
      O => \S_rx_data[6]_i_1_n_0\
    );
\S_rx_data[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BFFFFFFF80000000"
    )
        port map (
      I0 => rx_in,
      I1 => \S_bit_index_reg_n_0_[2]\,
      I2 => \S_rx_data[7]_i_2_n_0\,
      I3 => \S_bit_index_reg_n_0_[1]\,
      I4 => \S_bit_index_reg_n_0_[0]\,
      I5 => \S_rx_data_reg_n_0_[7]\,
      O => \S_rx_data[7]_i_1_n_0\
    );
\S_rx_data[7]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0008"
    )
        port map (
      I0 => \S_state__0\(1),
      I1 => \S_state__0\(0),
      I2 => \S_state__0\(2),
      I3 => \S_bit_index_reg_n_0_[3]\,
      O => \S_rx_data[7]_i_2_n_0\
    );
\S_rx_data[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFBF00000080"
    )
        port map (
      I0 => rx_in,
      I1 => \S_state__0\(1),
      I2 => \S_state__0\(0),
      I3 => \S_state__0\(2),
      I4 => \FSM_sequential_S_state[2]_i_2_n_0\,
      I5 => p_0_in,
      O => \S_rx_data[8]_i_1_n_0\
    );
\S_rx_data_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \S_rx_data[0]_i_1_n_0\,
      Q => \S_rx_data_reg_n_0_[0]\,
      R => '0'
    );
\S_rx_data_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \S_rx_data[1]_i_1_n_0\,
      Q => \S_rx_data_reg_n_0_[1]\,
      R => '0'
    );
\S_rx_data_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \S_rx_data[2]_i_1_n_0\,
      Q => p_1_in,
      R => '0'
    );
\S_rx_data_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \S_rx_data[3]_i_1_n_0\,
      Q => p_2_in,
      R => '0'
    );
\S_rx_data_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \S_rx_data[4]_i_1_n_0\,
      Q => p_3_in,
      R => '0'
    );
\S_rx_data_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \S_rx_data[5]_i_1_n_0\,
      Q => p_4_in,
      R => '0'
    );
\S_rx_data_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \S_rx_data[6]_i_1_n_0\,
      Q => p_5_in,
      R => '0'
    );
\S_rx_data_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \S_rx_data[7]_i_1_n_0\,
      Q => \S_rx_data_reg_n_0_[7]\,
      R => '0'
    );
\S_rx_data_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \S_rx_data[8]_i_1_n_0\,
      Q => p_0_in,
      R => '0'
    );
S_timer0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => S_timer0_carry_n_0,
      CO(2) => S_timer0_carry_n_1,
      CO(1) => S_timer0_carry_n_2,
      CO(0) => S_timer0_carry_n_3,
      CYINIT => \S_timer_reg_n_0_[0]\,
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(4 downto 1),
      S(3) => \S_timer_reg_n_0_[4]\,
      S(2) => \S_timer_reg_n_0_[3]\,
      S(1) => \S_timer_reg_n_0_[2]\,
      S(0) => \S_timer_reg_n_0_[1]\
    );
\S_timer0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => S_timer0_carry_n_0,
      CO(3) => \S_timer0_carry__0_n_0\,
      CO(2) => \S_timer0_carry__0_n_1\,
      CO(1) => \S_timer0_carry__0_n_2\,
      CO(0) => \S_timer0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(8 downto 5),
      S(3) => \S_timer_reg_n_0_[8]\,
      S(2) => \S_timer_reg_n_0_[7]\,
      S(1) => \S_timer_reg_n_0_[6]\,
      S(0) => \S_timer_reg_n_0_[5]\
    );
\S_timer0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \S_timer0_carry__0_n_0\,
      CO(3) => \S_timer0_carry__1_n_0\,
      CO(2) => \S_timer0_carry__1_n_1\,
      CO(1) => \S_timer0_carry__1_n_2\,
      CO(0) => \S_timer0_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(12 downto 9),
      S(3) => \S_timer_reg_n_0_[12]\,
      S(2) => \S_timer_reg_n_0_[11]\,
      S(1) => \S_timer_reg_n_0_[10]\,
      S(0) => \S_timer_reg_n_0_[9]\
    );
\S_timer0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \S_timer0_carry__1_n_0\,
      CO(3) => \S_timer0_carry__2_n_0\,
      CO(2) => \S_timer0_carry__2_n_1\,
      CO(1) => \S_timer0_carry__2_n_2\,
      CO(0) => \S_timer0_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(16 downto 13),
      S(3) => \S_timer_reg_n_0_[16]\,
      S(2) => \S_timer_reg_n_0_[15]\,
      S(1) => \S_timer_reg_n_0_[14]\,
      S(0) => \S_timer_reg_n_0_[13]\
    );
\S_timer0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \S_timer0_carry__2_n_0\,
      CO(3) => \S_timer0_carry__3_n_0\,
      CO(2) => \S_timer0_carry__3_n_1\,
      CO(1) => \S_timer0_carry__3_n_2\,
      CO(0) => \S_timer0_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(20 downto 17),
      S(3) => \S_timer_reg_n_0_[20]\,
      S(2) => \S_timer_reg_n_0_[19]\,
      S(1) => \S_timer_reg_n_0_[18]\,
      S(0) => \S_timer_reg_n_0_[17]\
    );
\S_timer0_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \S_timer0_carry__3_n_0\,
      CO(3) => \S_timer0_carry__4_n_0\,
      CO(2) => \S_timer0_carry__4_n_1\,
      CO(1) => \S_timer0_carry__4_n_2\,
      CO(0) => \S_timer0_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(24 downto 21),
      S(3) => \S_timer_reg_n_0_[24]\,
      S(2) => \S_timer_reg_n_0_[23]\,
      S(1) => \S_timer_reg_n_0_[22]\,
      S(0) => \S_timer_reg_n_0_[21]\
    );
\S_timer0_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \S_timer0_carry__4_n_0\,
      CO(3) => \S_timer0_carry__5_n_0\,
      CO(2) => \S_timer0_carry__5_n_1\,
      CO(1) => \S_timer0_carry__5_n_2\,
      CO(0) => \S_timer0_carry__5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(28 downto 25),
      S(3) => \S_timer_reg_n_0_[28]\,
      S(2) => \S_timer_reg_n_0_[27]\,
      S(1) => \S_timer_reg_n_0_[26]\,
      S(0) => \S_timer_reg_n_0_[25]\
    );
\S_timer0_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \S_timer0_carry__5_n_0\,
      CO(3 downto 2) => \NLW_S_timer0_carry__6_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \S_timer0_carry__6_n_2\,
      CO(0) => \S_timer0_carry__6_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \NLW_S_timer0_carry__6_O_UNCONNECTED\(3),
      O(2 downto 0) => data0(31 downto 29),
      S(3) => '0',
      S(2) => \S_timer_reg_n_0_[31]\,
      S(1) => \S_timer_reg_n_0_[30]\,
      S(0) => \S_timer_reg_n_0_[29]\
    );
\S_timer[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000FFFFFFF40000"
    )
        port map (
      I0 => \S_state__0\(2),
      I1 => \S_timer[0]_i_2_n_0\,
      I2 => \S_timer[0]_i_3_n_0\,
      I3 => \S_timer[31]_i_4_n_0\,
      I4 => S_timer,
      I5 => \S_timer_reg_n_0_[0]\,
      O => \S_timer[0]_i_1_n_0\
    );
\S_timer[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \S_timer[0]_i_4_n_0\,
      I1 => \S_timer[0]_i_5_n_0\,
      I2 => \S_timer[0]_i_6_n_0\,
      I3 => \S_timer[0]_i_7_n_0\,
      I4 => \S_timer[0]_i_8_n_0\,
      I5 => \S_timer[0]_i_9_n_0\,
      O => \S_timer[0]_i_2_n_0\
    );
\S_timer[0]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \S_timer_reg_n_0_[13]\,
      I1 => \S_timer_reg_n_0_[4]\,
      I2 => \S_state__0\(2),
      O => \S_timer[0]_i_3_n_0\
    );
\S_timer[0]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \S_timer_reg_n_0_[25]\,
      I1 => \S_timer_reg_n_0_[24]\,
      I2 => \S_timer_reg_n_0_[27]\,
      I3 => \S_timer_reg_n_0_[26]\,
      O => \S_timer[0]_i_4_n_0\
    );
\S_timer[0]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \S_timer_reg_n_0_[29]\,
      I1 => \S_timer_reg_n_0_[28]\,
      I2 => \S_timer_reg_n_0_[31]\,
      I3 => \S_timer_reg_n_0_[30]\,
      O => \S_timer[0]_i_5_n_0\
    );
\S_timer[0]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \S_timer_reg_n_0_[17]\,
      I1 => \S_timer_reg_n_0_[16]\,
      I2 => \S_timer_reg_n_0_[19]\,
      I3 => \S_timer_reg_n_0_[18]\,
      O => \S_timer[0]_i_6_n_0\
    );
\S_timer[0]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \S_timer_reg_n_0_[21]\,
      I1 => \S_timer_reg_n_0_[20]\,
      I2 => \S_timer_reg_n_0_[23]\,
      I3 => \S_timer_reg_n_0_[22]\,
      O => \S_timer[0]_i_7_n_0\
    );
\S_timer[0]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \S_timer_reg_n_0_[10]\,
      I1 => \S_timer_reg_n_0_[8]\,
      I2 => \S_timer_reg_n_0_[15]\,
      I3 => \S_timer_reg_n_0_[14]\,
      O => \S_timer[0]_i_8_n_0\
    );
\S_timer[0]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFEF"
    )
        port map (
      I0 => \S_timer_reg_n_0_[2]\,
      I1 => \S_timer_reg_n_0_[1]\,
      I2 => \S_timer_reg_n_0_[7]\,
      I3 => \S_timer_reg_n_0_[3]\,
      O => \S_timer[0]_i_9_n_0\
    );
\S_timer[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000A2A0A0A2"
    )
        port map (
      I0 => S_timer,
      I1 => \S_timer[31]_i_3_n_0\,
      I2 => \S_state__0\(2),
      I3 => \S_timer_reg_n_0_[4]\,
      I4 => \S_timer_reg_n_0_[13]\,
      I5 => \S_timer[31]_i_4_n_0\,
      O => \S_timer[31]_i_1_n_0\
    );
\S_timer[31]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \S_state__0\(1),
      I1 => \S_state__0\(0),
      I2 => \S_state__0\(2),
      O => S_timer
    );
\S_timer[31]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \S_timer[0]_i_2_n_0\,
      I1 => \S_timer_reg_n_0_[0]\,
      O => \S_timer[31]_i_3_n_0\
    );
\S_timer[31]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AABFAAFE"
    )
        port map (
      I0 => \S_timer[31]_i_5_n_0\,
      I1 => \S_timer_reg_n_0_[5]\,
      I2 => \S_timer_reg_n_0_[4]\,
      I3 => \S_state__0\(2),
      I4 => \S_state__0\(1),
      O => \S_timer[31]_i_4_n_0\
    );
\S_timer[31]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00FE00FF00FF007F"
    )
        port map (
      I0 => \S_timer_reg_n_0_[9]\,
      I1 => \S_timer_reg_n_0_[6]\,
      I2 => \S_timer_reg_n_0_[12]\,
      I3 => \S_state__0\(2),
      I4 => \S_timer_reg_n_0_[4]\,
      I5 => \S_timer_reg_n_0_[11]\,
      O => \S_timer[31]_i_5_n_0\
    );
\S_timer_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \S_timer[0]_i_1_n_0\,
      Q => \S_timer_reg_n_0_[0]\,
      R => '0'
    );
\S_timer_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(10),
      Q => \S_timer_reg_n_0_[10]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(11),
      Q => \S_timer_reg_n_0_[11]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(12),
      Q => \S_timer_reg_n_0_[12]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(13),
      Q => \S_timer_reg_n_0_[13]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(14),
      Q => \S_timer_reg_n_0_[14]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(15),
      Q => \S_timer_reg_n_0_[15]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(16),
      Q => \S_timer_reg_n_0_[16]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(17),
      Q => \S_timer_reg_n_0_[17]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(18),
      Q => \S_timer_reg_n_0_[18]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(19),
      Q => \S_timer_reg_n_0_[19]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(1),
      Q => \S_timer_reg_n_0_[1]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(20),
      Q => \S_timer_reg_n_0_[20]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(21),
      Q => \S_timer_reg_n_0_[21]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(22),
      Q => \S_timer_reg_n_0_[22]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(23),
      Q => \S_timer_reg_n_0_[23]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(24),
      Q => \S_timer_reg_n_0_[24]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(25),
      Q => \S_timer_reg_n_0_[25]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(26),
      Q => \S_timer_reg_n_0_[26]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(27),
      Q => \S_timer_reg_n_0_[27]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(28),
      Q => \S_timer_reg_n_0_[28]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(29),
      Q => \S_timer_reg_n_0_[29]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(2),
      Q => \S_timer_reg_n_0_[2]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(30),
      Q => \S_timer_reg_n_0_[30]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(31),
      Q => \S_timer_reg_n_0_[31]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(3),
      Q => \S_timer_reg_n_0_[3]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(4),
      Q => \S_timer_reg_n_0_[4]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(5),
      Q => \S_timer_reg_n_0_[5]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(6),
      Q => \S_timer_reg_n_0_[6]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(7),
      Q => \S_timer_reg_n_0_[7]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(8),
      Q => \S_timer_reg_n_0_[8]\,
      R => \S_timer[31]_i_1_n_0\
    );
\S_timer_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => S_timer,
      D => data0(9),
      Q => \S_timer_reg_n_0_[9]\,
      R => \S_timer[31]_i_1_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_rx_reg_RX_register_0_0 is
  port (
    clk : in STD_LOGIC;
    rx_in : in STD_LOGIC;
    RX_serial : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_rx_reg_RX_register_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_rx_reg_RX_register_0_0 : entity is "design_rx_reg_RX_register_0_0,RX_register,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of design_rx_reg_RX_register_0_0 : entity is "yes";
  attribute ip_definition_source : string;
  attribute ip_definition_source of design_rx_reg_RX_register_0_0 : entity is "module_ref";
  attribute x_core_info : string;
  attribute x_core_info of design_rx_reg_RX_register_0_0 : entity is "RX_register,Vivado 2020.1";
end design_rx_reg_RX_register_0_0;

architecture STRUCTURE of design_rx_reg_RX_register_0_0 is
  attribute x_interface_info : string;
  attribute x_interface_info of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of clk : signal is "XIL_INTERFACENAME clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0";
begin
U0: entity work.design_rx_reg_RX_register_0_0_RX_register
     port map (
      RX_serial(7 downto 0) => RX_serial(7 downto 0),
      clk => clk,
      rx_in => rx_in
    );
end STRUCTURE;
