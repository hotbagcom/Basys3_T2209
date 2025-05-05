----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Arif
-- 
-- Create Date: 03.11.2024 22:26:24
-- Design Name: 
-- Module Name: t02_Word_mux2 - bhvrl_mux2
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
use IEEE.NUMERIC_STD.ALL;
entity t02_Word_mux2 is
    Port (
        sellection : in std_logic ;
        choice_0 : in std_logic_vector(RV_lvlinbit-1 downto 0) ;
        choice_1 : in std_logic_vector(RV_lvlinbit-1 downto 0) ;
        output : out std_logic_vector(RV_lvlinbit-1 downto 0) 
        );
end t02_Word_mux2;
architecture bhvrl_mux2 of t02_Word_mux2 is
begin
process ( sellection , choice_0 , choice_1 ) begin
    if sellection = '0' then
        output <= choice_0 ;
    else 
        output <= choice_1 ;
    end if ;
end process ;
end bhvrl_mux2;
