----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2025 15:19:54
-- Design Name: 
-- Module Name: p04_clkcount_onenable - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity p04_clkcount_onenable is
    Generic (
        SPI_mod : std_ulogic_vector(1 downto 0)  := "00" 
    );
    Port (
        Xclk :  in std_logic := '0' ;
        ard_SPI_clk_i : in std_logic := '0';
        ard_SPI_E_i   : in std_logic := '1';
        ard_SPI_MOSI_i: in std_logic := '0';
        
        ard_SPI_MOSI_buffer_o : out std_logic_vector(7 downto 0) := X"00";
        count_ARD_SPI_clk_o : out std_logic_vector(11 downto 0) := X"000";
        ready_Cardspiclk_o :  out std_logic := '0'

    );
end p04_clkcount_onenable;

architecture Behavioral of p04_clkcount_onenable is
signal S_count_ARD_SPI_clk_o :std_logic_vector(11 downto 0) := X"000" ;
signal S_ard_SPI_MOSI_i : std_logic_vector(7 downto 0) := X"00" ;
begin
process ( Xclk ) begin 
    if( rising_edge(Xclk) )then
        if( ard_SPI_clk_i = '1'  )then
            S_count_ARD_SPI_clk_o <= std_logic_vector( unsigned(S_count_ARD_SPI_clk_o) + x"001") ;
        end if ;
    end if ;
end process ;



process ( ard_SPI_clk_i , ard_SPI_E_i ) begin

    if( ard_SPI_E_i = '0')then 
        if( rising_edge(ard_SPI_clk_i) ) then      
            S_ard_SPI_MOSI_i  <= S_ard_SPI_MOSI_i(6 downto 0) & ard_SPI_MOSI_i ;
        end if ;
        
    elsif( ard_SPI_E_i = '1') then
        count_ARD_SPI_clk_o <= S_count_ARD_SPI_clk_o ;
        ready_Cardspiclk_o <= '1' ;
        ard_SPI_MOSI_buffer_o <= S_ard_SPI_MOSI_i ;
        ready_Cardspiclk_o <= '0' ;
        S_count_ARD_SPI_clk_o <= X"000" ;
        
        
    end if ;
     

end process ;













end Behavioral;
