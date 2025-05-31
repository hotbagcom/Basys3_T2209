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
    reset_n_char : in std_logic := '0' ;
    
    
    --str_Text_index :  in  std_logic_vector( 3 downto 0) := "0000"  ;--if every char is 8x8 then 16 char will fill the line
    str_char_index :  in  std_logic_vector( 2 downto 0) := "000"  ;-- not active  to get one by one every btye of char .
    str_char_in_asciTable : integer range 0 to 127 := 0 ;-- every char first index is length
    
    str_new_char_print_req : in std_logic := '0' ;--for to automaticaly distinguish nex pixel sending sequence . 
      str_new_char_print_en : out std_logic := '0' ;--for to enable pre mba 
      str_char_transformed2byte_done :  out  std_logic := '0'  ;--to let know str2char module  bitmap for one char sended to preMBA
      pix_in_byte : out std_logic_vector(7 downto 0) := x"00";--each byte of bitmap sended to preMBA
    bitmap_tx_done  : in std_logic := '0'; -- Pulses high for one clock when done
      str_char_length : out  std_logic_vector( 2 downto 0) := "000"  ;--in case of We implement in different size for char (3x8 or 6x8).
      
      error_str       : out  std_logic := '0' 
    
    );
end p08_char2pix;

architecture Behavioral of p08_char2pix is

type char_pixbyte_t is array (natural range <>) of std_logic_vector(7 downto 0)  ;
type char_asciT_array_t is array (31 to 127) of char_pixbyte_t ;
Signal Si_crnt_char_inpix : char_pixbyte_t := ( X"00" , X"00" , X"00" , X"00" , X"00" , X"00" , X"00" , X"00" );--initial plan is to be 8X8 size pixel size


               

type pixel_byte_fsm_state_t is (
        S_IDLE,
        S_pix_SET_LENGTH ,
        S_pix_GET_ASCI, 
        S_pix_SET_BYTE, 
        S_pix_WAIT , 
        S_pix_DONE 
);
signal ASCII_State :pixel_byte_fsm_state_t := S_IDLE ;


signal Si_str_char_transformed2byte_done : std_logic := '1'  ;
signal Si_str_char_index : integer range 0 to 12 := 0 ;
signal Si_bitmap_tx_done :  std_logic := '0';


begin


str_char_transformed2byte_done <= Si_str_char_transformed2byte_done ;
Si_bitmap_tx_done <= bitmap_tx_done ;




    
process (str_char_in_asciTable  ) begin 
        if (str_char_in_asciTable > 31 ) then
           Si_crnt_char_inpix <= C_asciT(str_char_in_asciTable);
        else--if () then 
            Si_crnt_char_inpix <= C_asciT(127) ;
        end if ;
        

end process ;    


process ( clk ) begin 
if rising_edge(clk) and ( ena_text = '1' ) then
    if (reset_n_char = '1' )then 
        
                ASCII_State <= S_IDLE ;
                Si_str_char_index <= 0 ;
                
    else  
        case (ASCII_State) is 
        
        when
        S_IDLE =>--according to mode value 
            if (str_new_char_print_req = '1') then
                ASCII_State <= S_pix_GET_ASCI ;
                --S_GENERAL_UPDATE ,
            end if ;
        
        when
        S_pix_SET_LENGTH => --optional 
        --
            str_char_length <= Si_crnt_char_inpix(0)(2 downto 0);
        
        when S_pix_GET_ASCI => 
            Si_str_char_transformed2byte_done <= '0';
            Si_str_char_index <= 0 ;
            ASCII_State <= S_pix_SET_BYTE ;
        
        when S_pix_SET_BYTE => 
          if (Si_str_char_index < 8) then
          pix_in_byte <=  Si_crnt_char_inpix(Si_str_char_index);
          ASCII_State <= S_pix_WAIT ;
          else
          ASCII_State <= S_pix_DONE ;
          end if ;
          
        when S_pix_WAIT => 
            if (Si_bitmap_tx_done = '1') then 
            Si_str_char_index <= Si_str_char_index +1;
            ASCII_State <= S_pix_SET_BYTE ;
            end if ;
            
        when S_pix_DONE =>
        
            Si_str_char_transformed2byte_done <= '1';
            if (str_new_char_print_req = '0') then
                ASCII_State <= S_IDLE ;
                --S_GENERAL_UPDATE ,
            end if ;
           

        
        end case ;
    end if ;      
end if ;   
end process ;

        




end Behavioral;
