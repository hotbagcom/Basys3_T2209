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
use IEEE.NUMERIC_STD.ALL;

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
    
    Module_name_ID  : in std_logic_vector(7 downto 0) := X"00";       
    Module_io_ID    : in std_logic := '0' ;                           
    Module_pin_ID   : in std_logic_vector(7 downto 0) := X"00";       
    Module_value_ID : in std_logic_vector(31 downto 0) := X"00abcd00";

    --for bittmap
       i2c_tx_req_4pre       : out std_logic := '0';-- to hand shake with pre  this req comes from bitmap  
       i2c_tx_byte1_4pre     : out std_logic_vector(7 downto 0) := x"00" ; -- command foe write  
       i2c_tx_byte2_4pre     : out std_logic_vector(7 downto 0) := x"00" ; -- bit map to byte              
    --txt_i2c_tx_avail_4bitmap    : in std_logic := '0'; -- tribe gets permision from preudo to send data to MBA    use pre_busy and pre-done 
    
    --for chane active page number
      str_mode_change_req_4init : out std_logic := '0'; -- to hand shake with pre  
      init_mode     : out std_logic_vector(3 downto 0) := "0000" ;  
      page_number   : out std_logic_vector(2 downto 0) := "000" ;
      colum_number  : out std_logic_vector(7 downto 0) := x"00" ;
    str_mode_change_req_4init_done : in std_logic := '0'; --if this is 1 then you can print one page strings 
      
    tribe_pre_busy   :  in std_logic := '0';   
    tribe_pre_done   :  in std_logic := '0';   
    tribe_pre_error  :  in std_logic := '0';
      
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
        St_CHECK_STR       ,  --   if tribe_pre_busy = 0 then Si_str_activate = 1 , ST_TRIBE = St_SET_STR                                                    
        St_SET_STR         ,  --   update |RV_modl_mane , RV_mdl_io , RV_modl_pin  , RV_modl_value | pageindex = 0 str_index = 0  , ST_TRIBE = St_UPDT_STR   
        St_UPDT_STR        ,  --  Si_init_activate = 1, if init_done = 1  then  ST_TRIBE = St_SEND_STR                                                       
            St_SET_MInit   ,  --  set index = 0  , Si_init_busy = 1 , ST_TRIBE = St_SEND_MInit                                                               
        --    St_SEND_MInit  ,  --  send command(index) ,   ST_TRIBE = St_WAIT_MInit                                                                           
            St_WAIT_MInit  ,  -- if index < length (if i2c_transaction_done = 1 then  ST_TRIBE = St_SEND_MInit INCindex) else  ST_TRIBE = St_DONE_Init       
                           
                           
        St_SEND_STR        ,--   if page index = 0 , 2 , 4 , 6 then update currentlinestring and str_linelimit and update currentchar  and activateBmap = 1 ,    ST_TRIBE = St_WAIT_STR                                                                                                                       
                           
                           
        St_WAIT_STR        ,-- if BMap_done = 1 then activateBmap = 0 and (if strindx < currentlinestring then INCstrindex  else ( if pageindex < str_linelimit then INCpageindex and str_index = 0 and  ST_TRIBE = St_UPDT_STR else ST_TRIBE = St_DONE_STR ) )                                               
   --       St_CHECK_BMAP  ,---  if bmap_activate = '1' then take currentchar number and find char in ascii table  and   ST_TRIBE = St_SET_BMAP                                                                                                                                                               
   --       St_SET_BMAP    ,---  set index= 0 and busy = 1 and done = 0  and ST_TRIBE = St_SEND_BMAP                                                                                                                                                                                                          
   --       St_SEND_BMAP   ,---   bitmap(index) ,   ST_TRIBE = St_WAIT_BMAP                                                                                                                                                                                                                                   
   --       St_WAIT_BMAP   ,--- if index<lengthofbmap then ( if i2c_transaction_done = 1 then  INCBmapindex and ST_TRIBE = St_SEND_BMAP    ) elsif index<lengthofbmap then     else error = 1                                                                                                                 
   --       St_DONE_BMAP   ,--- set bmap_busy = 0 , bmap_done = 1 , ST_TRIBE = St_SEND_STR                                                                                                                                                                                                                    
                           
                         
       St_DONE_STR         --  Si_str_busy = 0 , Si_str_done = 1 , ST_TRIBE = St_DONE   
        
    );
