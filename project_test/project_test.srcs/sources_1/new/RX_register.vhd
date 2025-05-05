----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.10.2024 22:12:21
-- Design Name: 
-- Module Name: RX_register - Behavioral
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

entity RX_register is
    Generic(
        X_clk : integer := 100_000_000;
        baudrate : integer := 9600
        );
    Port ( 
            clk : in STD_LOGIC := '0';
            rx_in : in STD_LOGIC := '0';
            RX_serial : out std_logic_vector(7 downto 0) := X"00"
            
          );
end RX_register;

architecture Behavioral of RX_register is
constant baud_timer : integer := X_clk/baudrate ;
type rx_state_type is ( RDY , STRT ,RECEIVE , WAITING, CHECK);

type rom_type is array (0 to 255) of bit_vector(7 downto 0 ) ;
signal ROM : rom_type  ;
--
-- x"FFFFFFFF" ,
-- x"FFFFF620" ,
--
signal S_state : rx_state_type := RDY ;
signal S_ready : STD_LOGIC := '0' ;
signal S_timer : integer  := 0;
signal S_bit_index  : integer range 0 to 8 := 0;
signal S_rx_data : std_logic_vector(8 downto 0) := (others =>'0');

signal parity:  STD_LOGIC := '0';
signal ready :  STD_LOGIC := '0';
signal error :  STD_LOGIC := '0';

begin
ready <= S_ready;

process (clk  )begin
    if rising_edge(clk) then
    case  S_state is
        when RDY => 
            if rx_in = '0' then
                S_state <= STRT;
                S_bit_index <= 0;
            end if;
        when STRT => 
            if S_timer = baudrate/2 then 
                S_state <= WAITING;
                S_timer <= 0;
                error <= '0';
                S_ready <= '0';
            else
                S_timer <= S_timer +1;
            end if ;
        when WAITING => 
            if S_timer = baud_timer then
            S_timer <= 0;
            if S_ready ='1' then S_state <= RDY;
            else S_state <= RECEIVE;
            end if ;
            else S_timer <= S_timer +1;
            end if ;
        when RECEIVE => 
            S_rx_data(S_bit_index) <= rx_in;
            S_bit_index <= S_bit_index + 1;
            if (S_bit_index = 8) then 
                S_state <= CHECK;
            else S_state <= WAITING;
            end if ;
        when CHECK => 
            if ( (S_rx_data(0) xor S_rx_data(1) xor S_rx_data(2) xor S_rx_data(3) xor
     S_rx_data(4) xor S_rx_data(5) xor S_rx_data(6) xor S_rx_data(7)) = S_rx_data(8) ) then
                S_ready <= '1';
                S_state <= WAITING;
                error <= '0';
                RX_serial <= rx_in & S_rx_data(6 downto 0);
                parity <= S_rx_data(8);
                else
                S_ready <= '1';
                RX_serial <= (others =>'1');
                error <= '1';
                S_state <= RDY;
            end if;
            
    end case ;
    end if; 
end process; 
  


end Behavioral;
