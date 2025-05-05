----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2025 14:11:00
-- Design Name: 
-- Module Name: userinterface_module - Behavioral
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

entity userinterface_module is
 Generic(
        X_clkHz : integer := 100_000_000;
        maxsevensinglecounter : integer:= 500_000;
        debounce_max : integer := 1_000_000 
        
    );
Port (
        Xclk : in std_logic ;
        
        BTN_top :  in std_logic_vector(4 downto 0) ;
        SW_top : in std_logic_vector(15 downto 0) ;
        
        
        
        LED_top : out  std_logic_vector( 15 downto 0 )  := X"0000" ;
        
        SEGMENT4_top :  out std_logic_vector(3 downto 0) := X"1" ;
        SEGMENT7_top  : out std_logic_vector(7 downto 0) := X"00" 
    
    );
end userinterface_module;

architecture Behavioral of userinterface_module is

signal debounce_cntr :integer range 0 to debounce_max := 0;
signal input_circle : std_logic_vector( 20 downto 0 ) := (others => '0') ;
signal input_circle_status : std_logic_vector( 20 downto 0 ) := (others => '0') ;
signal cycle_counter : integer range 0 to 22  := 0 ;

signal S_BTN_topdeb :   std_logic_vector(4 downto 0) ;
signal S_SW_topdeb :  std_logic_vector(15 downto 0) ;

signal toggleconvert :  std_logic := '0';



signal sevenouter4index  :std_logic_vector( 3 downto 0) := X"0" ;
signal minicounter : integer range 0 to maxsevensinglecounter+50 := 0 ;
signal one : std_logic_vector(1 downto 0) := "01";
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

process (Xclk ) begin
LED_top <= S_SW_topdeb ;
--    if (rising_edge(Xclk) ) then 
--        if (toggleconvert = '1') then  
            
--          end if ;
--        if (S_BTN_topdeb(0) = '1') then
--            toggleconvert <= not toggleconvert ;

--        else 
--            LED_top <= x"0000" ;
--        end if ;
--    end if ;
end process ;



process ( Xclk    ) begin 

----                SEGMENT4_top <= S_SW_topdeb(15 downto 12);
----                --SEGMENT7_top <= not ROM7seg( 1 );
----                SEGMENT7_top <= not ROM7seg( to_integer(unsigned( S_SW_topdeb(3 downto 0) )) );



--    if (rising_edge(Xclk) ) then 
      
        
--        if(counter >= X"f" ) then 
--        counter<= x"0";
--            segment_counter <= std_logic_vector( unsigned(segment_counter ) + unsigned(one) );
--            case ( segment_counter(1 downto 0) ) is 
--            when "00" =>
--                SEGMENT4_top <= X"1";
--SEGMENT7_top <= not ROM7seg( to_integer(unsigned( S_SW_topdeb(3 downto 0) )) );
--            when "01" =>
--                SEGMENT4_top <= X"2";
--                --SEGMENT7_top <= not ROM7seg( 7 );
--                SEGMENT7_top <= not ROM7seg( 7 );
----SEGMENT7_top <= not ROM7seg( to_integer(unsigned( S_SW_topdeb(7 downto 4) )) );
                
--            when "10" =>
--                SEGMENT4_top <= X"4";
--                --SEGMENT7_top <= not ROM7seg( 10 );
--                SEGMENT7_top <= not ROM7seg( 10 );
----SEGMENT7_top <= not ROM7seg( to_integer(unsigned( S_SW_topdeb(11 downto 8) )) );
--            when "11" =>
--                SEGMENT4_top <= X"8";
--                --SEGMENT7_top <= not ROM7seg( 14 );
--                SEGMENT7_top <= not ROM7seg( 14 );
----SEGMENT7_top <= not ROM7seg( to_integer(unsigned( S_SW_topdeb(15 downto 12) )) );
--            when others =>
--                SEGMENT4_top <= X"1";
--                SEGMENT7_top <= not ROM7seg( 15 );
--            end case ;
            
--        else 
--          counter <= std_logic_vector( unsigned(counter ) + unsigned(one) );
--        end if;
        
--    end if ;
    

    if (rising_edge(Xclk) ) then 

        if (minicounter >= maxsevensinglecounter) then  --maxsevensinglecounter = 5_000_100
        minicounter <= 0;
        sevenouter4index <= std_logic_vector( unsigned(sevenouter4index ) + unsigned(one) );
        else 
        minicounter <= minicounter + 1 ;

            if (sevenouter4index(1 downto 0) = "00" ) then
                SEGMENT4_top <= not X"1";
                SEGMENT7_top <= not ROM7seg(  to_integer(unsigned( S_SW_topdeb(3 downto 0) )));
            elsif (sevenouter4index(1 downto 0) = "01" ) then
                SEGMENT4_top <= not X"2";
                SEGMENT7_top <= not ROM7seg(  to_integer(unsigned( S_SW_topdeb(7 downto 4) )));
            elsif (sevenouter4index(1 downto 0) = "10"  ) then
                SEGMENT4_top <= not X"4";
                SEGMENT7_top <= not ROM7seg(  to_integer(unsigned( S_SW_topdeb(11 downto 8) )));
            elsif (sevenouter4index(1 downto 0) = "11"  ) then
                SEGMENT4_top <= not X"8";
                SEGMENT7_top <= not ROM7seg( to_integer(unsigned( S_SW_topdeb(15 downto 12) )));
           
            end if;
       end if; 
   end if;        











end process ;

process ( Xclk ) begin 
    input_circle <= BTN_top & SW_top ;
    
 
    
    if rising_edge(Xclk) then 
        if cycle_counter >= 20 then 
        cycle_counter <= 0;
            if debounce_cntr < debounce_max then
                debounce_cntr <= debounce_cntr +1 ;
            elsif debounce_cntr >= debounce_max then
                debounce_cntr <= 0 ;
                input_circle_status(20) <= input_circle(20) ;
            end if ;
        elsif cycle_counter < 20 then 
        
            
        cycle_counter <= cycle_counter + 1 ;
            if debounce_cntr < debounce_max then
                debounce_cntr <= debounce_cntr +1 ;
            elsif debounce_cntr >= debounce_max then
                debounce_cntr <= 0 ;
                input_circle_status(cycle_counter) <= input_circle(cycle_counter) ;
            end if ;
        end if ;
    end if ;
    S_BTN_topdeb <= input_circle_status( 20 downto 16 ); -- input_circle( 20 downto 16 ); -- 
    S_SW_topdeb <=  input_circle_status( 15 downto 0 );  --input_circle( 15 downto 0 ); --
    
end process ;

end Behavioral;
