----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2025 12:38:18
-- Design Name: 
-- Module Name: p06_top - Behavioral
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

entity p06_top is 
    Port (
        
        BTN_top :  in std_logic_vector(4 downto 0) ;
        SW_top : in std_logic_vector(15 downto 0) ;  
        LED_top : out std_logic_vector(15 downto 0) ;  
        
        --SCK :  out std_logic := '0' ;
        SO : in std_logic := '0' ;
        SI : out std_logic := '0' ;
        CS  : out std_logic := '0' ;
              
        CLK_top : in std_logic := '0' 
    );
end p06_top;

architecture Behavioral of p06_top is

---------------------------COMPONENT---------------------------
component  debounce_module is
    Generic(
        X_clkHz : integer := 100_000_000;
        debounce_max : integer := 2_000_000--1_000_000 
        
    );
    Port (
    
        Xclk : in std_logic ;
        
        BTN_top_deb :  in std_logic_vector(4 downto 0) ;
        SW_top_deb : in std_logic_vector(15 downto 0) ;
        BTN_topdeb :  out std_logic_vector(4 downto 0) ;
        SW_topdeb : out std_logic_vector(15 downto 0) 
        
       
     );
end component;


component p06_serialflash_cntrlREG is
    Port ( 
        Mclk_i : in std_logic := '0' ;
        vect_McRegi : in std_logic_vector( 7 downto 0) ;
        vect_McREGo : out std_logic_vector( 7 downto 0) := (others=>'0');
        spiMCore_en :  out std_logic := '0' ;
        data_ready : in std_logic := '0' ;
        external_triger_btn : in std_logic_vector( 4 downto 0) := "00000" 
    );
end component;


component p06_spi_for_serailflash is
    Generic (
        Xclk_freq 		: integer := 100_000_000;
        spiClk_freq 		: integer := 400_000;
        Cpol         : std_logic := '0' ;
        Cpha         : std_logic := '0'
    );
    Port ( 
        Mclk_i : in std_logic := '0' ;
        
        vect_Mi : in std_logic_vector( 7 downto 0) := (others=>'0');
        vect_Mo : out std_logic_vector( 7 downto 0) := (others=>'0');
        spiMCore_en :  in std_logic := '0' ;
        data_ready : out std_logic := '0' ;
        
        spiClk_o : out std_logic := '0' ;
        miso : in std_logic := '0' ;
        mosi : out std_logic := '0' ;
        SlvSlkt : out std_logic := '0' 
    );
end component;

component STARTUPE2
    port (
        CFGCLK    : in  std_logic;
        CFGMCLK   : in  std_logic;
        EOS       : in  std_logic;
        PREQ      : in  std_logic;
        CLK       : in  std_logic;
        GSR       : in  std_logic;
        GTS       : in  std_logic;
        KEYCLEARB : in  std_logic;
        PACK      : in  std_logic;
        USRCCLKO  : out std_logic;
        USRCCLKTS : in  std_logic;
        USRDONEO  : out std_logic;
        USRDONETS : in  std_logic
    );
end component;




--------------Sinyal--------------
signal S_BTN_topdeb : std_logic_vector(4 downto 0) ;
signal S_SW_topdeb :  std_logic_vector(15 downto 0) ;

signal S_vect_MRi :  std_logic_vector( 7 downto 0) := (others=>'0');
signal S_vect_MRo :  std_logic_vector( 7 downto 0) := (others=>'0');
Signal S_spiMCore_en : std_logic ;
signal S_data_ready : std_logic ;

signal SCK :  std_logic := '0' ;

begin



LED_top (7 downto 0)<=   S_vect_MRo ;
LED_top (15 downto 8)<=  S_vect_MRi ;-- S_SW_topdeb( 7 downto 0) and S_SW_topdeb( 15 downto 8) ;





Debounce:  debounce_module 
    Port map(
    
        Xclk => CLK_top,
        
        BTN_top_deb => BTN_top ,
        SW_top_deb => SW_top ,
        BTN_topdeb  => S_BTN_topdeb ,
        SW_topdeb  => S_SW_topdeb
        
     );


SerialF_cntrlREG : p06_serialflash_cntrlREG 
    Port Map( 
        Mclk_i => CLK_top ,
        vect_McRegi => S_vect_MRi ,
        vect_McREGo => S_vect_MRo ,
        spiMCore_en => S_spiMCore_en ,
        data_ready => S_data_ready ,
        external_triger_btn => S_BTN_topdeb
    );



SPI_Core :  p06_spi_for_serailflash 
    Port Map( 
        Mclk_i => CLK_top ,
        vect_Mo => S_vect_MRi ,--MasterSPI out : Register in
        vect_Mi => S_vect_MRo ,--MasterSPI in : Register out
        
        
        spiMCore_en => S_spiMCore_en ,
        data_ready => S_data_ready ,
        
        spiClk_o => SCK ,
        miso => SO ,
        mosi => SI ,
        SlvSlkt => CS  
    );
    
    
STARTUPE2_inst : STARTUPE2
port map (
    CFGCLK    => '0', -- Baðlantý yok
    CFGMCLK   => '0', -- Baðlantý yok
    EOS       => '0', -- Baðlantý yok
    PREQ      => '0', -- Baðlantý yok
    CLK       => '0',
    GSR       => '0',
    GTS       => '0',
    KEYCLEARB => '0',
    PACK      => '0',
    USRCCLKO  => SCK,
    USRCCLKTS => '0',
    USRDONEO  => open,
    USRDONETS => '1'
);



end Behavioral;
