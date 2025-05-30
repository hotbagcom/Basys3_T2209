----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2025 17:18:33
-- Design Name: 
-- Module Name: p09_char2bmap - Behavioral
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

entity p09_char2bmap is
    Port ( 
    
    clk : in std_logic  := '0';
    bmap_rst        : in std_logic := '0';
    bmap_ena        : in std_logic := '0';
    bmap_activate   :  in std_logic := '0';
    
    
    
    
        
      txt_i2c_tx_req_4pre       : out std_logic := '0';-- to hand shake with pre  this req comes from bitmap  
      txt_i2c_tx_data_4pre      : out std_logic_vector(7 downto 0) := x"00" ; -- bit map to byte              
    txt_i2c_tx_avail_4bitmap    : in std_logic := '0'; -- tribe gets permision from preudo to send data to MBA
    
      bmap_busy     :  out std_logic := '0';
      bmap_done     :  out std_logic := '0';
      bmap_error    :  out std_logic := '0'
      
    );
end p09_char2bmap;

architecture Behavioral of p09_char2bmap is




type state_t is (                  -- this command tor one abovemodule update this comment --TO DO --
        St_IDLE,                -- tribe  activeted then  init_ena   = 1 = str_ena 
       
            St_TRIGER_BMAP,    ---   if bmap_activate = '1' then take number and find char in ascii table and set busy 1 and done to 0        probably this part will be take care of str module 
            St_SET_BMAP ,       ---  check if  i2c_transaction_done = 1  than set this  to                                                             
            St_SEND_BMAP ,      --- if  i2c_transaction_done = 1 *Si_str_txt_i2c_tx_avail_4bitmap = 1    *text içindedaha faydalý* and   index number  less than length of that character bit map width   then   send new byte of bitmap          
            St_WAIT_BMAP ,      --- if  i2c_transaction_done = 1 then  increase  index number and set   Si_str_txt_i2c_tx_avail_4bitmap  = 1   set to     St_SEND_BMAP                               
            St_DONE_BMAP ,      --- this is means index equal to wdth of bit map . set done bitmap to 1 and                                 
            
            St_DONE                 --- if this module deactivated becaouse of screen updated once  activated make done 1 busy 0 nd if avtiveted again sent ST_tribe to St_TRIGER_STR
        
    );
signal ST_BMAP  : state_t := St_IDLE;







begin








process (clk) begin 
    if rising_edge(clk) and (bmap_ena = '1') then 
        if (bmap_rst = '1') then
        
        else 
        
        
        


        end if ;
    end if ;
end process ;











end Behavioral;
