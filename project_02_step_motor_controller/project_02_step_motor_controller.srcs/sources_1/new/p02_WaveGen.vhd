----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2025 17:51:46
-- Design Name: 
-- Module Name: p02_WaveGen - Behavioral
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

entity p02_WaveGen is
  Generic(
        X_clkHz : integer := 100_000_000 
        
    );
    Port (
        Xclk : in std_logic ;
        Wave_frequen : in std_logic_vector(10 downto 0) := "00000000000";
        update_Wfrq : in std_logic  := '0';  
        pwm_out : out std_logic  := '0' 
    );
end p02_WaveGen;

architecture Behavioral of p02_WaveGen is
signal current_Wfreq : std_logic_vector(16 downto 0) := "00000000000000000" ;
signal  pwmincr_max :  std_logic_vector(16 downto 0)     := "00000000000000000" ;
signal  pwmIncr :  std_logic_vector(16 downto 0)     := "00000000000000000" ;
signal unit : std_logic_vector(2 downto 0)  := "01" ;
signal WG_periode :  std_logic_vector(16 downto 0) := "00000000000000000" ;
begin

process ( Xclk ) begin


if (current_Wfreq > (Wave_frequen & "000000") ) then
pwmincr_max   <=   std_logic_vector(   unsigned(current_Wfreq) - unsigned(Wave_frequen & "000000" )   )  ;
else
pwmincr_max   <=   std_logic_vector(   unsigned(Wave_frequen & "000000" ) -  unsigned(current_Wfreq)   )  ;
end if ;

if(pwmIncr < pwmincr_max) then
pwmIncr   <=   std_logic_vector(   unsigned(pwmIncr) + unsigned(unit )   )  ;
else
pwmIncr   <=   std_logic_vector(   unsigned(pwmIncr) - unsigned(unit )   )  ;
end if ;    

if unsigned(current_Wfreq(16 downto 6)) /= 0 then
    WG_periode <= X_clkHz / to_integer(unsigned(current_Wfreq(16 downto 6)));
else
    WG_periode <= (others => '0'); -- veya baþka default bir deðer
end if;

0 a bölme 


---------
for( i  0 to  )

end process ;

end Behavioral;
