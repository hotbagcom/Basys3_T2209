library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package food_definitions_pkg is

    constant MAX_STRING_LENGTH  : integer := 16; -- Max characters per OLED line/page
    constant NUM_FOOD_ITEMS     : integer := 10; -- Number of predefined food items

    -- Define a subtype for food IDs (adjust size as needed)
    subtype food_id_t is unsigned(3 downto 0); -- Allows up to 16 food items

    -- Define a string type for display text
    type string_t is array (0 to MAX_STRING_LENGTH - 1) of character;

    -- Define arrays for food properties (these will be in food_data_provider)
    -- Example food IDs (can be mapped to enums or constants if preferred)
    constant FOOD_ID_MINERAL_WATER : food_id_t := "0000";
    constant FOOD_ID_COFFEE        : food_id_t := "0001";
    constant FOOD_ID_TEA           : food_id_t := "0010";
    constant FOOD_ID_SPINACH       : food_id_t := "0011";
    constant FOOD_ID_CUCUMBER      : food_id_t := "0100";
    constant FOOD_ID_CHERRY        : food_id_t := "0101";
    constant FOOD_ID_NUT           : food_id_t := "0110";
    constant FOOD_ID_PEANUT        : food_id_t := "0111";
    constant FOOD_ID_BISCUITS      : food_id_t := "1000";
    constant FOOD_ID_COOKIE        : food_id_t := "1001";

    -- Helper function to convert string to string_t (padding with spaces)
    function to_string_t(s : string) return string_t;
    function to_char_array(s : string; len : positive) return string_t; -- Alternative helper

end package food_definitions_pkg;

package body food_definitions_pkg is

    function to_string_t(s : string) return string_t is
        variable result : string_t := (others => ' '); -- Initialize with spaces
    begin
        for i in s'range loop
            if i-s'low < MAX_STRING_LENGTH then
                result(i-s'low) := s(i);
            end if;
        end loop;
        return result;
    end function to_string_t;

    function to_char_array(s : string; len : positive) return string_t is
        variable res_v : string_t := (others => ' '); -- Default to space
    begin
        if s'length > len then
            for i in 0 to len-1 loop
                res_v(i) := s(s'left+i);
            end loop;
        else
            for i in 0 to s'length-1 loop
                res_v(i) := s(s'left+i);
            end loop;
        end if;
        return res_v;
    end function to_char_array;

end package body food_definitions_pkg;