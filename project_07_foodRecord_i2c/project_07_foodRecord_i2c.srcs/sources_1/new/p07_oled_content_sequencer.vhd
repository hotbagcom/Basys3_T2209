library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.food_definitions_pkg.all;

entity p07_oled_content_sequencer is
    port (
        clk                    : in  std_logic;
        reset_n                : in  std_logic;
        trigger_display_update : in  std_logic; -- Pulse to start/refresh
        selected_food_id       : in  food_id_t;
        selected_food_cost_bcd : in  unsigned(15 downto 0); -- $XX.YY

        -- Interface to character rendering/I2C module
        char_data_ack          : in  std_logic; -- ACK that character was processed
        oled_module_busy       : in  std_logic; -- Indicates if the char renderer/I2C is busy with a command (like clear)

        sequencer_busy         : out std_logic;
        output_char            : out character;
        output_char_valid      : out std_logic;
        target_oled_page       : out integer range 0 to 7;
        clear_oled_page_cmd    : out std_logic  -- Assert high to command a page clear
    );
end entity p07_oled_content_sequencer;

architecture behavioral of p07_oled_content_sequencer is

    type state_t is (
        S_IDLE,
        S_FETCH_DATA,

        S_PAGE_SETUP,         -- Generic setup state for any page
        S_PAGE_CLEAR_CMD,     -- Issue clear command
        S_PAGE_CLEAR_WAIT,    -- Wait for clear command to be processed by OLED module
        S_PAGE_SEND_CHAR,
        S_PAGE_WAIT_CHAR_ACK,
        S_PAGE_DONE,          -- Check if string is done, or if it's an empty page

        S_ALL_PAGES_DONE
    );
    signal current_state, next_state : state_t;

    signal internal_food_id       : food_id_t;
    signal internal_food_cost_bcd : unsigned(15 downto 0);

    signal food_type_s      : string_t;
    signal food_origin_s    : string_t;
    signal food_name_s      : string_t;
    signal food_cost_s      : string_t;
    signal empty_string_s   : string_t := (others => ' '); -- For empty pages

    signal current_string_to_display : string_t;
    signal char_index                : integer range 0 to MAX_STRING_LENGTH; -- Tracks current char in string
    signal current_page_to_write     : integer range 0 to 7;

    signal start_pulse_detected : std_logic;
    signal prev_trigger_display_update : std_logic := '0';


    -- Component instantiations
    component p07_food_data_provider
        port (
            food_id_in             : in  food_id_t;
            food_type_str_out      : out string_t;
            food_origin_str_out    : out string_t;
            actual_food_name_str_out : out string_t
        );
    end component p07_food_data_provider;

    component p07_cost_formatter_util
        port (
            cost_bcd_in  : in  unsigned(15 downto 0);
            cost_str_out : out string_t
        );
    end component p07_cost_formatter_util;