signal ST_STR  : state_t := St_CHECK_STR;



signal Si_strindex_str   :integer range 0 to 40 := 0 ;
signal Si_pageindex_str  :integer range 0 to 8 := 0 ;
signal Si_str_busy       :  std_logic := '0';
signal Si_str_done       :  std_logic := '0';


type char_asciT_array_t is array (0 to 12) of integer range 0 to 127  ;

type char_value_asciT_array_t is array (0 to 16) of integer range 0 to 127  ;
type char_name_asciT_array_t is array (0 to 2) of integer range 0 to 127  ;
type char_io_asciT_array_t is array (0 to 2) of integer range 0 to 127  ;
type char_pin_asciT_array_t is array ( 0 to 4 ) of integer range 0 to 127  ;

--type str_char_array_t is array (natural range <>) of char_asciT_array_t ;
type str_char_name_array_t is array (0 to 4) of char_name_asciT_array_t ;
type str_char_io_array_t is array (0 to 2) of char_io_asciT_array_t ;
type str_char_pin_array_t is array ( 0 to 8 ) of char_pin_asciT_array_t ;

--signal Si_Module_name_ID_index  :integer range 0 to 20 := 0 ;      --not necessery any more 
--signal Si_Module_io_ID_index    :integer range 0 to 2 := 0 ;       --not necessery any more    --I have -> Si_strindex_str
--signal Si_Module_pin_ID_index   :integer range 0 to 20 := 0 ;      --not necessery any more 
--signal Si_Module_value_ID_buffer : char_asciT_array_t := (0 , 0 , 0 , 0);--( 0 X " abcd " ) 8 char will this buffer have  --not necessery any more
signal Si_Module_name_ID_asci_code  : char_asciT_array_t := (32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32); 
signal Si_Module_io_ID_asci_code    : char_asciT_array_t := (32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32); 
signal Si_Module_pin_ID_asci_code   : char_asciT_array_t := (32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32); 
signal Si_Module_value_ID_asci_code : char_asciT_array_t := (32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32); 

constant C_Module_value_ID_buffer :char_value_asciT_array_t := ( 
48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 97, 98, 99, 100, 101, 102 , 32) ;--you input 4 bit as adress int o it  0 to 15 + space
constant C_Module_name_ID_buffer  :str_char_name_array_t := ( 
                                                        ( 32 , 32 , 32 ) , 
                                                        (73, 77, 32 ) , 
                                                        (82, 101, 103) , 
                                                        (65, 76, 85) , 
                                                        (68, 77, 32 )
                                                         );   --IM * Reg * ALU * DM 


constant C_Module_io_ID_buffer    :str_char_io_array_t := ( 
                                                        (32, 32, 32) , 
                                                        (73, 78, 32) , 
                                                        (79, 85, 84)  
                                                        ) ;

constant C_Module_pin_ID_buffer   :str_char_pin_array_t := (  ( 32 , 32 , 32 , 32 , 32 ) ,
                                                        (112, 105, 110, 48, 32), --pin0   
                                                        (112, 105, 110, 49, 32), --pin1   
                                                        (112, 105, 110, 50, 32), --pin2   
                                                        (112, 105, 110, 51, 32), --pin3  
                                                        (112, 111, 117, 116, 48), --pout0
                                                        (112, 111, 117, 116, 49), --pout1  
                                                        (112, 111, 117, 116, 50), --pout2  
                                                        (112, 111, 117, 116, 51)  --pout2
                                                         );
