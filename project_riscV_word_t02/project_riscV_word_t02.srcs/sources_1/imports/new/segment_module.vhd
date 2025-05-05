----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2025 14:53:26
-- Design Name: 
-- Module Name: segment_module - Behavioral
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

entity segment_module is 
    Generic(
        maxsevensinglecounter : integer:= 500_000
        
    );
    Port (
        
        Xclk : in std_logic ;
        fourHEX : in std_logic_vector( 15 downto 0 ) ;
        
        SEGMENT4_top :  out std_logic_vector(3 downto 0) := X"1" ;
        SEGMENT7_top  : out std_logic_vector(7 downto 0) := X"00" 
    );
end segment_module;

architecture Behavioral of segment_module is
------- COMPONENT -----
--component single segment is
--    Port(
--        RST : in std_logic  ; 
--        CLK : in std_logic  ; 
--        next_PC : in std_logic_vector(RV_lvlinbit-1 downto 0 ) ; 
--        current_pc : out std_logic_vector( RV_lvlinbit-1 downto 0 ):= (others=>'0')
        
--    );
    
    

----- Signal -----
signal sevenouter4index  :std_logic_vector( 3 downto 0) := X"0" ;
signal minicounter : integer range 0 to maxsevensinglecounter+50 := 0 ;


signal counter : std_logic_vector( 3 downto 0) := X"0" ;
signal one : std_logic_vector(1 downto 0) := "01";
signal segment_counter  :std_logic_vector( 3 downto 0) := X"0" ;
 
type rom_typ7 is array(0 to 17) of std_logic_vector(7 downto 0)  ;-- msb is dot
constant ROM7seg : rom_typ7 := (
    "11111100", -- 0: Segment A, B, C, D, E, F açýk (dot kapalý)
    "01100000", -- 1: Segment B, C açýk
    "11011010", -- 2: Segment A, B, G, E, D açýk
    "11110010", -- 3: Segment A, B, G, C, D açýk
    "01100110", -- 4: Segment F, G, B, C açýk
    "10110110", -- 5: Segment A, F, G, C, D açýk
    "10111110", -- 6: Segment A, F, G, E, C, D açýk
    "11100000", -- 7: Segment A, B, C açýk
    "11111110", -- 8: Tüm segmentler açýk (dot kapalý)
    "11110110", -- 9: Segment A, B, C, D, F, G açýk
    "00111010", -- A: Segment A, B, C, E, F, G açýk
    "00111110", -- B: Segment F, E, G, C, D açýk
    "00011010", -- C: Segment A, F, E, D açýk
    "01111010", -- D: Segment B, C, D, E, G açýk
    "10011110", -- E: Segment A, F, G, E, D açýk
    "10001110", -- F: Segment A, F, G, E açýk
    "00000000", -- 16: Blank (Tüm segmentler kapalý)
    "01101101"  -- 17: Tüm segmentler ve dot açýk



    
);


begin




process ( Xclk ) begin 
    if (rising_edge(Xclk) ) then 
                if (minicounter >= maxsevensinglecounter) then  --maxsevensinglecounter = 5_000_100
        minicounter <= 0;
        sevenouter4index <= std_logic_vector( unsigned(sevenouter4index ) + unsigned(one) );
        else 
        minicounter <= minicounter + 1 ;

            if (sevenouter4index(1 downto 0) = "00" ) then
                SEGMENT4_top <= not X"1";
                SEGMENT7_top <= not ROM7seg(  to_integer(unsigned( fourHEX(3 downto 0) )));
            elsif (sevenouter4index(1 downto 0) = "01" ) then
                SEGMENT4_top <= not X"2";
                SEGMENT7_top <= not ROM7seg(  to_integer(unsigned( fourHEX(7 downto 4) )));
            elsif (sevenouter4index(1 downto 0) = "10"  ) then
                SEGMENT4_top <= not X"4";
                SEGMENT7_top <= not ROM7seg(  to_integer(unsigned( fourHEX(11 downto 8) )));
            elsif (sevenouter4index(1 downto 0) = "11"  ) then
                SEGMENT4_top <= not X"8";
                SEGMENT7_top <= not ROM7seg( to_integer(unsigned( fourHEX(15 downto 12) )));
           
            end if;
       end if; 
        
    end if ;
    


end process ;










end Behavioral;
