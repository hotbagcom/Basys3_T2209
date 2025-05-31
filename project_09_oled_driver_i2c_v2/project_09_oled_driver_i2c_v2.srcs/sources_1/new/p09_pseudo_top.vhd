----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2025 17:18:33
-- Design Name: 
-- Module Name: p09_pseudo_top - Behavioral
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

entity p09_pseudo_top is
    Port ( 
    
    
    clk : in std_logic  := '0';
    rst : in std_logic := '0';
    ena : in std_logic := '0';
    activate :  in std_logic := '0';
    
    
    
    
    
    
      busy   :  out std_logic := '0';
      done   :  out std_logic := '0';
      error  :  out std_logic := '0'
    
    
    );
end p09_pseudo_top;

architecture Behavioral of p09_pseudo_top is

--signal for p09_tribeof_oled
signal Si_tribe_rst       : std_logic := '0' ;
signal Si_tribe_ena       : std_logic := '0' ;
signal Si_tribe_activate  : std_logic := '0' ;
signal Si_tribe_busy      : std_logic := '0' ;
signal Si_tribe_done      : std_logic := '0' ;
signal Si_tribe_error     : std_logic := '0' ;

signal Si_tribe_i2c_transaction_active     :      std_logic; -- enable controls transaction if module open transaction active                               
signal Si_tribe_start_i2c_transaction      :       std_logic := '0';                                                                                        
signal Si_tribe_i2c_byte1                  :      std_logic_vector(7 downto 0);                                                                             
signal Si_tribe_i2c_byte2                  :      std_logic_vector(7 downto 0);                                                                             
signal Si_tribe_i2c_transaction_done       :     std_logic;                                                                                                 
signal Si_tribe_i2c_transaction_ack_err    :     std_logic;                                                                                                 















--signal for p09_preMBA

signal Si_pre_rst       : std_logic := '0' ;
signal Si_pre_ena       : std_logic := '0' ;
signal Si_pre_busy      : std_logic := '0' ;
signal Si_pre_done      : std_logic := '0' ;
signal Si_pre_error     : std_logic := '0' ;
                                              

signal Si_pre_activate     :   std_logic := '0';  -- start_transaction   : in  std_logic; -- continious Pulse to initiate     
signal Si_slave_i2c_addr   :   std_logic_vector(6 downto 0);                                                                
signal Si_byte1_to_send    :   std_logic_vector(7 downto 0); -- Typically SSD1306_COMMAND or SSD1306_DATA                   
signal Si_byte2_to_send    :   std_logic_vector(7 downto 0); -- Actual command or data                                      
                                                                                                                         












                                             


type state_t is (
        St_IDLE,                -- if pseudo enabled then    Si_tribe_ena   = 1 = Si_pre_ena and set to St_TRIGER_TRIBE
        
        St_TRIGER_TRIBE,        --   if pseudo activated then activate tribe  else if Si_pre_done = 1 then set ST_PSEUDO = St_DONE_TRIBE ,
        St_SET_TRIBE,           -- if Si_tribe_start_i2c_transaction = 1  then  set ST_PSEUDO = St_SEND_TRIBE
        St_SEND_TRIBE,          -- connect bytes  if Si_pre_done = 0 then set ST_PSEUDO = St_WAIT_TRIBE elsif Si_tribe_done = 1 set ST_PSEUDO = St_DONE_TRIBE
        St_WAIT_TRIBE,          -- if Si_pre_done = 1 and Si_pre_busy = 0 then set Si_tribe_i2c_transaction_done = 1 and set ST_PSEUDO = St_SET_TRIBE
        St_DONE_TRIBE,          --set preudo_busy to  0 ad pseudo_done 1 and set ST_PSEUDO = St_DONE
                                
--        St_TRIGER_MBAcore,      --
--        St_SET_MBAcore,         --
--        St_SEND_MBAcore ,       --
--        St_WAIT_MBAcore ,       --
--        St_DONE_MBAcore ,       --
        
        St_DONE                 --- if this tribe module and MBA deactivated becaouse of screen updated once  make done 1 busy 0 and if avtiveted again sent St_TRIGER_TRIBE
        
    );
signal ST_PSEUDO : state_t := St_IDLE;








begin





p09_tribeof_oled_mdl : entity work.p09_tribeof_oled
    Port MAP(
        clk       =>    clk    ,   
        
        tribe_rst       =>  Si_tribe_rst         ,
        tribe_ena       =>  Si_tribe_ena         ,
        tribe_activate  =>  Si_tribe_activate    ,
        
        i2c_transaction_active    =>  Si_tribe_i2c_transaction_active     , --          in  std_logic; -- enable controls transaction if module open transaction active
          start_i2c_transaction   =>  Si_tribe_start_i2c_transaction    , --          : out  std_logic := '0';            
          i2c_byte1               =>  Si_tribe_i2c_byte1                , --          : out std_logic_vector(7 downto 0);
          i2c_byte2               =>  Si_tribe_i2c_byte2                , --          : out std_logic_vector(7 downto 0);
        i2c_transaction_done      =>  Si_tribe_i2c_transaction_done       , --          in std_logic;                   
        i2c_transaction_ack_err   =>  Si_tribe_i2c_transaction_ack_err    , --          in std_logic;   
        
        
          tribe_busy    =>  Si_tribe_busy        ,
          tribe_done    =>  Si_tribe_done        ,
          tribe_error  =>  Si_tribe_error        ,
          
        tribe_pre_busy    =>  Si_pre_busy        ,   
        tribe_pre_done    =>  Si_pre_done        ,   
        tribe_pre_error   =>  Si_pre_error              
     
     
     
    );


p09_preMBA_mdl : entity work.p09_preMBA
    Port MAP(
        clk           =>    clk ,   
        pre_rst       =>  Si_pre_rst         ,
        pre_ena       =>  Si_pre_ena         ,
        
            -- Control Inputs
        pre_activate      =>   Si_pre_activate   , -- in std_logic := '0';  -- start_transaction   : in  std_logic; -- continious Pulse to initiate
        slave_i2c_addr    =>   Si_slave_i2c_addr ,  -- in  std_logic_vector(6 downto 0);
        byte1_to_send     =>   Si_byte1_to_send  ,  -- in  std_logic_vector(7 downto 0); -- Typically SSD1306_COMMAND or SSD1306_DATA
        byte2_to_send     =>   Si_byte2_to_send  ,  -- in  std_logic_vector(7 downto 0); -- Actual command or data
   
        
          pre_busy    =>  Si_pre_busy        ,
          pre_done    =>  Si_pre_done        ,
          pre_error   =>  Si_pre_error       
     
    );

process ( clk ) begin 
    if rising_edge(clk) then 
        if (rst = '1') then 
        
        else 
            
            case (ST_PSEUDO) is 
            
            when St_IDLE         => 
                    ST_PSEUDO <= St_TRIGER_TRIBE ;
            
            when St_TRIGER_TRIBE =>      
                if (activate = '1') then
                    Si_tribe_ena <= '1';
                    Si_pre_ena <= '1';
                    ST_PSEUDO <= St_SET_TRIBE ;
                end if ;    
            when St_SET_TRIBE    => 
                if ( busy = '0' and done)  
                
                done
                  
            
            when St_SEND_TRIBE   =>    
            when St_WAIT_TRIBE   =>    
            when St_DONE_TRIBE   =>    
               
            when St_DONE         => 
                
            
            
            
            
            
            end case ;
        end if ;
    end if ;

end process ;





end Behavioral;
