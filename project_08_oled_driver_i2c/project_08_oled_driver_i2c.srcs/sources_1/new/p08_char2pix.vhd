----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.05.2025 15:53:28
-- Design Name: 
-- Module Name: p08_char2pix - Behavioral
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

entity p08_char2pix is
    Port ( 
    
    
    clk : in STD_LOGIC ;
    ena_text : in STD_LOGIC;
    reset_n : in std_logic := '0' ;
    
    --str_Text_index :  in  std_logic_vector( 3 downto 0) := "0000"  ;--if every char is 8x8 then 16 char will fill the line
    str_char_index :  in  std_logic_vector( 2 downto 0) := "000"  ;-- to get one by one every btye of char .
    str_char_in_asciTable :in std_logic_vector(7 downto 0) := x"00";-- every char first index is length
    
    pix_in_byte : out std_logic_vector(7 downto 0) := x"00";
    str_char_length : out  std_logic_vector( 2 downto 0) := "000"  ;--in case of We implement in different size for char (3x8 or 6x8).
    
    error_str       : out  std_logic := '0' 
    
    );
end p08_char2pix;

architecture Behavioral of p08_char2pix is

begin


    
    
    
--p08_pix2byte_mdl : entity work.p08_pix2byte
--     Port Map ( 
    
--    clk : in STD_LOGIC ;
--    ena_text : in STD_LOGIC;
--    reset_n : in std_logic := '0' ;
    
--    );
        process (str_char_in_asciTable  ) begin 
        
        case (str_char_in_asciTable) is 
            when (0) => -- space
                current_char_inpix <= (some array );
                str_char_length <= X"8"
            when () => 
                current_char_inpix <= (some array );
                
                
                
            when () => 
                current_char_inpix <= (some array );
            when (127) => 
                current_char_inpix <= (some array );
                
        
        end case ;
        
        
        
        
        case (state) is 
        
        
        
        
            when 
            pix_in_byte <= current_char_inpix(   str_char_index    )
            
            
            
        
        end case ;
        
        end process ;
        
        




end Behavioral;
