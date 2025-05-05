----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2025 16:35:19
-- Design Name: 
-- Module Name: p02_btn2freq_controller - Behavioral
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

entity p02_btn2freq_controller is
  Port (
    BTN_top : in std_logic_vector(4 downto 0) := "00000" ;
    
    dec0_out : out integer range 0 to 9 := 0 ;
    dec1_out : out integer range 0 to 9 := 0 ;
    dec2_out : out integer range 0 to 9 := 0 ;
    dec3_out : out integer range 0 to 9 := 0 ;
    
    update_Wfreq : out std_logic := '0' 
   );
end p02_btn2freq_controller;

architecture Behavioral of p02_btn2freq_controller is
signal unit : std_logic_vector(2 downto 0)  := "01" ;
signal S_position : std_logic_vector(1 downto 0)  := "00" ;
type buf is array(0 to 3 ) of  std_logic_vector(4 downto 0)  ;
signal S_decimal : buf :=  ("0000","0000","0000","0000");
begin

process (BTN_top) begin
dec0_out <= to_integer( unsigned(S_decimal(0) )) ;
dec1_out <= to_integer( unsigned(S_decimal(1) )) ;
dec2_out <= to_integer( unsigned(S_decimal(2) )) ;
dec3_out <= to_integer( unsigned(S_decimal(3) )) ;

    
if(BTN_top(1) = '1'  and S_decimal( to_integer( unsigned(S_position))) /= "0000"   ) then --down 
    S_decimal( to_integer( unsigned(S_position)))  <=   std_logic_vector(   unsigned(S_decimal(  to_integer( unsigned(S_position)) )) - unsigned(unit)   )   ;
elsif (BTN_top(2) = '1'  and  S_decimal( to_integer( unsigned(S_position))) < X"a" ) then--up
    S_decimal( to_integer( unsigned(S_position)))  <=   std_logic_vector(   unsigned(S_decimal(  to_integer( unsigned(S_position)) )) + unsigned(unit)   )   ;
end if ;


if(BTN_top(3) = '1') then--right
    S_position <= std_logic_vector(unsigned(S_position) - unsigned(unit)) ; 
elsif ((BTN_top(4) = '1') and S_position /= X"3") then--left
    S_position <= std_logic_vector(unsigned(S_position) + unsigned(unit)) ; 
end if ;


if(BTN_top(0) = '1') then--center
    update_Wfreq <= '1' ;  
else
    update_Wfreq <= '1' ;  
end if ;



end process ; 

end Behavioral;
