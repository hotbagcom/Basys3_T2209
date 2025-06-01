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
use IEEE.NUMERIC_STD.ALL;

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
    
    Module_name_ID  : in std_logic_vector(7 downto 0) := X"00";
    Module_io_ID    : in std_logic := '0' ;
    Module_pin_ID   : in std_logic_vector(7 downto 0) := X"00";
    Module_value_ID : in std_logic_vector(31 downto 0) := X"00abcd00";
            
            
      start_i2c_transaction  : out  std_logic := '0';            
      i2c_byte1              : out std_logic_vector(7 downto 0);
      i2c_byte2              : out std_logic_vector(7 downto 0);
    --i2c_transaction_done   : in std_logic;                   
    i2c_transaction_ack_err: in std_logic;   


    tribe_pre_busy   :  in std_logic := '0';   
    tribe_pre_done   :  in std_logic := '0';   
    tribe_pre_error  :  in std_logic := '0';
    
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

signal Si_init_i2c_tx_req_4pre_post :   std_logic := '1';
signal Si_init_i2c_tx_req_4pre     :   std_logic := '0';-- to hand shake with pre  this req comes from both init type    
signal Si_init_i2c_tx_data1_4pre    :   std_logic_vector(7 downto 0) := x"00" ; -- init command to MBA               
signal Si_init_i2c_tx_data2_4pre    :   std_logic_vector(7 downto 0) := x"00" ; -- init command to MBA                    
--signal Si_init_i2c_tx_avail_4init  :   std_logic := '0'; -- tribe gets permision from preudo to send data to MBA         
                                   
signal Si_init_init_mode           :  std_logic_vector(3 downto 0) := "0000" ;                                           
signal Si_init_page_number         :  std_logic_vector(2 downto 0) := "000" ;                                            
signal Si_init_colum_number        :  std_logic_vector(7 downto 0) := x"00" ;                                            





--signal for p09_str2char
signal Si_str_rst       : std_logic := '0' ;
signal Si_str_ena       : std_logic := '0' ;
signal Si_str_activate  : std_logic := '0' ;
signal Si_str_busy      : std_logic := '0' ;
signal Si_str_done      : std_logic := '0' ;
signal Si_str_error     : std_logic := '0' ;

signal Si_str_txt_i2c_tx_req_4pre_post :   std_logic := '1';
signal   Si_str_txt_i2c_tx_req_4pre            : std_logic := '0';-- to hand shake with pre  this req comes from bitmap     
signal   Si_str_txt_i2c_tx_data1_4pre          : std_logic_vector(7 downto 0) := x"00" ; -- w/r                  
signal   Si_str_txt_i2c_tx_data2_4pre          : std_logic_vector(7 downto 0) := x"00" ; -- bit map to byte   
                                              
signal  Si_str_str_mode_change_req_4init       : std_logic := '0'; -- to hand shake with pre                                
signal  Si_str_init_mode                       : std_logic_vector(3 downto 0) := "0000" ;                                   
signal  Si_str_page_number                     : std_logic_vector(2 downto 0) := "000" ;                                    
signal  Si_str_colum_number                    : std_logic_vector(7 downto 0) := x"00" ;                                    
signal  Si_str_str_mode_change_req_4init_done  : std_logic := '0'; --if this is 1 then you can print one page strings        

                                                                                   
                                                                                                     