signal ASCII_str_4_Bmap_index_limit : integer range 0 to 40  := 0;
--signal ASCII_str_4_Bmap : char_asciT_array_t := (0 , 0 , 0 , 0);--control with Si_strindex_str   ---not using anymore
signal ASCII_char_4_Bmap : integer range 0 to 127  := 48 ;


begin





p09_char2bmap_mdl : entity work.p09_char2bmap
    Port MAP(
        clk       =>    clk     ,  
        
        bmap_rst         =>  Si_bmap_rst      , 
        bmap_ena         =>  Si_bmap_ena      , 
        bmap_activate    =>  Si_bmap_activate , 
        
        i2c_tx_character_acsii_number => ASCII_char_4_Bmap   ,
          i2c_tx_req_4pre          =>  i2c_tx_req_4pre       ,
          i2c_tx_byte1_4pre       =>    i2c_tx_byte1_4pre    ,
          i2c_tx_byte2_4pre       =>    i2c_tx_byte2_4pre    ,
          
        tribe_pre_busy    => tribe_pre_busy  ,   
        tribe_pre_done    => tribe_pre_done  ,  
        tribe_pre_error   => tribe_pre_error ,


          bmap_busy      =>  Si_bmap_busy     , 
          bmap_done      =>  Si_bmap_done     ,  
          bmap_error     =>  Si_bmap_error    

     
    );






process (clk) begin 
    if rising_edge(clk) and (str_ena = '1') then 
        if (str_rst = '1') then
        
        else 
            case (ST_STR) is 
                when St_CHECK_STR       =>
                    if ( str_activate = '1' ) and ( tribe_pre_busy = '0')  then 
                        ST_STR <= St_SET_STR ;
                    end if ;  
                
                when St_SET_STR         =>
                    Si_bmap_ena <= '1';
                    Si_strindex_str  <= 0;    
                    Si_pageindex_str <= 0;    
                    Si_str_busy      <= '1'; 
                    Si_str_done      <= '0'; 
                    ST_STR <= St_UPDT_STR ;
                    
                    
     
                                        
                    
                    
                
                
                 
                when St_UPDT_STR        =>
                 if (Module_io_ID  = '0') then
                        Si_Module_io_ID_asci_code(0)    <= C_Module_io_ID_buffer(1)(0);
                        Si_Module_io_ID_asci_code(1)    <= C_Module_io_ID_buffer(1)(1);
                        Si_Module_io_ID_asci_code(2)    <= C_Module_io_ID_buffer(1)(2);
                    elsif (Module_io_ID  = '1') then
                        Si_Module_io_ID_asci_code(0)    <= C_Module_io_ID_buffer(2)(0);
                        Si_Module_io_ID_asci_code(1)    <= C_Module_io_ID_buffer(2)(1);
                        Si_Module_io_ID_asci_code(2)    <= C_Module_io_ID_buffer(2)(2);
                    
                    else 
                        Si_Module_io_ID_asci_code(0)    <= C_Module_io_ID_buffer(0)(0);
                        Si_Module_io_ID_asci_code(1)    <= C_Module_io_ID_buffer(0)(1);
                        Si_Module_io_ID_asci_code(2)    <= C_Module_io_ID_buffer(0)(2);
                    
                    end if ;
                   Si_Module_value_ID_asci_code(7) <=  C_Module_value_ID_buffer( to_integer(unsigned(Module_value_ID( 31 downto 28))) );
                   Si_Module_value_ID_asci_code(6) <=  C_Module_value_ID_buffer( to_integer(unsigned(Module_value_ID( 27 downto 24))) );
                   Si_Module_value_ID_asci_code(5) <=  C_Module_value_ID_buffer( to_integer(unsigned(Module_value_ID( 23 downto 20))) );
                   Si_Module_value_ID_asci_code(4) <=  C_Module_value_ID_buffer( to_integer(unsigned(Module_value_ID( 19 downto 16))) );
                   Si_Module_value_ID_asci_code(3) <=  C_Module_value_ID_buffer( to_integer(unsigned(Module_value_ID( 15 downto 12))));
                   Si_Module_value_ID_asci_code(2) <=  C_Module_value_ID_buffer( to_integer(unsigned(Module_value_ID( 11 downto 8))) );
                   Si_Module_value_ID_asci_code(1) <=  C_Module_value_ID_buffer( to_integer(unsigned(Module_value_ID( 7 downto 4)))  );
                   Si_Module_value_ID_asci_code(0) <=  C_Module_value_ID_buffer( to_integer(unsigned(Module_value_ID( 3 downto 0)))  );
                   
                   