begin

    fdp_inst : p07_food_data_provider
        port map (
            food_id_in             => internal_food_id,
            food_type_str_out      => food_type_s,
            food_origin_str_out    => food_origin_s,
            actual_food_name_str_out => food_name_s
        );

    cfu_inst : p07_cost_formatter_util
        port map (
            cost_bcd_in  => internal_food_cost_bcd,
            cost_str_out => food_cost_s
        );

    -- Edge detection for trigger_display_update
    process(clk)
    begin
        if rising_edge(clk) then
            prev_trigger_display_update <= trigger_display_update;
            if prev_trigger_display_update = '0' and trigger_display_update = '1' then
                start_pulse_detected <= '1';
            else
                start_pulse_detected <= '0';
            end if;
        end if;
    end process;

    -- State machine logic
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            current_state           <= S_IDLE;
            sequencer_busy          <= '0';
            output_char_valid       <= '0';
            clear_oled_page_cmd     <= '0';
            output_char             <= ' ';
            target_oled_page        <= 0;
            char_index              <= 0;
            current_page_to_write   <= 0;
            internal_food_id        <= (others => '0');
            internal_food_cost_bcd  <= (others => '0');
            current_string_to_display <= empty_string_s;
        elsif rising_edge(clk) then
            current_state <= next_state;

            -- Default outputs
            output_char_valid   <= '0';
            clear_oled_page_cmd <= '0';
            sequencer_busy      <= '1'; -- Busy by default unless in IDLE

            case current_state is
                when S_IDLE =>
                    sequencer_busy <= '0';
                    if start_pulse_detected = '1' then
                        internal_food_id       <= selected_food_id;
                        internal_food_cost_bcd <= selected_food_cost_bcd;
                        current_page_to_write  <= 0;
                        next_state             <= S_FETCH_DATA;
                    else
                        next_state <= S_IDLE;
                    end if;

                when S_FETCH_DATA => -- Data from FDP and CFU will be valid in next cycle
                    next_state <= S_PAGE_SETUP;

                when S_PAGE_SETUP =>
                    char_index <= 0; -- Reset for new string
                    target_oled_page <= current_page_to_write;
                    case current_page_to_write is
                        when 0 => current_string_to_display <= food_type_s;
                        when 1 => current_string_to_display <= empty_string_s; -- Page 1 is empty
                        when 2 => current_string_to_display <= food_origin_s;
                        when 3 => current_string_to_display <= empty_string_s; -- Page 3 is empty
                        when 4 => current_string_to_display <= food_name_s;
                        when 5 => current_string_to_display <= empty_string_s; -- Page 5 is empty
                        when 6 => current_string_to_display <= food_cost_s;
                        when 7 => current_string_to_display <= empty_string_s; -- Page 7 is empty
                        when others => current_string_to_display <= empty_string_s;
                    end case;
                    clear_oled_page_cmd <= '1'; -- Signal to clear the page
                    next_state          <= S_PAGE_CLEAR_CMD;

                when S_PAGE_CLEAR_CMD =>
                    clear_oled_page_cmd <= '0'; -- Pulse was for one cycle
                    if oled_module_busy = '0' then -- Wait if OLED module is busy from previous command
                        next_state <= S_PAGE_CLEAR_WAIT;
                    else
                        next_state <= S_PAGE_CLEAR_CMD; -- Keep waiting
                    end if;
                    
                when S_PAGE_CLEAR_WAIT =>
                    if oled_module_busy = '0' then
                         next_state <= S_PAGE_DONE; -- Proceed to check if we need to send chars
                    else
                         next_state <= S_PAGE_CLEAR_WAIT; -- Wait for clear to finish
                    end if;

                when S_PAGE_SEND_CHAR =>
                    if char_index < MAX_STRING_LENGTH and current_string_to_display(char_index) /= ' ' then -- Send char if not space padding
                        output_char       <= current_string_to_display(char_index);
                        output_char_valid <= '1';
                        next_state        <= S_PAGE_WAIT_CHAR_ACK;
                    else -- End of string or only spaces left
                        next_state <= S_PAGE_DONE;
                    end if;

                when S_PAGE_WAIT_CHAR_ACK =>
                    if char_data_ack = '1' then
                        char_index <= char_index + 1;
                        next_state <= S_PAGE_SEND_CHAR; -- Try to send next char
                    else
                        next_state <= S_PAGE_WAIT_CHAR_ACK;
                    end if;

                when S_PAGE_DONE =>
                    -- Check if current page is one that should be empty or if string is actually empty/done
                    if current_page_to_write = 1 or current_page_to_write = 3 or
                       current_page_to_write = 5 or current_page_to_write = 7 or
                       char_index >= MAX_STRING_LENGTH or
                       current_string_to_display(char_index) = ' ' then -- Reached end of meaningful content

                        if current_page_to_write < 7 then
                            current_page_to_write <= current_page_to_write + 1;
                            next_state            <= S_PAGE_SETUP; -- Setup for next page
                        else
                            next_state <= S_ALL_PAGES_DONE;
                        end if;
                    else
                        -- There are characters to send for this page (this path is mainly for non-empty pages)
                        next_state <= S_PAGE_SEND_CHAR;
                    end if;


                when S_ALL_PAGES_DONE =>
                    next_state <= S_IDLE;

                when others =>
                    next_state <= S_IDLE;
            end case;
        end if;
    end process;

end architecture behavioral;

