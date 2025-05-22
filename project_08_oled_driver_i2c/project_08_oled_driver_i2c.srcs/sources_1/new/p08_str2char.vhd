----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.05.2025 15:53:28
-- Design Name: 
-- Module Name: p08_str2char - Behavioral
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

entity p08_str2char is
    Port ( 
    clk : in STD_LOGIC ;
    ena_text : in STD_LOGIC;
    reset_n : in std_logic := '0' ;
  
    
        Module_name_ID   :  in std_logic_vector(7 downto 0) := X"00";       
        Module_io_ID     :  in std_logic := '0' ;                           
        Module_pin_ID    :  in std_logic_vector(6 downto 0) := X"00";       
        Module_value_ID  :  in std_logic_vector(31 downto 0) := X"00abcd00";
        
     
    str_Line_number : in  std_logic_vector( 2 downto 0) := "000"  ;
    str_Text_index :  in  std_logic_vector( 3 downto 0) := "0000"  ;--if every char is 8x8 then 16 char will fill the line
    str_char_index :  in  std_logic_vector( 2 downto 0) := "000"  ;-- to get one by one every btye of char .
    
    str_Text_length : out  std_logic_vector( 3 downto 0) := "0000"  ;
    str_char_length : out  std_logic_vector( 2 downto 0) := "000"  ;--in case of We implement in different size for char (3x8 or 6x8).
    error_str       : out  std_logic_vector( 3 downto 0) := "0000" 
    );
end p08_str2char;

architecture Behavioral of p08_str2char is

begin

p08_char2pix_mdl : entity work.p08_char2pix
    Port Map ( 
    
    clk : in STD_LOGIC ;
    ena_text : in STD_LOGIC;
    reset_n : in std_logic := '0' ;
    
    --str_Text_index :  in  std_logic_vector( 3 downto 0) := "0000"  ;--if every char is 8x8 then 16 char will fill the line
    str_char_index :  in  std_logic_vector( 2 downto 0) := "000"  ;-- to get one by one every btye of char .
    str_char_in_asciTable :in std_logic_vector(7 downto 0) := x"00";-- every char first index is length
    
    pix_in_byte : out std_logic_vector(7 downto 0) := x"00";
    str_char_length : out  std_logic_vector( 2 downto 0) := "000"  ;--in case of We implement in different size for char (3x8 or 6x8).
    
    error_str       : out  std_logic_vector( 1 downto 0) := "00" 
    );



process (clk) begin 
    
    if rising_edge(clk) then
                                        if (Module_io_ID = 0)then
                                            Module_io_ID_crnt <= (some array )(in / out)
                                        else
                                             Module_io_ID_crnt <= (some array )(in / out)
                                        end if ;

    
        case (Module_name_ID) is
            when "000" =>
                Module_name_ID_crnt <= (some array ) ;
                if (Module_io_ID = 0)then
                    case (Module_pin_ID) is
                        when "000" =>
                            Module_pin_ID_crnt <= (some array ) ;
                        when "010" =>
                            Module_pin_ID_crnt <= (some array ) ;
                        when "100" =>
                            Module_pin_ID_crnt <= (some array ) ;
                        when "110" =>
                            Module_pin_ID_crnt <= (some array ) ;
                    end case ;
                else
                
                end if ;
            when "010" =>
                Module_io_ID   (str_Text_index)
            when "100" =>
                Module_pin_ID  (str_Text_index)
            when "110" =>
                Module_value_ID(str_Text_index)
        end case ;
    
        
        for i in 0 to 4 is
            Module_value_ID_crnt(i) =Module_value_ID(3+i*4 downto i*4);
        
        end loop ;
        
    
    
    
    
        case (str_Line_number) is
            when "000" =>
                current_text <= Module_name_ID_crnt  ;---made of array 
            when "010" =>
                current_text <= Module_io_ID_crnt    ;
            when "100" =>
                current_text <= Module_pin_ID_crnt   ;
            when "110" =>
                current_text <= Module_value_ID_crnt ;
        end case ;
        
    end if ;
    
end process ;















end Behavioral;
