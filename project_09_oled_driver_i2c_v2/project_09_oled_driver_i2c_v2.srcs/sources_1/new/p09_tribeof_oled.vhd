----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2025 17:18:33
-- Design Name: 
-- Module Name: p09_tribeof_oled - Behavioral
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

entity p09_tribeof_oled is
    Port ( 
    
    clk         : in std_logic  := '0';
    tribe_rst       : in std_logic := '0';
    tribe_ena       : in std_logic := '0';
    tribe_activate  :  in std_logic := '0';
    
         
    i2c_transaction_active : in  std_logic; -- enable controls transaction if module open transaction active
      start_i2c_transaction  : out  std_logic := '0';            
      i2c_byte1              : out std_logic_vector(7 downto 0);
      i2c_byte2              : out std_logic_vector(7 downto 0);
    i2c_transaction_done   : in std_logic;                   
    i2c_transaction_ack_err: in std_logic;   
    
    
    
    
    
    
      tribe_busy    :  out std_logic := '0';
      tribe_done    :  out std_logic := '0';
      tribe_error   :  out std_logic := '0'
    
    );
end p09_tribeof_oled;

architecture Behavioral of p09_tribeof_oled is


--signal for p09_init
signal Si_init_rst       : std_logic := '0' ;
signal Si_init_ena       : std_logic := '0' ;
signal Si_init_activate  : std_logic := '0' ;
signal Si_init_busy      : std_logic := '0' ;
signal Si_init_done      : std_logic := '0' ;
signal Si_init_error     : std_logic := '0' ;

signal Si_init_i2c_tx_req_4pre     :   std_logic := '0';-- to hand shake with pre  this req comes from both init type    
signal Si_init_i2c_tx_data_4pre    :   std_logic_vector(7 downto 0) := x"00" ; -- init command to MBA                    
signal Si_init_i2c_tx_avail_4init  :   std_logic := '0'; -- tribe gets permision from preudo to send data to MBA         
                                   
signal Si_init_init_mode           :  std_logic_vector(4 downto 0) := "0000" ;                                           
signal Si_init_page_number         :  std_logic_vector(2 downto 0) := "000" ;                                            
signal Si_init_colum_number        :  std_logic_vector(7 downto 0) := x"00" ;                                            





--signal for p09_str2char
signal Si_str_rst       : std_logic := '0' ;
signal Si_str_ena       : std_logic := '0' ;
signal Si_str_activate  : std_logic := '0' ;
signal Si_str_busy      : std_logic := '0' ;
signal Si_str_done      : std_logic := '0' ;
signal Si_str_error     : std_logic := '0' ;

signal  Si_str_txt_i2c_tx_req_4pre             : std_logic := '0';-- to hand shake with pre  this req comes from bitmap     
signal  Si_str_txt_i2c_tx_data_4pre            : std_logic_vector(7 downto 0) := x"00" ; -- bit map to byte                 
signal  Si_str_txt_i2c_tx_avail_4bitmap        :  std_logic := '0'; -- tribe gets permision from preudo to send data to MBA 
                                              
signal  Si_str_str_mode_change_req_4init       : std_logic := '0'; -- to hand shake with pre                                
signal  Si_str_init_mode                       : std_logic_vector(4 downto 0) := "0000" ;                                   
signal  Si_str_page_number                     : std_logic_vector(2 downto 0) := "000" ;                                    
signal  Si_str_colum_number                    : std_logic_vector(7 downto 0) := x"00" ;                                    
signal  Si_str_str_mode_change_req_4init_done  : std_logic := '0'; --if this is 1 then you can print one page strings        












