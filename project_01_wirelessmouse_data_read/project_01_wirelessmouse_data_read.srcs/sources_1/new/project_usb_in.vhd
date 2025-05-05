----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2024 12:37:03
-- Design Name: 
-- Module Name: project_usb_in - Behavioral
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

entity project_usb_in is
    Generic(
        multiplication_cycle : integer := 500;
        X_clk : integer := 1_000_000        
    );
    Port(
        clk_fpga : in std_logic := '0' ;
        mous_clk : in std_logic := '0' ;
        mous_data : in std_logic_vector(32 downto 0) := (others =>'0') ;
        led_8_0 : out std_logic_vector(7 downto 0) := (others =>'0');
        led_8_1 : out std_logic_vector(7 downto 0) := (others =>'0')
        
    );
end project_usb_in;

architecture Behavioral of project_usb_in is

signal magnidude : std_logic_vector(19 downto 0);
shared variable  clk_fpga_counter : integer range 0 to multiplication_cycle := 0;

begin

process (clk_fpga) begin
    if (rising_edge(clk_fpga)) then
    clk_fpga_counter := clk_fpga_counter + 1 ;
        if( clk_fpga_counter = multiplication_cycle ) then
        clk_fpga_counter := 0;
        
        
        end if;
    end if;
    
end process;


end Behavioral;
