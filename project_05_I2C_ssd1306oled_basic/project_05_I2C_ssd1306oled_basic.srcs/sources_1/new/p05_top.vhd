----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2025 15:30:16
-- Design Name: 
-- Module Name: p05_top - Behavioral_top
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

entity p05_top is
    Port (
        CLK_top : in std_logic ;
        BTN_top :  in std_logic_vector(4 downto 0) ;
        SW_top : in std_logic_vector(15 downto 0) ;
        LED_top : out std_logic_vector(15 downto 0) := X"0000"   ; 
        SCL : inout std_logic := '1'; --400kbps(kilo bit per second) 
        SDA : inout std_logic:= '1'
        
    );
end p05_top;

architecture Behavioral_top of p05_top is

component debounce_module is
    Generic(
        X_clkHz : integer := 100_000_000;
        debounce_max : integer := 10_000_000--1_000_000 
        
    );
    Port (
        Xclk : in std_logic ;
        BTN_top_deb :  in std_logic_vector(4 downto 0) ;
        SW_top_deb : in std_logic_vector(15 downto 0) ;
        BTN_topdeb :  out std_logic_vector(4 downto 0) ;
        SW_topdeb : out std_logic_vector(15 downto 0) 
     );
end component;

component p05_oled1306 is
    Port (
    
        btn_triger : in std_logic := '0';--temporarry solution 
        en_com : out std_logic := '0';-- 1 activates com 
        adrr_1306_d1 :out  std_logic_vector(6 downto 0) := "0111100";
        R_W       : out std_logic := '0';  --1 reads 0 writes
        data_wr   : out     std_logic_vector(7 downto 0); --data to write to slave
        busy      : in    std_logic := '0';     --indicates transaction in progress
        data_rd   : in    std_logic_vector(7 downto 0) --data read from slave

    );
end component;

component p05_mba_I2C IS
  GENERIC(
    input_clk : INTEGER := 100_000_000; --input clock speed from user logic in Hz
    bus_clk   : INTEGER := 100_000);   --speed the i2c bus (scl) will run at in Hz
  PORT(
    clk       : IN     STD_LOGIC := '0';                    --system clock
    reset_n   : IN     STD_LOGIC := '0';                    --active low reset
    ena       : IN     STD_LOGIC := '0';                    --latch in command
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000" ; --address of target slave
    rw        : IN     STD_LOGIC := '0';                    --'0' is write, '1' is read
    data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0):= "00000000" ; --data to write to slave
    busy      : OUT    STD_LOGIC := '0';                    --indicates transaction in progress
    data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0):= "00000000" ; --data read from slave
    ack_error : BUFFER STD_LOGIC:= '0';                    --flag if improper acknowledge from slave
    sda       : INOUT  STD_LOGIC:= '0';                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC:= '0');                   --serial clock output of i2c bus
END component;


----------------------signals-----------------------
signal S_BTN_top :  std_logic_vector(4 downto 0) ;
signal S_SW_top :  std_logic_vector(15 downto 0) ;
signal S_enaComI2C :  std_logic := '0' ;
           
signal  S_bus_adress :  std_logic_vector(6 downto 0) ;
signal  S_bus_rw :  std_logic ;
signal  S_bus_dataW :  std_logic_vector(7 downto 0) ;
signal  S_bus_busy :  std_logic ;
signal  S_bus_dataR :  std_logic_vector(7 downto 0) ;



begin
LED_top  <=  S_bus_adress & S_bus_rw & S_bus_dataW  ;--& S_bus_busy & S_bus_dataR & S_enaComI2C & S_BTN_top(1 downto 0) ;



DEbounce :debounce_module
port Map(

        Xclk => CLK_top ,
        BTN_top_deb => BTN_top ,
        SW_top_deb => SW_top ,
        BTN_topdeb => S_BTN_top , 
        SW_topdeb => S_SW_top

);




controller_oled1306 : p05_oled1306 
    Port Map(
    
        btn_triger => S_BTN_top(0),
        en_com => S_enaComI2C ,
        adrr_1306_d1   => S_bus_adress ,
        R_W       => S_bus_rw ,
        data_wr   => S_bus_dataW,
        busy      => S_bus_busy ,
        data_rd   => S_bus_dataR

    );
    
    
    
    
mba_I2C : p05_mba_I2C 
  --speed the i2c bus (scl) will run at in Hz
  PORT Map(
    clk       => CLK_top ,                    --system clock
    reset_n   =>S_BTN_top(1),
    ena       =>S_enaComI2C ,
    addr      => S_bus_adress ,
    rw        => S_bus_rw ,
    data_wr   => S_bus_dataW,
    busy      => S_bus_busy ,
    data_rd   => S_bus_dataR,
    --ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
    sda       =>  SDA,
    scl       =>  SCL 
    );


end Behavioral_top;
