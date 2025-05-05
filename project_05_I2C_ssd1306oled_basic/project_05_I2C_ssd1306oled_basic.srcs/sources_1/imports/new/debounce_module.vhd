----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2025 19:51:15
-- Design Name: 
-- Module Name: debounce_module - Behavioral
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

entity debounce_module is
    Generic(
        X_clkHz : integer := 100_000_000;
        debounce_max : integer := 10_000_000--1_000_000 
        
    );
    Port (
    
        Xclk : in std_logic ;
        
        BTN_top_deb :  in std_logic_vector(4 downto 0) ;
        SW_top_deb : in std_logic_vector(15 downto 0) ;
        BTN_topdeb :  out std_logic_vector(4 downto 0) ;
        SW_topdeb : out std_logic_vector(15 downto 0) 
        
     );
end debounce_module;

architecture Behavioral of debounce_module is

signal debounce_cntr :integer range 0 to debounce_max := 0;
signal input_circle : std_logic_vector( 20 downto 0 ) := (others => '0') ;
signal input_circle_status : std_logic_vector( 20 downto 0 ) := (others => '0') ;
signal cycle_counter : integer range 0 to 20  := 0 ;
begin


process ( Xclk ) begin 
    input_circle <= BTN_top_deb & SW_top_deb ;
    
 
    
    if rising_edge(Xclk) then 
        if cycle_counter >= 20 then 
        cycle_counter <= 0;
            if debounce_cntr < debounce_max then
                debounce_cntr <= debounce_cntr +1 ;
            elsif debounce_cntr >= debounce_max then
                debounce_cntr <= 0 ;
                input_circle_status(20) <= input_circle(20) ;
            end if ;
        elsif cycle_counter < 20 then 
        
            
        cycle_counter <= cycle_counter + 1 ;
            if debounce_cntr < debounce_max then
                debounce_cntr <= debounce_cntr +1 ;
            elsif debounce_cntr >= debounce_max then
                debounce_cntr <= 0 ;
                input_circle_status(cycle_counter) <= input_circle(cycle_counter) ;
            end if ;
        end if ;
    end if ;
    BTN_topdeb <= input_circle_status( 20 downto 16 ); -- input_circle( 20 downto 16 ); -- 
    SW_topdeb <=  input_circle_status( 15 downto 0 );  --input_circle( 15 downto 0 ); --
    
end process ;


end Behavioral;