--                    case (Module_name_ID ) is 
--                        when X"01" => 
--                        Si_Module_name_ID_asci_code   <= C_Module_name_ID_buffer(1);
--                        case (Module_pin_ID ) is 
--                            when X"01" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(1);
--                            when X"02" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(2);
--                            when X"03" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(3);
--                            when X"04" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(4);
--                            when X"81" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(5);
--                            when X"82" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(6);
--                            when X"83" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(7);
--                            when X"84" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(8);
--                            when others =>
--                        Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(0);
--                        end case ;
                        
                        
--                        when X"02" => 
--                        Si_Module_name_ID_asci_code   <= C_Module_name_ID_buffer(2);
--                        case (Module_pin_ID ) is 
--                            when X"01" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(1);
--                            when X"02" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(2);
--                            when X"03" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(3);
--                            when X"04" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(4);
--                            when X"81" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(5);
--                            when X"82" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(6);
--                            when X"83" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(7);
--                            when X"84" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(8);
--                            when others =>
--                        Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(0);
--                        end case ;
                        
                        
--                        when X"03" => 
--                        Si_Module_name_ID_asci_code   <= C_Module_name_ID_buffer(3);
--                        case (Module_pin_ID ) is 
--                            when X"01" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(1);
--                            when X"02" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(2);
--                            when X"03" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(3);
--                            when X"04" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(4);
--                            when X"81" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(5);
--                            when X"82" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(6);
--                            when X"83" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(7);
--                            when X"84" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(8);
--                            when others =>
--                        Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(0);
--                        end case ;
                        
                        
--                        when X"04" => 
--                        Si_Module_name_ID_asci_code   <= C_Module_name_ID_buffer(4);
--                        case (Module_pin_ID ) is 
--                            when X"01" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(1);
--                            when X"02" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(2);
--                            when X"03" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(3);
--                            when X"04" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(4);
--                            when X"81" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(5);
--                            when X"82" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(6);
--                            when X"83" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(7);
--                            when X"84" =>
--                                Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(8);
--                            when others =>
--                        Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(0);
--                        end case ;
                        
                        
                        
                        
--                        when others =>
                        
