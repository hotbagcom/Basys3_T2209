library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.food_definitions_pkg.all;

entity p07_food_data_provider is
    port (
        food_id_in             : in  food_id_t;
        food_type_str_out      : out string_t;
        food_origin_str_out    : out string_t;
        actual_food_name_str_out : out string_t
    );
end entity p07_food_data_provider;

architecture behavioral of p07_food_data_provider is
begin

    process(food_id_in)
    begin
        -- Default to empty strings (padded with spaces)
        food_type_str_out      <= (others => ' ');
        food_origin_str_out    <= (others => ' ');
        actual_food_name_str_out <= (others => ' ');

        case food_id_in is
            when FOOD_ID_MINERAL_WATER =>
                food_type_str_out      <= to_string_t("COLD DRINK");
                food_origin_str_out    <= to_string_t("LOCAL");
                actual_food_name_str_out <= to_string_t("MINERAL WATER");
            when FOOD_ID_COFFEE =>
                food_type_str_out      <= to_string_t("HOT DRINK");
                food_origin_str_out    <= to_string_t("IMPORT");
                actual_food_name_str_out <= to_string_t("COFFEE");
            when FOOD_ID_TEA =>
                food_type_str_out      <= to_string_t("HOT DRINK");
                food_origin_str_out    <= to_string_t("LOCAL");
                actual_food_name_str_out <= to_string_t("TEA");
            when FOOD_ID_SPINACH =>
                food_type_str_out      <= to_string_t("VEGETABLE");
                food_origin_str_out    <= to_string_t("LOCAL");
                actual_food_name_str_out <= to_string_t("SPINACH");
            when FOOD_ID_CUCUMBER =>
                food_type_str_out      <= to_string_t("VEGETABLE");
                food_origin_str_out    <= to_string_t("LOCAL");
                actual_food_name_str_out <= to_string_t("CUCUMBER");
            when FOOD_ID_CHERRY =>
                food_type_str_out      <= to_string_t("FRUIT");
                food_origin_str_out    <= to_string_t("LOCAL");
                actual_food_name_str_out <= to_string_t("CHERRY");
            when FOOD_ID_NUT =>
                food_type_str_out      <= to_string_t("SNACK");
                food_origin_str_out    <= to_string_t("IMPORT");
                actual_food_name_str_out <= to_string_t("NUT");
            when FOOD_ID_PEANUT =>
                food_type_str_out      <= to_string_t("SNACK");
                food_origin_str_out    <= to_string_t("LOCAL");
                actual_food_name_str_out <= to_string_t("PEANUT");
            when FOOD_ID_BISCUITS =>
                food_type_str_out      <= to_string_t("SNACK");
                food_origin_str_out    <= to_string_t("IMPORT");
                actual_food_name_str_out <= to_string_t("BISCUITS");
            when FOOD_ID_COOKIE =>
                food_type_str_out      <= to_string_t("SNACK");
                food_origin_str_out    <= to_string_t("LOCAL");
                actual_food_name_str_out <= to_string_t("COOKIE");

            when others =>
                food_type_str_out      <= to_string_t("UNKNOWN TYPE");
                food_origin_str_out    <= to_string_t("UNKNOWN ORIGIN");
                actual_food_name_str_out <= to_string_t("UNKNOWN FOOD");
        end case;
    end process;

end architecture behavioral;

