----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2025 16:07:26
-- Design Name: 
-- Module Name: p04_lgcvect2decimal - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity p04_lgcvect2decimal is
    Port (
    count_ARD_SPI_clk_i : in std_logic_vector(11 downto 0) := X"000";
    ready_Cardspiclk_i : in std_logic := '0' ;  
    count_ARD_SPI_clk_7seg_o : in std_logic_vector(15 downto 0) := X"0000"

    );
end p04_lgcvect2decimal;

architecture Behavioral of p04_lgcvect2decimal is

signal S_ones : std_logic_vector(3 downto 0 ) := x"0" ;
signal S_tens : std_logic_vector(3 downto 0 ) := x"0" ;
signal S_hunterts : std_logic_vector(3 downto 0 ) := x"0" ;
signal S_thousands : std_logic_vector(3 downto 0 ) := x"0" ;

signal S_count_ARD_SPI_clk_i : std_logic_vector(11 downto 0 ) := x"000" ;
--signal S_part3 : std_logic_vector(7 downto 0 ) := x"00" ;


begin

Catch_clkperiode : 
process (ready_Cardspiclk_i ) begin 
    if ( rising_edge(ready_Cardspiclk_i ) ) then
        S_count_ARD_SPI_clk_i <= count_ARD_SPI_clk_i ;
    end if ;
end process ;

--Seperate_2_digit : 
--process (S_count_ARD_SPI_clk_i ) begin 
--   for  ( S_count_ARD_SPI_clk_i >= x"3E8" ) then 
    
    
    
    
    
--end process ;





end Behavioral;
