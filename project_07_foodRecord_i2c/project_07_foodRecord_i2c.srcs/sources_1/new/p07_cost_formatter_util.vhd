library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.food_definitions_pkg.all;

entity p07_cost_formatter_util is
    port (
        -- Assuming BCD input for $XX.YY (e.g., tens_dollars, units_dollars, tens_cents, units_cents)
        -- Each BCD digit is 4 bits. Example: 16 bits for $99.99
        -- bcd_dollars_tens : in unsigned(3 downto 0); -- e.g. for $10-$90 part
        -- bcd_dollars_units: in unsigned(3 downto 0); -- e.g. for $1-$9 part
        -- bcd_cents_tens   : in unsigned(3 downto 0); -- e.g. for .10-.90 part
        -- bcd_cents_units  : in unsigned(3 downto 0); -- e.g. for .01-.09 part
        cost_bcd_in        : in unsigned(15 downto 0); -- Packed: DDdd (DollarsTens, DollarsUnits, CentsTens, CentsUnits)
        cost_str_out       : out string_t
    );
end entity p07_cost_formatter_util;

architecture behavioral of p07_cost_formatter_util is

    function bcd_to_char(digit: unsigned(3 downto 0)) return character is
    begin
        case digit is
            when "0000" => return '0';
            when "0001" => return '1';
            when "0010" => return '2';
            when "0011" => return '3';
            when "0100" => return '4';
            when "0101" => return '5';
            when "0110" => return '6';
            when "0111" => return '7';
            when "1000" => return '8';
            when "1001" => return '9';
            when others => return 'X'; -- Error
        end case;
    end function bcd_to_char;

begin
    process(cost_bcd_in)
        variable temp_str : string_t := (others => ' ');
        variable dollars_tens_digit  : unsigned(3 downto 0);
        variable dollars_units_digit : unsigned(3 downto 0);
        variable cents_tens_digit    : unsigned(3 downto 0);
        variable cents_units_digit   : unsigned(3 downto 0);
    begin
        dollars_tens_digit  := cost_bcd_in(15 downto 12);
        dollars_units_digit := cost_bcd_in(11 downto 8);
        cents_tens_digit    := cost_bcd_in(7 downto 4);
        cents_units_digit   := cost_bcd_in(3 downto 0);

        temp_str := (others => ' '); -- Clear previous
        temp_str(0) := '$';
        temp_str(1) := bcd_to_char(dollars_tens_digit);
        temp_str(2) := bcd_to_char(dollars_units_digit);
        temp_str(3) := '.';
        temp_str(4) := bcd_to_char(cents_tens_digit);
        temp_str(5) := bcd_to_char(cents_units_digit);
        -- Remaining characters in temp_str are spaces by default initialization.

        cost_str_out <= temp_str;
    end process;

end architecture behavioral;


