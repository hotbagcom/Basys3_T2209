----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2025 16:30:03
-- Design Name: 
-- Module Name: p04_top - Behavioral
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

entity p04_top is
    Port (
        CLK_top :  in std_logic := '0' ;
        ard_SPI_clk_in : in std_logic := '0';
        ard_SPI_E_in   : in std_logic := '1';
        ard_SPI_MOSI_in: in std_logic := '0';
        
        SEGMENT4_top :  out std_logic_vector(3 downto 0) := X"1" ;
        SEGMENT7_top  : out std_logic_vector(7 downto 0) := X"00";
        LED_top  : out std_logic_vector(15 downto 0) := X"0000"
        
     );
end p04_top;

architecture Behavioral of p04_top is
----------------component------------------------
component p04_clkcount_onenable is
    Generic (
        SPI_mod : std_ulogic_vector(1 downto 0)  := "00" 
    );
    Port (
        Xclk :  in std_logic := '0' ;
        ard_SPI_clk_i : in std_logic := '0';
        ard_SPI_E_i   : in std_logic := '1';
        ard_SPI_MOSI_i: in std_logic := '0';
        ard_SPI_MOSI_buffer_o : out std_logic_vector(7 downto 0) := X"00";
        count_ARD_SPI_clk_o : out std_logic_vector(11 downto 0) := X"000";
        ready_Cardspiclk_o :  out std_logic := '0'
    );
end component ;

component p04_lgcvect2decimal is
    Port (
        count_ARD_SPI_clk_i : in std_logic_vector(11 downto 0) := X"000";
        ready_Cardspiclk_i : in std_logic := '0' ;  
        count_ARD_SPI_clk_7seg_o : in std_logic_vector(15 downto 0) := X"0000"
    );
end component ;

component segment_module is 
    Generic(
        maxsevensinglecounter : integer:= 500_000
    );
    Port (
        Xclk : in std_logic ;
        fourHEX : in std_logic_vector( 15 downto 0 ) ;
        SEGMENT4:  out std_logic_vector(3 downto 0) := X"1" ;
        SEGMENT7 : out std_logic_vector(7 downto 0) := X"00" 
    );
end component;

------------------------signal------------------------
signal S_count_ARD_SPI_clk_7seg : std_logic_vector(15 downto 0) := X"0000";
signal S_ready_Cardspiclk : std_logic := '0' ;
signal S_count_ARD_SPI_clk : std_logic_vector(11 downto 0) := X"000";
                        begin
                        
                        
                        
p04_main_collector : 
 p04_clkcount_onenable 
    port map (
        Xclk => CLK_top ,
        ard_SPI_clk_i => ard_SPI_clk_in ,
        ard_SPI_E_i   =>  ard_SPI_E_in ,
        ard_SPI_MOSI_i  =>  ard_SPI_MOSI_in ,
        ard_SPI_MOSI_buffer_o   =>   LED_top (7 downto 0) ,
        count_ARD_SPI_clk_o  => S_count_ARD_SPI_clk ,
        ready_Cardspiclk_o  => S_ready_Cardspiclk 
    );


p04_hex2dec_seperator : 
p04_lgcvect2decimal
    port map (
        count_ARD_SPI_clk_i => S_count_ARD_SPI_clk ,
        ready_Cardspiclk_i => S_ready_Cardspiclk ,  
        count_ARD_SPI_clk_7seg_o => S_count_ARD_SPI_clk_7seg 
    );


p04_7seg : segment_module
    port map(
        Xclk => CLK_top ,
        fourHEX => S_count_ARD_SPI_clk_7seg ,
        SEGMENT4 => SEGMENT4_top ,
        SEGMENT7  =>  SEGMENT7_top
    );




end Behavioral;
