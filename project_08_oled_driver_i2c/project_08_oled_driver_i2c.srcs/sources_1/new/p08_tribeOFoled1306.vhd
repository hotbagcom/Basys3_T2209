----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2025 10:32:31
-- Design Name: 
-- Module Name: p08_tribeOFoled1306 - Behavioral
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

entity p08_tribeOFoled1306 is
    Port ( 
    
        clk       : IN     STD_LOGIC := '0'; 
        reset_n   : IN     STD_LOGIC := '0'; 
        ena       : IN     STD_LOGIC := '0';    
        
        Module_name_ID  : in std_logic_vector(7 downto 0) := X"00";
        Module_io_ID    : in std_logic := '0' ;
        Module_pin_ID   : in std_logic_vector(6 downto 0) := X"00";
        Module_value_ID : in std_logic_vector(31 downto 0) := X"00abcd00";
        
        i2c_dataWR : out std_logic_vector( 7 downto 0) := X"00" ;
        
        
          i2c_master_ena      : out std_logic := '0';
          i2c_master_addr     : out std_logic_vector(6 downto 0);
          i2c_master_rw       : out std_logic := '0'; -- Always write for SSD1306 commands/data
          i2c_master_data_wr  : out std_logic_vector(7 downto 0);
        i2c_master_busy     : in  std_logic;
        i2c_master_ack_error: in  std_logic  -- From p05_mba_I2C (buffered)
        
    );
end p08_tribeOFoled1306;

architecture Behavioral of p08_tribeOFoled1306 is


signal Si_reset_n : std_logic := '0' ;

---------------------------------------------------------------
signal Si_ena_init : std_logic := '0' ;
signal Si_init_mode : std_logic_vector(3 downto 0)  := "0000" ;
signal Si_init_set_page_number   : std_logic_vector(2 downto 0)  := "000" ;
signal Si_init_set_colum_number : std_logic_vector(7 downto 0)  := x"00" ;

signal Si_start_i2c_transaction :  std_logic := '0';            
signal Si_i2c_byte1             :  std_logic_vector(7 downto 0); 
signal Si_i2c_byte2             :  std_logic_vector(7 downto 0); 
signal Si_i2c_transaction_done  :  std_logic;                    
signal Si_i2c_transaction_ack_err: std_logic;  

signal Si_init_busy : std_logic := '0';
signal Si_init_done : std_logic := '0';
signal Si_init_module_used_cntr : std_logic_vector(3 downto 0 ) := "0000" ;
--------------------------------------------------------------------------------



signal Si_ena_text : std_logic := '0' ;

signal Si_str_Line_number : std_logic_vector( 2 downto 0) := "000"   ;  
signal Si_str_Text_index  : std_logic_vector( 3 downto 0) := "0000"  ;
signal Si_str_char_index  : std_logic_vector( 2 downto 0) := "000"   ;
signal Si_str_Text_length :  std_logic_vector( 3 downto 0) := "0000" ;
signal Si_str_char_length :  std_logic_vector( 2 downto 0) := "000"  ;
signal Si_error_str           :  std_logic_vector( 3 downto 0) := "0000" ;

signal Si_i2c_dataWR : std_logic_vector( 7 downto 0) := X"00"  ;

-----------------------------------------------------------

signal  Si_precore_start_transaction     :   std_logic; -- Pulse to initiate
signal  Si_precore_slave_i2c_addr        :   std_logic_vector(6 downto 0);
signal  Si_precore_byte1_to_send         :   std_logic_vector(7 downto 0); -- Typically SSD1306_COMMAND or SSD1306_DATA
signal  Si_precore_byte2_to_send         :   std_logic_vector(7 downto 0); -- Actual command or data
  signal  Si_precore_transaction_active  :  std_logic := '0';
  signal  Si_precore_transaction_done    :  std_logic := '0'; -- Pulses high for one clock when done
  signal  Si_precore_transaction_ack_err :  std_logic := '0';



begin
--tribe of oled { [p08_init] -  [p08_str2char -> p08_char2pix -> p08_pix2byte ]  }
--              {        p08_preMBA                                              }



p08_init_mdl : entity work.p08_init
    port Map (
  
        clk             => clk ,
        reset_n         => Si_reset_n , 
        init_mode       => Si_init_mode ,
        page_number     => Si_init_set_page_number   , 
        colum_number    => Si_init_set_colum_number ,
        
        i2c_transaction_active      => Si_ena_init  , 
          start_i2c_transaction     => Si_start_i2c_transaction ,   
          i2c_byte1                 => Si_i2c_byte1        ,       
          i2c_byte2                 => Si_i2c_byte2        ,       
          i2c_transaction_done      => Si_i2c_transaction_done  ,  
          i2c_transaction_ack_err   => Si_i2c_transaction_ack_err ,
        
          busy              => Si_init_busy ,
          done              => Si_init_done ,
          module_used_cntr  => Si_init_module_used_cntr 
    );


 
p08_str2char_mdl : entity work.p08_str2char
    Port Map ( 
    clk         => clk , 
    reset_n     => Si_reset_n ,  
    ena_text  => Si_ena_text , 
    
    Module_name_ID  => Module_name_ID  ,
    Module_io_ID    => Module_io_ID    ,
    Module_pin_ID   => Module_pin_ID   ,
    Module_value_ID => Module_value_ID ,
        
    str_Line_number    => Si_str_Line_number ,   
    str_Text_index     => Si_str_Text_index  ,   --if every char is 8x8 then 16 char will fill the line
    str_char_index     => Si_str_char_index  ,   -- to get one by one every btye of char .
      
      str_new_char_print_en => Si_str_new_char_print_en ,  
      str_inbyte      => Si_str_new_char_inbyte ,
      str_Text_length    => Si_str_Text_length ,   
      str_char_length    => Si_str_char_length ,   --in case of We implement in different size for char (3x8 or 6x8).   
      error_str          => Si_error_str        
    
    req_change_actvPAGE_applied => Si_req_change_actvPAGE_applied ,
      req_change_actvPAGE => Si_req_change_actvPAGE ,
      page_number => out std_logic_vector(2 downto 0) := "000" ;
    );
    
    
    





p08_preMBA_mdl : entity work.p08_preMBA
    Port MAP(

        clk => clk ,       
        rst => Si_reset_n ,
          
        -- OLED Control Inputs
        precore_start_transaction    =>  Si_precore_start_transaction ,
        precore_slave_i2c_addr       =>  Si_precore_slave_i2c_addr    ,
        precore_byte1_to_send        =>  Si_precore_byte1_to_send     ,
        precore_byte2_to_send        =>  Si_precore_byte2_to_send     ,
        
        -- Init Status Outputs
          precore_transaction_active   =>  Si_precore_transaction_active  ,
          precore_transaction_done     =>  Si_precore_transaction_done    ,
          precore_transaction_ack_err  =>  Si_precore_transaction_ack_err ,
    
        -- Interface to p05_mba_I2C master
          i2c_master_ena       =>    i2c_master_ena        ,
          i2c_master_addr      =>    i2c_master_addr       ,
          i2c_master_rw        =>    i2c_master_rw         ,
          i2c_master_data_wr   =>    i2c_master_data_wr    ,
        i2c_master_busy        =>  i2c_master_busy         ,
        i2c_master_ack_error   =>  i2c_master_ack_error    

    );


---case leri kullanarak state ler ile cora giriþ ve çýkýþýn balantýlarýný yap 













end Behavioral;
