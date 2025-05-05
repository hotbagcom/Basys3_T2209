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
    Port (
        
        Xclk : in std_logic ;
        
        BTN_topdeb :  in std_logic_vector(4 downto 0) ;
        SW_topdeb : in std_logic_vector(15 downto 0) ;
        
        
        LED_top : out  std_logic_vector( 15 downto 0 )  := X"0000" ;
        
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

--    "00000011", -- 0: Segment A, B, C, D, E, F açýk (dot kapalý)
--    "00001100", -- 1: Segment B, C açýk
--    "00101001", -- 2: Segment A, B, G, E, D açýk
--    "00101100", -- 3: Segment A, B, G, C, D açýk
--    "00110100", -- 4: Segment F, G, B, C açýk
--    "00111000", -- 5: Segment A, F, G, C, D açýk
--    "00111001", -- 6: Segment A, F, G, E, C, D açýk
--    "00001100", -- 7: Segment A, B, C açýk
--    "00111111", -- 8: Tüm segmentler açýk (dot kapalý)
--    "00111100", -- 9: Segment A, B, C, D, F, G açýk
--    "00111101", -- A: Segment A, B, C, E, F, G açýk
--    "00111110", -- B: Segment F, E, G, C, D açýk
--    "00011011", -- C: Segment A, F, E, D açýk
--    "00110110", -- D: Segment B, C, D, E, G açýk
--    "00111001", -- E: Segment A, F, G, E, D açýk
--    "00110001", -- F: Segment A, F, G, E açýk
--    "00000000", -- 16: Blank (Tüm segmentler kapalý)
--    "11111111"  -- 17: Tüm segmentler ve dot açýk

    
);


begin
------- PORT MAP -----
--PC : t02_Word_PC 
--    port map(
--        RST => S_RST ,
--        CLK => S_CLK ,
--        next_PC => S_next_PC ,
--        current_pc => S_current_pc 
--    );

process (Xclk) begin
    
    if (rising_edge(Xclk) ) then 
        if (BTN_topdeb(2) = '1') then
            LED_top <= SW_topdeb ;
        else 
            LED_top <= x"0000" ;
        end if ;
    end if ;
end process ;


process ( Xclk ) begin 
    if (rising_edge(Xclk) ) then 
        counter <= std_logic_vector( unsigned(counter ) + unsigned(one) );
        
        if(counter = X"f" ) then 
            segment_counter <= std_logic_vector( unsigned(segment_counter ) + unsigned(one) );
            case ( segment_counter(1 downto 0) ) is 
            when "00" =>
                SEGMENT4_top <= X"1";
                --SEGMENT7_top <= not ROM7seg( 4 );
                SEGMENT7_top <= not ROM7seg( to_integer(unsigned( SW_topdeb(3 downto 0) )) );
            when "01" =>
                SEGMENT4_top <= X"2";
                --SEGMENT7_top <= not ROM7seg( 7 );
                SEGMENT7_top <= not ROM7seg( to_integer(unsigned( SW_topdeb(7 downto 4) )) );
            when "10" =>
                SEGMENT4_top <= X"4";
                --SEGMENT7_top <= not ROM7seg( 10 );
                SEGMENT7_top <= not ROM7seg( to_integer(unsigned( SW_topdeb(11 downto 8) )) );
            when "11" =>
                SEGMENT4_top <= X"8";
                --SEGMENT7_top <= not ROM7seg( 14 );
                SEGMENT7_top <= not ROM7seg( to_integer(unsigned( SW_topdeb(15 downto 12) )) );
            when others =>
                SEGMENT4_top <= X"1";
                SEGMENT7_top <= not ROM7seg( 17 );
            end case ;
        end if;
        
    end if ;
    


end process ;










end Behavioral;