type state_t is (
        St_IDLE,                -- tribe  activeted then  init_ena   = 1 = str_ena 
       
        St_TRIGER_CInit,       --   set mod to X"0" and set page and colume to 0<= others ,
        St_SET_CInit ,          --  if transaction possible activate init modul
        St_SEND_CInit ,         -- *?(not sur to use this state on tribe)* implement all clasical Init procedure*   send each command or whatever 2 pre mdl (pre mdl ready to transmission)
        St_WAIT_CInit ,         --   wait until done = 1 and busy = 0 and set ST_TRIBE = St_DONE_CInit
        St_DONE_CInit ,         --    deactivate module (keep enable) and set ST_TRIBE = St_TRIGER_STR activate str module 
        
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
signal ST_TRIBE  : state_t := St_IDLE;


begin






p09_init_mdl : entity work.p09_init
    Port MAP(
        clk       =>    clk       ,
        
        init_rst         =>    Si_init_rst      ,
        init_ena         =>    Si_init_ena      , 
        init_activate    =>    Si_init_activate ,
        
        
          i2c_tx_req_4pre       =>    Si_init_i2c_tx_req_4pre    ,  -- to hand shake with pre  this req comes from both init type 
          i2c_tx_data_4pre      =>    Si_init_i2c_tx_data_4pre   ,  -- init command to MBA                 
        i2c_tx_avail_4init      =>    Si_init_i2c_tx_avail_4init ,   -- tribe gets permision from preudo to send data to MBA       
                                                                                                                             
        init_mode                =>    Si_init_init_mode          ,                                             
        page_number              =>    Si_init_page_number        ,                                             
        colum_number             =>    Si_init_colum_number       ,                                             
        
        
        
          init_busy      =>    Si_init_busy     ,
          init_done      =>    Si_init_done     ,
          init_error     =>    Si_init_error    
     
    );



p09_str2char_mdl : entity work.p09_str2char
    Port MAP(
        clk       =>    clk       ,
        
        str_rst           =>  Si_str_rst       ,
        str_ena           =>  Si_str_ena       ,
        str_activate      =>  Si_str_activate  ,
        
         --for bittmap
          txt_i2c_tx_req_4pre          =>  Si_str_txt_i2c_tx_req_4pre           , --: out std_logic := '0';-- to hand shake with pre  this req comes from bitmap  
          txt_i2c_tx_data_4pre         =>  Si_str_txt_i2c_tx_data_4pre          , --: out std_logic_vector(7 downto 0) := x"00" ; -- bit map to byte              
        txt_i2c_tx_avail_4bitmap       =>  Si_str_txt_i2c_tx_avail_4bitmap      ,   --: in std_logic := '0'; -- tribe gets permision from preudo to send data to MBA
                                                                               
        --for chane active page number =>  Si_strfor chane active page number  , --
          str_mode_change_req_4init    =>  Si_str_str_mode_change_req_4init     , --: out std_logic := '0'; -- to hand shake with pre   
          init_mode                    =>  Si_str_init_mode                     , --: out std_logic_vector(4 downto 0) := "0000" ;  
          page_number                  =>  Si_str_page_number                   , --: out std_logic_vector(2 downto 0) := "000" ;
          colum_number                 =>  Si_str_colum_number                  , --: out std_logic_vector(7 downto 0) := x"00" ;
        str_mode_change_req_4init_done =>  Si_str_str_mode_change_req_4init_done, --: in std_logic := '0'; --if this is 1 then you can print one page strings 
      
      
      
        
        
          str_busy        =>  Si_str_busy      ,
          str_done        =>  Si_str_done      ,
          str_error       =>  Si_str_error     
     
    );




process (clk) begin 
    if rising_edge(clk) and (tribe_ena = '1') then 
        if (tribe_rst = '1') then
        
        else 
            case ( ST_TRIBE ) is 
                 
                 when St_IDLE               =>
                    if (tribe_activate = '1') then
                        ST_TRIBE <= St_TRIGER_CInit ;
                        Si_init_ena  <= '1' ;
                        Si_str_ena   <= '1' ;
                    
                    end if ;
                 
                                      
                 when St_TRIGER_CInit      =>
                 
                 
                 when St_SET_CInit          =>
                 when St_SEND_CInit         =>
                 when St_WAIT_CInit         =>
                 when St_DONE_CInit         =>
                                       
                 when St_TRIGER_STR        =>
                 when St_SET_STR            =>
                 when     St_TRIGER_MInit  =>
                 when     St_SET_MInit      =>
                 when     St_SEND_MInit     =>
                 when     St_WAIT_MInit     =>
                 when     St_DONE_MInit     =>
                                        
                 when St_SEND_STR           =>
                 when     St_TRIGER_BMAP   =>
                 when     St_SET_BMAP       =>
                 when     St_SEND_BMAP      =>
                 when     St_WAIT_BMAP      =>
                 when     St_DONE_BMAP      =>
                                       
                 when St_WAIT_STR           =>
                 when St_DONE_STR           =>
                  
                  
                 when St_DONE                =>
                
                
                
                
        

            end case ;
        end if ;
    end if ;
end process ;






end Behavioral;