--                        Si_Module_name_ID_asci_code   <= C_Module_name_ID_buffer(0);
--                        Si_Module_pin_ID_asci_code    <= C_Module_pin_ID_buffer(0);
--                    end case ;
                    
                    
                    
                    ST_STR <= St_SET_MInit ;

              
                   
                    
                when     St_SET_MInit   =>   
                    if ( str_mode_change_req_4init_done = '0' ) then
                        ST_STR <= St_WAIT_MInit ;
                        str_mode_change_req_4init <= '1' ;
                        init_mode  <= X"7";
                        page_number <= std_logic_vector( to_unsigned(Si_pageindex_str ,  page_number'length) );
                                      
                        
                        
                    end if ;
                
    --            when     St_SEND_MInit  =>
                when     St_WAIT_MInit  =>
                    if ( str_mode_change_req_4init_done = '1'   ) then
                        ST_STR <= St_SEND_STR ;
                        str_mode_change_req_4init <= '0' ;
                        case (Si_pageindex_str) is --Si_Module_name_ID_asci_code Si_Module_io_ID_asci_code  Si_Module_pin_ID_asci_code Si_Module_value_ID_asci_code
                            when 0  =>     --module name  
                                ASCII_str_4_Bmap_index_limit  <=  C_Module_name_ID_buffer(to_integer( unsigned(Module_name_ID) )  )'length ; 
                              --  ASCII_str_4_Bmap <= Si_Module_name_ID_asci_code  ;                  
                                                                  
                            when 2  =>      -- in out             Si_Module_io_ID_asci_code  
                                ASCII_str_4_Bmap_index_limit  <=  Si_Module_io_ID_asci_code'length ;
                             --   ASCII_str_4_Bmap <= Si_Module_io_ID_asci_code  ; 
                                                                  
                            when 4  =>      --pin mame            Si_Module_pin_ID_asci_code  
                                ASCII_str_4_Bmap_index_limit  <=  C_Module_pin_ID_buffer(to_integer( unsigned(Module_pin_ID) )  )'length ; 
                             --   ASCII_str_4_Bmap <= Si_Module_pin_ID_asci_code  ;
                                                                  
                            when 6  =>      --pin value           Si_Module_value_ID_asci_code
                                ASCII_str_4_Bmap_index_limit  <=  Si_Module_value_ID_asci_code'length ; 
                              --  ASCII_str_4_Bmap <= Si_Module_value_ID_asci_code  ;
                            when others =>
                            null ;                       
                        end case ;   
                        
                    end if ;
                
                when St_SEND_STR        =>
                    if(Si_strindex_str < ASCII_str_4_Bmap_index_limit ) and (Si_bmap_busy = '0') then
                        Si_bmap_activate <= '1' ;
                        ST_STR <= St_WAIT_STR ;
                         
                        case (Si_pageindex_str) is --Si_Module_name_ID_asci_code Si_Module_io_ID_asci_code  Si_Module_pin_ID_asci_code Si_Module_value_ID_asci_code
                            when 0  =>     --module name  
                                
                                ASCII_char_4_Bmap <= C_Module_name_ID_buffer(to_integer( unsigned(Module_name_ID) )  )(Si_strindex_str )  ;                  
                                                                  
                            when 2  =>      -- in out             Si_Module_io_ID_asci_code  
                                
                                ASCII_char_4_Bmap <= Si_Module_io_ID_asci_code(Si_strindex_str );
                                                                  
                            when 4  =>      --pin mame            Si_Module_pin_ID_asci_code  
                                
                                ASCII_char_4_Bmap <= C_Module_pin_ID_buffer(to_integer( unsigned(Module_pin_ID) )  )(Si_strindex_str );   
                                                                  
                            when 6  =>      --pin value           Si_Module_value_ID_asci_code
                                
                                ASCII_char_4_Bmap <= Si_Module_value_ID_asci_code(Si_strindex_str );
                            when others =>
                            null ;                       
                        end case ; 
                        
                        
                    else 
                        if (Si_pageindex_str < 7) then 
                        
                            Si_pageindex_str <= Si_pageindex_str +2 ;
                            ST_STR <= St_SET_MInit ;
                        else
                            ST_STR <= St_DONE_STR ;
                        end if ;
                    end if ;
                  
                  
             
                when St_WAIT_STR        => -- if done bmap tx send Si_strindex_str <= Si_strindex_str +1 ;
                    if (Si_bmap_done = '1') then 
                        ST_STR <= St_SEND_STR ;
                        Si_bmap_activate <= '0' ;
                        Si_strindex_str <= Si_strindex_str +1 ;
                        
                    end if ;
--                when     St_CHECK_BMAP  =>
--                when     St_SET_BMAP    =>
--                when     St_SEND_BMAP   =>
--                when     St_WAIT_BMAP   =>
--                when     St_DONE_BMAP   =>
                
                
                when St_DONE_STR        =>
                    Si_bmap_ena <= '0';
                    str_busy <= '0' ;
                    str_done <= '1' ; 
                    Si_pageindex_str <=0 ; 
                    page_number <= "000" ;
                    if (str_activate = '0' ) then
                        ST_STR <= St_CHECK_STR ;
                    end if ;
                
                
                
            end case ;
        end if ;
    end if ;
end process ;










end Behavioral;
