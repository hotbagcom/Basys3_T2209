----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2025 16:30:14
-- Design Name: 
-- Module Name: p02_dec2hex_4_7seg - Behavioral
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


entity p02_dec2hex_4_7seg is
Port (
    
    dec0_in : in integer range 0 to 9 := 0 ;
    dec1_in : in integer range 0 to 9 := 0 ;
    dec2_in : in integer range 0 to 9 := 0 ;
    dec3_in : in integer range 0 to 9 := 0 ; 
    
    hex_out : out std_logic_vector(10 downto 0) := "00000000000"

);
end p02_dec2hex_4_7seg;

architecture Behavioral of p02_dec2hex_4_7seg is
signal S_hex_out : std_logic_vector(10 downto 0) ;

begin


process (dec0_in , dec1_in, dec2_in , dec3_in  )begin

    S_hex_out <= std_logic_vector( to_unsigned( dec0_in + dec1_in *10 +  dec2_in *100 +  dec2_in *1000  , 11));
    hex_out <= S_hex_out ;

end process ;

end Behavioral;