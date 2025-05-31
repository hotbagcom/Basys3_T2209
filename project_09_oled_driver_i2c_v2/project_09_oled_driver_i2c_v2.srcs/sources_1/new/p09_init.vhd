----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2025 17:18:33
-- Design Name: 
-- Module Name: p09_init - Behavioral
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

entity p09_init is
    Port ( 
    
    clk : in std_logic  := '0';
    init_rst          : in std_logic := '0';
    init_ena          : in std_logic := '0';
    init_activate     : in std_logic := '0';
    
    
       i2c_tx_req_4pre       : out std_logic := '0';-- to hand shake with pre  this req comes from both init type   
       i2c_tx_data_4pre      : out std_logic_vector(7 downto 0) := x"00" ; -- init command to MBA             
    i2c_tx_avail_4init       : in std_logic := '0'; -- tribe gets permision from preudo to send data to MBA
    
    init_mode           : in std_logic_vector(4 downto 0) := "0000" ;  
    page_number         : in std_logic_vector(2 downto 0) := "000" ;
    colum_number        : in std_logic_vector(7 downto 0) := x"00" ; 
        
      init_busy       :  out std_logic := '0';
      init_done       :  out std_logic := '0';
      init_error      :  out std_logic := '0'
    );
end p09_init;

architecture Behavioral of p09_init is










type state_t is (                  -- this command tor one abovemodule update this comment --TO DO --
        St_IDLE,                -- if init_ena   = 1  then set ST_INIT = St_TRIGER_CInit
       
        St_TRIGER_CInit,       --   if init_activate = 1 then  set   set page / colom number and i2c_tx_req_4pre = 1  ST_INIT = St_SET_CInit 
        St_SET_CInit ,          --   set ST_INIT = St_SEND_CInit init_busy = 1  init_done = 0 
        St_SEND_CInit ,         --     send each command or whatever 2 pre mdl (pre mdl ready to transmission)  ST_INIT = St_WAIT_CInit 
        St_WAIT_CInit ,         --   if index < length then  ( if   i2c_tx_avail_4init = 1 then  set ST_INIT = St_SEND_CInit index increment    ) else ST_INIT = St_DONE_CInit 
        St_DONE_CInit ,         --    set ST_INIT = St_DONE  index = 0 
        
--        St_TRIGER_STR,         --    activate module  inside this module update all switches and do not change onother activation 
--        St_SET_STR,             --  set mode chane req to 1 and set mode to page from horizontal mode        
            St_TRIGER_MInit,   --  if init_activate = 1 then set  page / colom number i2c_tx_req_4pre = 1 ST_INIT = St_SET_MInit 
            St_SET_MInit  ,      -- ST_INIT = St_SEND_MInit set init_busy = 1  init_done = 0  set index = 0
            St_SEND_MInit ,     -- send command one by one  ST_INIT = St_WAIT_MInit   
            St_WAIT_MInit ,     -- if index < length then ( if   i2c_tx_avail_4init = 1 then  set ST_INIT = St_SEND_MInit  and index increment) else ST_INIT = St_DONE_MInit 
            St_DONE_MInit ,     -- set ST_INIT = St_DONE 
            
--        St_SEND_STR ,           -- for specified page number activate bmap and send a char            
--            St_TRIGER_BMAP,    ---   if bmap_activate = '1' then take number and find char in ascii table and set busy 1 and done to 0        probably this part will be take care of str module 
--            St_SET_BMAP ,       ---  check if pre tx is available than set this                                                             
--            St_SEND_BMAP ,      --- send new byte of bitmap if index number  less than length of that character bit map width               
--            St_WAIT_BMAP ,      --- wait until pre tx available if available increase  index number                                         
--            St_DONE_BMAP ,      --- this is means index equal to wdth of bit map . set done bitmap to 1 and                                 
            
--        St_WAIT_STR,            --  chage page --actually str may outomatically 
--        St_DONE_STR,            --  if all paga/screen updated go tu tribe done 
            
        
        
        
        St_DONE                 --- if this module deactivated becaouse of CSt_DONE_CInit make done 1 busy 0 and sent ST_INIT to St_TRIGER_MInit  
        
    );
signal ST_INIT  : state_t := St_IDLE;






begin



process (clk) begin 
    if rising_edge(clk) and (init_ena = '1') then 
        if (init_rst = '1') then
        
        else 
        
        case (state_t) is
        St_IDLE,             
                 
            St_TRIGER_CInit,     
            St_SET_CInit ,       
            St_SEND_CInit ,      
            St_WAIT_CInit ,      
            St_DONE_CInit ,      
                 
            St_TRIGER_STR,     
            St_SET_STR,        
            St_TRIGER_MInit, 
            St_SET_MInit  ,  
            St_SEND_MInit ,  
            St_WAIT_MInit ,  
            St_DONE_MInit ,  
          St_DONE        
            
       
        
                end case ;
        end if ;
    end if ;
end process ;


end Behavioral;
