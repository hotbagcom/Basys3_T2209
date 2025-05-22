----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2025 09:55:37
-- Design Name: 
-- Module Name: p08_pseudo_top - Behavioral
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

entity p08_pseudo_top is
    Generic(
        OLED_1306_adres : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0111100" 
        
    );
    Port (
clk       :  in    STD_LOGIC:= '0'; 
reset_mdl  : in STD_LOGIC:= '0'; 
    
    ena_oled : in std_logic := '0';
    Total_ID : in std_logic_vector(15 downto 0) := X"0000"; 
    
SCL_io : inout STD_LOGIC := '0'; 
SDA_io : inout STD_LOGIC := '0'

    );
end p08_pseudo_top;

architecture Behavioral of p08_pseudo_top is




signal Si_clk : STD_LOGIC;
signal Si_reset_mdl : STD_LOGIC ;

signal Si_ena_trioled : std_logic := '0';
signal Si_ena_mbai2core : std_logic := '0';

signal Si_busy_trioled : std_logic := '0';
signal Si_busy_mbai2core : std_logic := '0';

signal Si_i2ctx_byte : std_logic_vector( 7 downto 0 );


signal Si_mdl_name_ID  : std_logic_vector( 7 downto 0 ) ;
signal Si_mdl_io_ID  : std_logic ;  
signal Si_mdl_pin_ID  : std_logic_vector( 6 downto 0 ) ; 
signal Si_mdl_value_ID  : std_logic_vector( 31 downto 0 ) := X"00abcd00" ;



--tribe of oled { [p08_init] -  [p08_str2char -> p08_char2pix -> p08_pix2byte ]  }
--              {        p08_preMBA                                              }

--                      p05_mba_I2C
begin

Si_clk <= clk ;
Si_reset_mdl <= reset_mdl ;


p08_tribeOFoled1306_mdl : entity work.p08_tribeOFoled1306
    Port MAP(
        clk         =>    Si_clk       ,
        reset_n     =>    Si_reset_mdl ,
        ena         =>    Si_ena_trioled ,
        
        Module_name_ID   =>    Si_mdl_name_ID ,
        Module_io_ID     =>    Si_mdl_io_ID ,
        Module_pin_ID    =>    Si_mdl_pin_ID ,
        Module_value_ID  =>    Si_mdl_value_ID,
        
        i2c_dataWR => Si_i2ctx_byte 
    );

p05_mba_I2C_mdl : entity work.p05_mba_I2C
  PORT MAP(
  
    clk         =>    clk       ,
    reset_n     =>    Si_reset_mdl ,
    ena        => Si_ena_mbai2core  ,                   --latch in command
    addr        => OLED_1306_adres  ,
    --rw    : IN     STD_LOGIC := '0';                    --'0' is write, '1' is read
    data_wr     =>  Si_i2ctx_byte ,  --data to write to slave
    busy       => Si_busy_mbai2core ,                  --indicates transaction in progress
    --data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
    --ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
    sda    => SDA_io ,               
    scl    => SCL_io 
  
  
  );                   --serial clock output of i2c bus


process ( clk ) begin

    if rising_edge( clk )then 
        if ( Si_reset_mdl = '1' )then 
            
        else
            
        end if ;
    end if ;


end process ;





end Behavioral;