type state_t is (
        St_IDLE,                --  ther wil be jod definition update     tribe  activeted then  Si_init_ena   = 1  = Si_init_activate  ST_TRIBE = St_SEND
        St_CHECK ,               --  ther wil be jod definition update 
        St_WAIT ,               --  ther wil be jod definition update     if tribe_pre_busy = 0  then          ST_TRIBE = St_CHECK_Init 
        
        
        St_CHECK_Init,          --   if tribe_pre_busy = 0  if MInitactv = 0 then ST_TRIBE = St_SET_CInit else ST_TRIBE = St_SET_MInit
        St_SET_CInit ,          --  index = 0 , Si_init_busy = 1 ,  tribe_busy = 1  ST_TRIBE = St_SEND_CInit
        St_SEND_CInit ,         --  send command(index) ,   ST_TRIBE = St_WAIT_CInit .
        St_WAIT_CInit ,         --  if index < length (if tribe_pre_done = 1 then  ST_TRIBE = St_SEND_CInit INCindex) else  ST_TRIBE = St_DONE_Init
        St_DONE_Init ,         --  set init_busy = 0 , init_done = 1 , MInitactv = 1 , ST_TRIBE = St_CHECK_STR
        
        St_CHECK_STR ,          --   if tribe_pre_busy = 0 then Si_str_activate = 1 , ST_TRIBE = St_SET_STR
        St_SET_STR ,            --   update |RV_modl_mane , RV_mdl_io , RV_modl_pin  , RV_modl_value | pageindex = 0 str_index = 0  , ST_TRIBE = St_UPDT_STR
        St_UPDT_STR ,           --  Si_init_activate = 1, if init_done = 1  then  ST_TRIBE = St_SEND_STR  
            St_SET_MInit ,      --  set index = 0  , Si_init_busy = 1 , ST_TRIBE = St_SEND_MInit
            St_SEND_MInit ,     --  send command(index) ,   ST_TRIBE = St_WAIT_MInit
            St_WAIT_MInit ,     -- if index < length (if tribe_pre_done = 1 then  ST_TRIBE = St_SEND_MInit INCindex) else  ST_TRIBE = St_DONE_Init
             
       
        St_SEND_STR ,           --   if page index = 0 , 2 , 4 , 6 then update currentlinestring and str_linelimit and update currentchar  and activateBmap = 1 ,    ST_TRIBE = St_WAIT_STR  
                                  
            
        St_WAIT_STR,            -- if BMap_done = 1 then activateBmap = 0 and (if strindx < currentlinestring then INCstrindex  else ( if pageindex < str_linelimit then INCpageindex and str_index = 0 and  ST_TRIBE = St_UPDT_STR else ST_TRIBE = St_DONE_STR ) )
            St_CHECK_BMAP,      ---  if bmap_activate = '1' then take currentchar number and find char in ascii table  and   ST_TRIBE = St_SET_BMAP
            St_SET_BMAP ,       ---  set index= 0 and busy = 1 and done = 0  and ST_TRIBE = St_SEND_BMAP                                                     
            St_SEND_BMAP ,      ---   bitmap(index) ,   ST_TRIBE = St_WAIT_BMAP         
            St_WAIT_BMAP ,      --- if index<lengthofbmap then ( if tribe_pre_done = 1 then  INCBmapindex and ST_TRIBE = St_SEND_BMAP    ) elsif index<lengthofbmap then     else error = 1                        
            St_DONE_BMAP ,      --- set bmap_busy = 0 , bmap_done = 1 , ST_TRIBE = St_SEND_STR                              
            
        
        St_DONE_STR,            --  Si_str_busy = 0 , Si_str_done = 1 , ST_TRIBE = St_DONE  
            
        
        
        
        St_DONE                 --- set tribe_busy  = 0 , tribe_done = 1 ,  Si_str_activate = 0 and  if (ext_triger =1 )  then ST_TRIBE = St_CHECK_STR

        
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
          i2c_tx_byte1_4pre       =>    Si_init_i2c_tx_data1_4pre   ,
          i2c_tx_byte2_4pre       =>    Si_init_i2c_tx_data2_4pre   ,  -- init command to MBA                 
       -- i2c_tx_avail_4init      =>    Si_init_i2c_tx_avail_4init ,   -- tribe gets permision from preudo to send data to MBA       
                                                                                                                             
        init_mode                =>    Si_init_init_mode          ,                                             
        page_number              =>    Si_init_page_number        ,                                             
        colum_number             =>    Si_init_colum_number       ,                                             
        
        tribe_pre_busy    => tribe_pre_busy  ,   
        tribe_pre_done    => tribe_pre_done  ,  
        tribe_pre_error   => tribe_pre_error ,
        
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
        
        Module_name_ID   => Module_name_ID   ,
        Module_io_ID     => Module_io_ID     ,
        Module_pin_ID    => Module_pin_ID    ,
        Module_value_ID  => Module_value_ID  ,
        
         --for bittmap
          i2c_tx_req_4pre          =>   Si_str_txt_i2c_tx_req_4pre     , --: out std_logic := '0';-- to hand shake with pre  this req comes from bitmap  
          i2c_tx_byte1_4pre       =>    Si_str_txt_i2c_tx_data1_4pre   ,
          i2c_tx_byte2_4pre       =>    Si_str_txt_i2c_tx_data2_4pre   ,  --: out std_logic_vector(7 downto 0) := x"00" ; -- bit map to byte              
        --txt_i2c_tx_avail_4bitmap       =>  Si_str_txt_i2c_tx_avail_4bitmap      ,   --: in std_logic := '0'; -- tribe gets permision from preudo to send data to MBA
                                                                               
        --for chane active page number =>  Si_strfor chane active page number  , --
          str_mode_change_req_4init    =>  Si_str_str_mode_change_req_4init     , --: out std_logic := '0'; -- to hand shake with pre   
          init_mode                    =>  Si_str_init_mode                     , --: out std_logic_vector(4 downto 0) := "0000" ;  
          page_number                  =>  Si_str_page_number                   , --: out std_logic_vector(2 downto 0) := "000" ;
          colum_number                 =>  Si_str_colum_number                  , --: out std_logic_vector(7 downto 0) := x"00" ;
        str_mode_change_req_4init_done =>  Si_str_str_mode_change_req_4init_done, --: in std_logic := '0'; --if this is 1 then you can print one page strings 
      
        tribe_pre_busy    => tribe_pre_busy  ,   
        tribe_pre_done    => tribe_pre_done  ,  
        tribe_pre_error   => tribe_pre_error ,
      
        
        
          str_busy        =>  Si_str_busy      ,
          str_done        =>  Si_str_done      ,
          str_error       =>  Si_str_error     
     
    );

