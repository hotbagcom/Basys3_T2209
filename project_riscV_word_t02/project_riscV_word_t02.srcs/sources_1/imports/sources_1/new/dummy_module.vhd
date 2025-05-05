----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.12.2024 14:51:40
-- Design Name: 
-- Module Name: dummy_module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.package_top.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dummy_module is
    generic(
        dm_depth : integer :=  RV_lvlinbit 
    );
    Port (
        current_pc : in std_logic_vector( RV_lvlinbit-1 downto 0 ) := (others=>'0');
        alubrnch_out :  in std_logic_vector(RV_lvlinbit-1 downto 0) ;
        reg_source0_out : in std_logic_vector(RV_lvlinbit-1 downto 0);
        reg_source1_out : in std_logic_vector(RV_lvlinbit-1 downto 0);
        IMM_out : in std_logic_vector(RV_lvlinbit-1  downto 0) ;
        alu_flag : in std_logic_vector(2 downto 0) := (others=>'0') ; -- MSB overflow | zero LSB  | brnch active 
        alu_data_out : in std_logic_vector(RV_lvlinbit-1 downto 0) := (others=>'0'); 
        cntrl_dm_write_enable : in std_logic := '0';
        cntrl_dm_read_enable : in std_logic := '0';
        cntrl_brnch_enable  : in std_logic := '0';
        cntrl_jump_enable  : in std_logic := '0';
        cnrtl_reg_write_enable : in std_logic := '0';
        cnrtl_alu_data_srce_slkt : in std_logic := '0' ;
        cnrtl_reg_write_srce_slkt : in std_logic := '0' ;
        output_mux_0: in std_logic_vector(RV_lvlinbit-1 downto 0) ;
        output_mux_1: in std_logic_vector(RV_lvlinbit-1 downto 0) ;
        output_mux_2: in std_logic_vector(RV_lvlinbit-1 downto 0) ;
        dm_data_out:in std_logic_vector(dm_depth-1 downto 0) := (others=>'0');
        
        dumy : out std_logic      ;
        dummy : out std_logic_vector( 1 downto 0) 
    );
end dummy_module;

architecture Behavioral of dummy_module is
signal dummy32_0 :  std_logic_vector(RV_lvlinbit-1 downto 0) ;
signal dummy32_1 :  std_logic_vector(RV_lvlinbit-1 downto 0) ;
signal dummy8_0 :  std_logic_vector(7 downto 0) ;
signal dummy2_0 :  std_logic_vector(1 downto 0) ;
signal dummy_0 :  std_logic;
signal dummy_1 :  std_logic ;


begin
dummy32_0 <= current_pc and alubrnch_out and reg_source0_out and reg_source1_out and IMM_out and alu_data_out ;
dummy32_1 <= output_mux_0 and output_mux_1 and output_mux_2 and dm_data_out and dummy32_0;
dummy8_0 <= dummy32_1(31 downto 24) and dummy32_1(23 downto 16) and dummy32_1(15 downto 8) and dummy32_1(7 downto 0)  ;
dummy2_0 <= dummy8_0( 7 downto 6 ) and dummy8_0( 5 downto 4 ) and dummy8_0( 3 downto 2 ) and dummy8_0( 1 downto 0 ) and alu_flag(2 downto 1) and alu_flag(1 downto 0) ;

dummy_0 <= cntrl_dm_write_enable and cntrl_dm_read_enable and cntrl_brnch_enable and cntrl_jump_enable and cnrtl_reg_write_enable ;
dummy_1 <= dummy_0 and cnrtl_alu_data_srce_slkt and cnrtl_reg_write_srce_slkt;

dummy <= dummy2_0 ;
dumy <= dummy_1;

end Behavioral;
