----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2024 21:13:36
-- Design Name: 
-- Module Name: project_btnled_top - bhvrl_btnled_top
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
--use constr.xdc;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project_btnled_top is
    Port (
        sw0_in8 : in std_logic_vector(7 downto 0 ) := X"35";
        sw1_in8 : in std_logic_vector(7 downto 0 ) := X"17";
        led0_out8 : out std_logic_vector(7 downto 0 ) ;
        led1_out8 : out std_logic_vector(7 downto 0 ) ;
        SEVENseg_AN : out std_logic_vector(3 downto 0 ):= "1111";
        sevenseg : out std_logic_vector(7 downto 0) := "11111111" 
    );
end project_btnled_top;

architecture bhvrl_btnled_top of project_btnled_top is
begin

LSB_Side :
process ( sw0_in8 , sw1_in8 ) begin
led0_out8 <= sw0_in8 and sw1_in8;
end process ;

MSB_Side :
process ( sw0_in8 , sw1_in8 ) begin
led1_out8 <=  sw0_in8 or sw1_in8;
end process ;


end bhvrl_btnled_top;