process  (clk ,  Si_init_i2c_tx_req_4pre , Si_str_txt_i2c_tx_req_4pre) begin

if  falling_edge(clk)  then
    Si_init_i2c_tx_req_4pre_post <= Si_init_i2c_tx_req_4pre ;
    Si_str_txt_i2c_tx_req_4pre_post <=  Si_str_txt_i2c_tx_req_4pre ;
    
    if (Si_init_i2c_tx_req_4pre_post = '0' and Si_init_i2c_tx_req_4pre ='1' ) then
        i2c_byte1   <= Si_init_i2c_tx_data1_4pre ;
        i2c_byte2   <= Si_init_i2c_tx_data2_4pre ;
    elsif (Si_str_txt_i2c_tx_req_4pre_post = '0' and Si_str_txt_i2c_tx_req_4pre  ='1'  ) then
        i2c_byte1   <= Si_str_txt_i2c_tx_data1_4pre;
        i2c_byte2   <= Si_str_txt_i2c_tx_data2_4pre;
    end if ;
end if ;
end process ;



process (clk) begin 
    if rising_edge(clk) and (tribe_ena = '1') then 
        if (tribe_rst = '1') then
        
        else 
            case ( ST_TRIBE ) is 
                 
           
                  
                 
                                      
                when  St_IDLE               =>   --   if tribe  activeted then  Si_init_ena   = 1  = Si_init_activate  ST_TRIBE = St_WAIT   
                    if (tribe_activate = '1') then
                       
                       Si_init_ena  <= '1' ;
                       Si_str_ena   <= '1' ;
                       ST_TRIBE <= St_SET_CInit ;
                    
                    end if ;  
                                  
        --        when    St_CHECK             =>    -- if tribe_pre_busy = 0 then Si_init_activate <= '1'   and     ST_TRIBE <= St_WAIT 
                     
                    
                                     
        --        when    St_WAIT             => -- if Si_str_done = 1 , ST_TRIBE = St_DONE         >>>>>>this lead to>>>>>>>>>>>>     ST_TRIBE = St_CHECK_Init
                   
                  
                    
                    
                    
                                            
             --   when    St_CHECK_Init       =>   --   if tribe_pre_busy = 0  if MInitactv = 0 then ST_TRIBE = St_SET_CInit else ST_TRIBE = St_SET_MInit
                when    St_SET_CInit        =>   --  index = 0 , Si_init_busy = 1 ,  tribe_busy = 1  ST_TRIBE = St_SEND_CInit
                    if (tribe_pre_busy = '0') then                            
                        if (Si_str_init_mode = "0001") then
                            ST_TRIBE <= St_CHECK_STR ;
                        else    
                            Si_init_activate <= '1' ; 
                            ST_TRIBE <= St_WAIT_CInit ;
                        end if ;
                     end if ;
                
                
       --         when    St_SEND_CInit       =>   --  send command(index) ,   ST_TRIBE = St_WAIT_CInit .
                when    St_WAIT_CInit       =>   --  if index < length (if tribe_pre_done = 1 then  ST_TRIBE = St_SEND_CInit INCindex) else  ST_TRIBE = St_DONE_Init
                    if (Si_init_done = '1')then
                        Si_init_activate <= '0' ;
                        ST_TRIBE <= St_CHECK_STR ;
                        
                    end if ;
                
                when    St_DONE_Init        =>   --  set init_busy = 0 , init_done = 1 , MInitactv = 1 , ST_TRIBE = St_CHECK_STR
                
                
                
                
                
                
                when    St_CHECK_STR        =>   --   if tribe_pre_busy = 0 then Si_str_activate = 1 , ST_TRIBE = St_SET_STR
                    if (tribe_pre_busy = '0') then   
                        Si_str_activate <= '1' ;  
                        Si_str_str_mode_change_req_4init_done  <= '0' ;
                        ST_TRIBE <= St_UPDT_STR ;
                     end if ;
                
                when    St_SET_STR          =>   --   update |RV_modl_mane , RV_mdl_io , RV_modl_pin  , RV_modl_value | pageindex = 0 str_index = 0  , ST_TRIBE = St_UPDT_STR
                when    St_UPDT_STR         =>   --  Si_init_activate = 1, if init_done = 1  then  ST_TRIBE = St_SEND_STR  
                    if (( Si_str_str_mode_change_req_4init = '1') and  (Si_str_page_number = "110" )) then
                        Si_init_activate <= '1' ;
                        ST_TRIBE <= St_SET_MInit ;
                    elsif (Si_init_busy = '0') and ( Si_str_str_mode_change_req_4init = '1') then
                        Si_init_activate <= '1' ;
                        ST_TRIBE <= St_WAIT_MInit ;
                    end if ;
                
                when        St_SET_MInit    =>   --  set index = 0  , Si_init_busy = 1 , ST_TRIBE = St_SEND_MInit
                    if (Si_init_done = '1') then
                        Si_str_str_mode_change_req_4init_done <= '1';
                        ST_TRIBE <= St_SEND_MInit ;
                    end if ;
                when        St_SEND_MInit   =>   --  send command(index) ,   ST_TRIBE = St_WAIT_MInit
                    if ( Si_str_str_mode_change_req_4init = '0') then
                        Si_str_str_mode_change_req_4init_done <= '0';
                        
                        ST_TRIBE <= St_WAIT_STR ;
                    end if ; 
                    
                
                when        St_WAIT_MInit   =>   -- if index < length (if tribe_pre_done = 1 then  ST_TRIBE = St_SEND_MInit INCindex) else  ST_TRIBE = St_DONE_Init
                    if (Si_init_done = '1') then
                        Si_str_str_mode_change_req_4init_done <= '1';
                        ST_TRIBE <= St_SEND_STR ;
                    end if ;
                 
                when    St_SEND_STR         =>   --   if page index = 0 , 2 , 4 , 6 then update currentlinestring and str_linelimit and update currentchar  and activateBmap = 1 ,    ST_TRIBE = St_WAIT_STR  
                    if ( Si_str_str_mode_change_req_4init = '0') then
                        Si_str_str_mode_change_req_4init_done <= '0';
                        
                        ST_TRIBE <= St_UPDT_STR ;
                    end if ;                            
                                          
                when    St_WAIT_STR         =>   -- if BMap_done = 1 then activateBmap = 0 and (if strindx < currentlinestring then INCstrindex  else ( if pageindex < str_linelimit then INCpageindex and str_index = 0 and  ST_TRIBE = St_UPDT_STR else ST_TRIBE = St_DONE_STR ) )
                    if (Si_str_done = '1' ) then
                        Si_str_activate <= '0' ;
                    end if ;
                        
                when        St_CHECK_BMAP   =>   ---  if bmap_activate = '1' then take currentchar number and find char in ascii table  and   ST_TRIBE = St_SET_BMAP
                when        St_SET_BMAP     =>   ---  set index= 0 and busy = 1 and done = 0  and ST_TRIBE = St_SEND_BMAP                                                     
                when        St_SEND_BMAP    =>   ---   bitmap(index) ,   ST_TRIBE = St_WAIT_BMAP         
                when        St_WAIT_BMAP    =>   --- if index<lengthofbmap then ( if tribe_pre_done = 1 then  INCBmapindex and ST_TRIBE = St_SEND_BMAP    ) elsif index<lengthofbmap then     else error = 1                        
                when        St_DONE_BMAP    =>   --- set bmap_busy = 0 , bmap_done = 1 , ST_TRIBE = St_SEND_STR                              
                
                
                when    St_DONE_STR         =>   --  Si_str_busy = 0 , Si_str_done = 1 , ST_TRIBE = St_DONE  
                
                
                when  St_DONE               =>   -- set tribe_busy  = 0 , tribe_done = 1 ,  Si_str_activate = 0 and  if (ext_triger =1 )  then ST_TRIBE = St_CHECK_STR
                    tribe_busy  <= '0';
                    tribe_done  <= '1';
                    if (tribe_activate = '0') then
                       ST_TRIBE <= St_IDLE ;  
                   end if ;   
                                                    
                                                    
            end case ; 
        end if ;
    end if ;
end process ;






end Behavioral;
