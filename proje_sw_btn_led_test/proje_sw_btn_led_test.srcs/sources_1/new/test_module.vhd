----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2025 00:03:00
-- Design Name: 
-- Module Name: test_module - Behavioral
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

entity test_module is
    Port (
    BTN_top : in std_logic_vector(4 downto 0);
    SW_top : in std_logic_vector(15 downto 0);
    LED_top : out std_logic_vector(15 downto 0)
    );
end test_module;

architecture Behavioral of test_module is
begin

process ( BTN_top ) begin
  LED_top <= not SW_top ;
end process ;

process ( SW_top ) begin
  LED_top <=  SW_top ;
end process ;

end Behavioral;
