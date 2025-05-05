----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2025 14:11:00
-- Design Name: 
-- Module Name: userinterface_module - Behavioral
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

entity userinterface_module is
Port (
        Xclk : in std_logic ;
        userbutton_updown :  in std_logic_vector( 1 downto 0 ) ;
        CLK_interf : out std_logic  := '0' ;
        RST_interf : out std_logic ;
        convert : in  std_logic ;
        fourHEX : in std_logic_vector( 15 downto 0 ) ;
        userled : out  std_logic_vector( 15 downto 0 )  := X"0000" 
    );
end userinterface_module;

architecture Behavioral of userinterface_module is
signal S_CLK_interf : std_logic  := '0' ;
signal S_RST_interf : std_logic  := '0' ;
begin

process (Xclk , userbutton_updown , convert ) begin 

    if ( falling_edge( userbutton_updown(0) ) ) then
        S_RST_interf <= not S_RST_interf ;
    end if ;
    
    RST_interf <= S_RST_interf ;
    
    
    if ( falling_edge( userbutton_updown(1) ) ) then
        S_CLK_interf <= not S_CLK_interf ;
    end if ;
    
    CLK_interf <= S_CLK_interf ;
    
    if(convert = '1') then 
        userled <= fourHEX(15 downto 14) & userbutton_updown &  fourHEX(11 downto 0)  ;
    else 
        userled <= X"0000";
    end if ;
    
    
end process;

end Behavioral;
