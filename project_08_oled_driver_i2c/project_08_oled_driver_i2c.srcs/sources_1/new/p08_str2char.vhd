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
 use IEEE.NUMERIC_STD.ALL;

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
    str_Text_index :  in  std_logic_vector( 3 downto 0) := "0000" ;--if every char is 8x8 then 16 char will fill the line
    str_char_index :  in  std_logic_vector( 2 downto 0) := "000"  ;-- to get one by one every btye of char .
    
      str_inbyte      : out std_logic_vector(7 downto 0) := x"00";
      str_Text_length : out  std_logic_vector( 3 downto 0) := "0000" ;
      str_char_length : out  std_logic_vector( 2 downto 0) := "000"  ;--in case of We implement in different size for char (3x8 or 6x8).
      error_str       : out  std_logic_vector( 3 downto 0) := "0000" 
    );
end p08_str2char;

architecture Behavioral of p08_str2char is


signal Si_str_char_in_asciTable : std_logic_vector(7 downto 0) := x"00";-- every char first index is length     


signal Si_Module_name_ID_index  :integer range 0 to 20 := 0 ;
signal Si_Module_io_ID_index    :integer range 0 to 2 := 0 ;
signal Si_Module_pin_ID_index   :integer range 0 to 20 := 0 ;
signal Si_Module_value_ID_index :integer range 0 to 20 := 0 ;
signal Si_Module_name_ID_asci_code  : integer range 0 to 127 := 0 ;        
signal Si_Module_io_ID_asci_code    : integer range 0 to 127 := 0 ; 
signal Si_Module_pin_ID_asci_code   : integer range 0 to 127 := 0 ; 
signal Si_Module_value_ID_asci_code : integer range 0 to 127 := 0 ; 



signal Si_str_Text_index       : integer range 0 to 15 := 0 ;
signal Si_str_Text_length      : integer range 0 to 15 := 0 ;

type char_asciT_array_t is array (natural range <>) of integer ;
type str_char_array_t is array (natural range <>) of char_asciT_array_t ;

constant C_Module_value_ID_crnt :char_asciT_array_t := ( 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 97, 98, 99, 100, 101, 102 ) ;--you input 4 bit as adress int o it  0 to 15
constant C_Module_name_ID_crnt  :str_char_array_t := ( (73, 77) , (82, 101, 103, 105, 115, 116, 101, 114) , (65, 76, 85) , (68, 77) );   --IM * Register * ALU * DM 
constant C_Module_io_ID_crnt    :str_char_array_t := ( (73, 78) , (79, 85, 84)  ) ;
constant C_Module_pin_ID_crnt   :str_char_array_t := ( 
--                                                        (99, 117, 114, 114, 101, 110, 116, 32, 80, 67) ,--current PC
--                                                        (79, 112, 101, 114, 97, 116, 105, 111, 110, 32, 67, 111, 100, 101) ,--opcode
--                                                        (70, 117, 110, 99, 116, 105, 111, 110, 32, 51) ,-- Function 3
--                                                        (70, 117, 110, 99, 116, 105, 111, 110, 32, 55) ,-- Function 7
--                                                        (82, 101, 103, 32, 115, 114, 99, 48, 32, 97, 100, 100, 114),--Reg src0 addr
--                                                        (82, 101, 103, 32, 115, 114, 99, 49, 32, 97, 100, 100, 114),--Reg src1 addr
--                                                        (82, 101, 103, 32, 100, 101, 115, 116, 32, 97, 100, 100, 114),--Reg dest addr
--                                                        (73, 109, 109, 101, 100, 105, 97, 116, 101), --Immediate
--                                                        (87, 114, 105, 116, 101, 32, 101, 110, 97, 98, 108, 101) , --Write enable
--                                                        (87, 114, 105, 116, 101, 32, 68, 97, 116, 97) ,--Write Data
--                                                        (82, 101, 103, 32, 115, 114, 99, 48, 32, 68, 97, 116, 97), --Reg src0 Data
--                                                        (82, 101, 103, 32, 115, 114, 99, 49, 32, 68, 97, 116, 97), --Reg src1 Data
--                                                        (65, 108, 117, 32, 111, 112, 99, 111, 100, 101),-- Alu opcode 
--                                                        (65, 76, 85, 32, 68, 97, 116, 97, 48),-- ALU Data0
--                                                        (65, 76, 85, 32, 68, 97, 116, 97, 49),-- ALU Data1
--                                                        (65, 76, 85, 32, 70, 108, 97, 103),-- ALU Flag
--                                                        (65, 76, 85, 32, 68, 97, 116, 97, 32, 111, 117, 116),-- ALU Data out
                                                        (112, 105, 110, 48), --pin0   
                                                        (112, 105, 110, 49), --pin1   
                                                        (112, 105, 110, 50), --pin2   
                                                        (112, 105, 110, 51), --pin3  
                                                        (112, 111, 117, 116, 48), --pout0
                                                        (112, 111, 117, 116, 49), --pout1  
                                                        (112, 111, 117, 116, 50), --pout2  
                                                        (112, 111, 117, 116, 51)  --pout2
                                                        
                                                        
                                                         );
                   

