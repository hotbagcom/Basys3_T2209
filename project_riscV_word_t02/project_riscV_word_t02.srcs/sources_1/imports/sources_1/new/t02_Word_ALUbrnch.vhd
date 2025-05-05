----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2024 16:29:40
-- Design Name: 
-- Module Name: t02_Word_ALUbrnch - bhvrl_ALUbrnch
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

entity t02_Word_ALUbrnch is
    Port(
        add_pc :in std_logic_vector(3 downto 0) := X"1" ;
        alu_jump_correction : in std_logic;
        cntrl_brnch_enable : in std_logic;
        prev_PC : in  std_logic_vector(RV_lvlinbit-1 downto 0) ; 
        -- next_PC : --jumpun çýkýþýna yaz 
        brnch_imm : in std_logic_vector (RV_lvlinbit-1 downto 0);
        alubrnch_out :  out std_logic_vector(RV_lvlinbit-1 downto 0) 
    );
end t02_Word_ALUbrnch;

architecture bhvrl_ALUbrnch of t02_Word_ALUbrnch is

-- for word processor : X"1" -- for halfword processor : X"2" -- for bit processor : X"4" -
--brnch_imm((31 downto 2))   --brnch_imm((31 downto 1))       --brnch_imm((31 downto 0))
begin

process ( cntrl_brnch_enable , alu_jump_correction , prev_PC , brnch_imm ) begin
    if (cntrl_brnch_enable = '0' or alu_jump_correction = '0') then 
        alubrnch_out <= std_logic_vector( unsigned( prev_PC) + unsigned( add_pc) );
    elsif (cntrl_brnch_enable = '1' and alu_jump_correction = '1') then 
        if (brnch_imm(RV_lvlinbit-1) = '0') then
            alubrnch_out <= std_logic_vector( unsigned( prev_PC) + unsigned( brnch_imm(RV_lvlinbit-1 downto 2) ) );
        elsif (brnch_imm(RV_lvlinbit-1) = '1') then
            alubrnch_out <= std_logic_vector( signed( prev_PC) + signed( brnch_imm(RV_lvlinbit-1 downto 2) ) );
        end if ;
end if ;

end process ;

end bhvrl_ALUbrnch;
