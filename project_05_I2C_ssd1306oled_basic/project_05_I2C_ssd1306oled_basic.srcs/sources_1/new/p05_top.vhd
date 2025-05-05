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
        
        SCL : out std_logic := '1'; --400kbps(kilo bit per second) 
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

component p05_I2C_ip is
    Generic (
        mainCristal : integer := 100_000_000 ;
        spiCom_speedTYPE : std_logic_vector(1 downto 0) := "01"
    );
    Port ( 
        Xclk : in std_logic := '0'; --system clk
        btn_triger : in std_logic := '0';--temporarry solution )  ;
        Serial_Clk : out std_logic := '1'; --400kbps(kilo bit per second) 
        Serial_Com : inout std_logic:= '1';
        valid_transfer : out std_logic := '0' 
           
    );
               
end component;


----------------------signals-----------------------
signal S_BTN_top :  std_logic_vector(4 downto 0) ;
signal S_SW_top :  std_logic_vector(15 downto 0) ;
signal S_valid_i2c_transfer :  std_logic := '0' ;
           


begin




DEbounce :debounce_module
port Map(

        Xclk => CLK_top ,
        BTN_top_deb => BTN_top ,
        SW_top_deb => SW_top ,
        BTN_topdeb => S_BTN_top , 
        SW_topdeb => S_SW_top

);



I2C_ip :p05_I2C_ip
port Map( 
        Xclk => CLK_top ,
        btn_triger => S_SW_top(0) ,
        Serial_Clk => SCL , 
        Serial_Com => SDA ,
        valid_transfer => S_valid_i2c_transfer 
);



end Behavioral_top;