type text_line_fsm_state_t is (
        S_IDLE,--according to mode value 
        
        S_L0_SET_LENGTH , 
        S_L0_SEND_ASCI, 
        S_L0_GET_PIXEL, 
        S_L0_WAIT ,        
        S_L1_SET_LENGTH , 
        S_L1_SEND_ASCI, 
        S_L1_GET_PIXEL, 
        S_L1_WAIT ,  
              
        S_L2_SET_LENGTH , 
        S_L2_SEND_ASCI, 
        S_L2_GET_PIXEL, 
        S_L2_WAIT ,        
        S_L3_SET_LENGTH , 
        S_L3_SEND_ASCI, 
        S_L3_GET_PIXEL, 
        S_L3_WAIT ,

        S_L4_SET_LENGTH , 
        S_L4_SEND_ASCI, 
        S_L4_GET_PIXEL, 
        S_L4_WAIT ,        
        S_L5_SET_LENGTH , 
        S_L5_SEND_ASCI, 
        S_L5_GET_PIXEL, 
        S_L5_WAIT ,
        
        S_L6_SET_LENGTH , 
        S_L6_SEND_ASCI, 
        S_L6_GET_PIXEL, 
        S_L6_WAIT ,        
        S_L7_SET_LENGTH , 
        S_L7_SEND_ASCI, 
        S_L7_GET_PIXEL, 
        S_L7_WAIT ,
        
        
        
        S_ALL_DONE
    );
signal Text_State : text_line_fsm_state_t := S_IDLE ;


signal Si_update_line0 : std_logic := '0';-- name of module 
signal Si_update_line1 : std_logic := '0';
signal Si_update_line2 : std_logic := '0';-- in or out 
signal Si_update_line3 : std_logic := '0';
signal Si_update_line4 : std_logic := '0';-- name of pin
signal Si_update_line5 : std_logic := '0';
signal Si_update_line6 : std_logic := '0';-- value of pin
signal Si_update_line7 : std_logic := '0';
                             
begin


--Si_str_Text_index <= to_integer(unsigned( str_Text_index )) ; if out side control will be implemented 
str_Text_length <= std_logic_vector ( to_unsigned( Si_str_Text_length  , str_Text_length'length )) ;

p08_char2pix_mdl : entity work.p08_char2pix
    Port Map ( 
    
    clk       =>  clk        ,
    ena_text  =>  ena_text   ,
    reset_n   =>  reset_n    ,
    
    --str_Text_index :  in  std_logic_vector( 3 downto 0) := "0000"  ;--if every char is 8x8 then 16 char will fill the line
    str_char_index   =>  str_char_index ,
    str_char_in_asciTable   =>  Si_str_char_in_asciTable , -- every char first index is length
    
      pix_in_byte => str_inbyte ,
      str_char_length => str_char_length , --in case of We implement in different size for char (3x8 or 6x8).
      
      error_str => error_str(0)  
    );


---to do do some thinng

process (clk ) begin   

    if rising_edge(clk) then
    if (reset_n = '1') then 
    
    else --if (ena_text = '1' )  then 
    
        case ( Text_State ) is
            when  S_IDLE => 
                if ( ena_text = '1'  ) then
                    Text_State <= S_  update length  of line text  ;
                end if ;
                
            when S_  update length  of line text 
                Text_State <= S_L0_SET_LENGTH ;
            when  S_L0_SET_LENGTH => 
                Si_str_Text_length <= C_Module_name_ID_crnt(Si_Module_name_ID_index)'length ;
                
                

  
  
        S_L0_SEND_ASCI, 
        S_L0_GET_PIXEL, 
        S_L0_WAIT , 
     
    
    end if ;



        case (str_Line_number) is
            when "000" =>
                current_text <= Module_name_ID_crnt  ;---made of array 
            when "010" =>
                current_text <= Si_Module_io_ID_crnt    ;
            when "100" =>
                current_text <= Module_pin_ID_crnt   ;
            when "110" =>
                current_text <= Module_value_ID_crnt ;
        end case ;
end process ;
















end Behavioral;
