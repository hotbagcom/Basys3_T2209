----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2025 17:18:33
-- Design Name: 
-- Module Name: p09_str2char - Behavioral
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

entity p09_str2char is
    Port (
    
    
    clk            : in std_logic  := '0';
    str_rst        : in std_logic := '0';
    str_ena        : in std_logic := '0'; -- emergency control (shut down)
    str_activate   : in std_logic := '0'; -- shock therapy 
    
    
    --for bittmap
      txt_i2c_tx_req_4pre       : out std_logic := '0';-- to hand shake with pre  this req comes from bitmap  
      txt_i2c_tx_data_4pre      : out std_logic_vector(7 downto 0) := x"00" ; -- bit map to byte              
    txt_i2c_tx_avail_4bitmap    : in std_logic := '0'; -- tribe gets permision from preudo to send data to MBA
    
    --for chane active page number
      str_mode_change_req_4init : out std_logic := '0'; -- to hand shake with pre   
      init_mode     : out std_logic_vector(4 downto 0) := "0000" ;  
      page_number   : out std_logic_vector(2 downto 0) := "000" ;
      colum_number  : out std_logic_vector(7 downto 0) := x"00" ;
    str_mode_change_req_4init_done : in std_logic := '0'; --if this is 1 then you can print one page strings 
      
      
      
    --if all screen updated set busy to 0 and done to 1 , after this opperation on next clk this module will be deactivated 
      str_busy     :  out std_logic := '0';
      str_done     :  out std_logic := '0';
      str_error    :  out std_logic := '0'
      
      
      );
end p09_str2char;

architecture Behavioral of p09_str2char is


--signal for p09_char2bmap
signal Si_bmap_rst       : std_logic := '0' ;
signal Si_bmap_ena       : std_logic := '0' ;
signal Si_bmap_activate  : std_logic := '0' ;
signal Si_bmap_busy      : std_logic := '0' ;
signal Si_bmap_done      : std_logic := '0' ;
signal Si_bmap_error     : std_logic := '0' ;


type state_t is (                   -- this command tor one abovemodule update this comment --TO DO --                                          
        St_IDLE,                -- tribe  activeted then  init_ena   = 1 = str_ena 
       
        St_TRIGER_STR,         --    if this module activated   inside this module update all switches and do not change onother activation 
        St_SET_STR,             --   if Si_str_str_mode_change_req_4init = 1 set Si_init_activate  1 and it will get mode_init page and colum number from str module .        
            St_TRIGER_MInit,   --  if busy  1 and done  0  then  set ST_TRIBE = St_SET_MInit
            St_SET_MInit ,      --  if Si_init_i2c_tx_req_4pre = 1 and i2c_transaction_active = 1 then  send start_i2c_transaction =  1 
            St_SEND_MInit ,     -- if i2c_transaction_done then set 
            St_WAIT_MInit ,     -- 
            St_DONE_MInit ,     -- set Si_str_str_mode_change_req_4init_done = 1  and go to St_send_str inside strmodule
            
        St_SEND_STR ,           -- for specified page number activate bmap and send a char            
            St_TRIGER_BMAP,    ---   if bmap_activate = '1' then take number and find char in ascii table and set busy 1 and done to 0        probably this part will be take care of str module 
            St_SET_BMAP ,       ---  check if  i2c_transaction_done = 1  than set this  to                                                             
            St_SEND_BMAP ,      --- if  Si_str_txt_i2c_tx_req_4pre = 1 then set  St_WAIT_BMAP else if  Si_str_done = 1   then   send new byte of bitmap          
            St_WAIT_BMAP ,      --- if  i2c_transaction_done = 1 then  increase  index number and set   Si_str_txt_i2c_tx_avail_4bitmap  = 1   set to     St_SEND_BMAP                               
            St_DONE_BMAP ,      --- this is means index equal to wdth of bit map . set done bitmap to 1 and                                 
            
        St_WAIT_STR,            --  chage page --actually str may outomatically 
        St_DONE_STR,            --  if all paga/screen updated set done 1 and busy 0  (becaouse of this pseudo will deactivate this module ) set ST_TRIBE = St_DONE
            
        
        
        St_DONE                 --- if this module deactivated becaouse of screen updated once  activated make done 1 busy 0 nd if avtiveted again sent ST_tribe to St_TRIGER_STR
        
    );
signal ST_STR  : state_t := St_IDLE;

begin





p09_char2bmap_mdl : entity work.p09_char2bmap
    Port MAP(
        clk       =>    clk     ,  
        
        bmap_rst         =>  Si_bmap_rst      , 
        bmap_ena         =>  Si_bmap_ena      , 
        bmap_activate    =>  Si_bmap_activate , 
        
          txt_i2c_tx_req_4pre   => txt_i2c_tx_req_4pre  ,
          txt_i2c_tx_data_4pre  => txt_i2c_tx_data_4pre ,
        
          bmap_busy      =>  Si_bmap_busy     , 
          bmap_done      =>  Si_bmap_done     , 
          bmap_error     =>  Si_bmap_error    

     
    );






process (clk) begin 
    if rising_edge(clk) and (str_ena = '1') then 
        if (str_rst = '1') then
        
        else 
        
        
        


        end if ;
    end if ;
end process ;










end Behavioral;
