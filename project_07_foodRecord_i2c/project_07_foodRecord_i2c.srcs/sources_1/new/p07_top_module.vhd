library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.food_definitions_pkg.all;

entity p07_top_module is
    port (
        -- Clock and Reset
        CLK100MHZ       : in  std_logic; -- Veya kartýnýzdaki clock adý (örn: CLK_SYS)
        CPU_RESETN      : in  std_logic; -- Aktif düþük reset (örn: BTNC)

        -- Switches for food ID (4-bit example)
        SW              : in  std_logic_vector(3 downto 0); -- SW0-SW3

        -- Button for triggering display update
        BTN_TRIGGER     : in  std_logic; -- Bir buton (örn: BTNU)

        -- I2C OLED Connections
        OLED_SCL        : out std_logic;
        OLED_SDA_O      : out std_logic; -- p05_mba_I2C'den gelen sda_o
        OLED_SDA_I      : in  std_logic  -- p05_mba_I2C'ye giden sda_i
                                         -- Gerçekte SDA bidirectionaldýr, FPGA pinine tri-state buffer ile baðlanýr.
                                         -- p05_mba_I2C bunu kendi içinde hallediyor olmalý.
                                         -- Basitlik adýna, eðer p05_mba_I2C sda_o ve sda_i ayrý ise böyle býrakýlýr.
                                         -- Eðer tek bir sda pini varsa, top level'da tri-state yönetimi gerekir.
                                         -- p05_mba_I2C.vhd'nin portlarýna bakarak bunu netleþtirmek lazým.
                                         -- Genelde sda_o ve sda_i birleþtirilip tek bir 'sda' portu yapýlýr.
                                         -- p05_mba_I2C'nin portlarý: scl, sda_o, sda_i. Bu yüzden ayrý býrakýyorum.
    );
end entity p07_top_module;

architecture behavioral of p07_top_module is

    signal reset_n_internal : std_logic;
    signal clk_internal     : std_logic;

    -- food_id and cost (cost þimdilik sabit bir deðer olabilir)
    signal s_selected_food_id   : food_id_t;
    signal s_food_cost_bcd      : unsigned(15 downto 0) := X"0125"; -- Örnek: $01.25

    -- Trigger pulse for oled_content_sequencer
    signal s_trigger_display_update : std_logic;
    signal s_trigger_display_update_debounced : std_logic;
    signal s_trigger_prev : std_logic := '0';


    -- oled_content_sequencer signals
    signal s_sequencer_busy         : std_logic;
    signal s_output_char            : character;
    signal s_output_char_valid      : std_logic;
    signal s_target_oled_page       : integer range 0 to 7;
    signal s_clear_oled_page_cmd    : std_logic;
    signal s_char_data_ack_to_seq   : std_logic; -- oled_i2c_controller'dan gelen ack
    signal s_oled_module_busy_to_seq: std_logic; -- oled_i2c_controller'dan gelen busy

    -- oled_i2c_controller signals (p05_mba_I2C'ye gidenler)
    signal s_i2c_address         : std_logic_vector(6 downto 0);
    signal s_i2c_rw              : std_logic;
    signal s_i2c_data_wr         : std_logic_vector(7 downto 0);
    signal s_i2c_start_transaction : std_logic;
    -- oled_i2c_controller signals (p05_mba_I2C'den gelenler)
    signal s_i2c_transaction_ack : std_logic;
    signal s_i2c_busy            : std_logic;
    signal s_i2c_ack_error       : std_logic;
    signal s_i2c_data_rd         : std_logic_vector(7 downto 0); -- p05_mba_I2C'den, bu projede kullanýlmýyor


    -- p05_mba_I2C instance
    component p05_mba_I2C
        port (
            clk             : in  std_logic;
            reset_n         : in  std_logic;
            scl             : out std_logic;
            sda_o           : out std_logic;
            sda_i           : in  std_logic;
            address         : in  std_logic_vector(6 downto 0);
            rw              : in  std_logic;
            data_wr         : in  std_logic_vector(7 downto 0);
            data_rd         : out std_logic_vector(7 downto 0);
            start_transaction : in  std_logic;
            transaction_ack : out std_logic;
            busy            : out std_logic;
            ack_error       : out std_logic
        );
    end component p05_mba_I2C;

    -- oled_content_sequencer instance
    component p07_oled_content_sequencer
        port (
            clk                    : in  std_logic;
            reset_n                : in  std_logic;
            trigger_display_update : in  std_logic;
            selected_food_id       : in  food_id_t;
            selected_food_cost_bcd : in  unsigned(15 downto 0);
            char_data_ack          : in  std_logic;
            oled_module_busy       : in  std_logic;
            sequencer_busy         : out std_logic;
            output_char            : out character;
            output_char_valid      : out std_logic;
            target_oled_page       : out integer range 0 to 7;
            clear_oled_page_cmd    : out std_logic
        );
    end component p07_oled_content_sequencer;

    -- oled_i2c_controller instance
    component p07_oled_i2c_controller
        port (
            clk                     : in  std_logic;
            reset_n                 : in  std_logic;
            sequencer_char_in       : in  character;
            sequencer_char_valid    : in  std_logic;
            sequencer_target_page   : in  integer range 0 to 7;
            sequencer_clear_page_cmd: in  std_logic;
            sequencer_char_ack      : out std_logic;
            sequencer_busy_out      : out std_logic;
            i2c_address_out         : out std_logic_vector(6 downto 0);
            i2c_rw_out              : out std_logic;
            i2c_data_wr_out         : out std_logic_vector(7 downto 0);
            i2c_start_transaction_out: out std_logic;
            i2c_transaction_ack_in  : in  std_logic;
            i2c_busy_in             : in  std_logic;
            i2c_ack_error_in        : in  std_logic
        );
    end component p07_oled_i2c_controller;

    -- Basit bir debounce devresi BTN_TRIGGER için (opsiyonel ama önerilir)
    component p07_debounce
      generic (
        CLK_FREQ_HZ     : integer := 100_000_000; -- Clock frequency in Hz
        STABLE_TIME_MS  : integer := 20           -- Stable time in ms
      );
      port (
        clk_i           : in  std_logic;
        reset_n_i       : in  std_logic;
        button_in_i     : in  std_logic;
        button_out_o    : out std_logic
      );
    end component p07_debounce;
    signal s_btn_trigger_raw : std_logic;


begin
    clk_internal <= CLK100MHZ;
    reset_n_internal <= CPU_RESETN; -- Aktif düþük reset ise doðrudan baðlanýr

    s_selected_food_id <= unsigned(SW); -- Switch'lerden food_id al

    -- Trigger butonu için debounce (eðer bir debounce modülünüz varsa kullanýn)
    -- Örnek debounce modülü instantiate edilebilir:
    debounce_inst : p07_debounce
      generic map (
          CLK_FREQ_HZ => 100_000_000, -- CLK100MHZ frekansýný girin
          STABLE_TIME_MS => 20
      )
      port map (
          clk_i        => clk_internal,
          reset_n_i    => reset_n_internal,
          button_in_i  => BTN_TRIGGER, -- Ham buton giriþi
          button_out_o => s_trigger_display_update_debounced -- Debounce edilmiþ çýkýþ
      );

    -- Debounce edilmiþ butondan pulse üretme
    process(clk_internal)
    begin
        if rising_edge(clk_internal) then
            s_trigger_prev <= s_trigger_display_update_debounced;
            if s_trigger_prev = '0' and s_trigger_display_update_debounced = '1' then
                s_trigger_display_update <= '1';
            else
                s_trigger_display_update <= '0';
            end if;
        end if;
    end process;


    -- Modül instantiate'leri
    sequencer_inst : p07_oled_content_sequencer
        port map (
            clk                    => clk_internal,
            reset_n                => reset_n_internal,
            trigger_display_update => s_trigger_display_update,
            selected_food_id       => s_selected_food_id,
            selected_food_cost_bcd => s_food_cost_bcd,
            char_data_ack          => s_char_data_ack_to_seq,
            oled_module_busy       => s_oled_module_busy_to_seq,
            sequencer_busy         => s_sequencer_busy,
            output_char            => s_output_char,
            output_char_valid      => s_output_char_valid,
            target_oled_page       => s_target_oled_page,
            clear_oled_page_cmd    => s_clear_oled_page_cmd
        );

    i2c_ctrl_inst : p07_oled_i2c_controller
        port map (
            clk                     => clk_internal,
            reset_n                 => reset_n_internal,
            sequencer_char_in       => s_output_char,
            sequencer_char_valid    => s_output_char_valid,
            sequencer_target_page   => s_target_oled_page,
            sequencer_clear_page_cmd=> s_clear_oled_page_cmd,
            sequencer_char_ack      => s_char_data_ack_to_seq,
            sequencer_busy_out      => s_oled_module_busy_to_seq,
            i2c_address_out         => s_i2c_address,       -- Bu aslýnda sabit OLED_I2C_SLAVE_ADDR olacak
            i2c_rw_out              => s_i2c_rw,            -- Bu aslýnda '0' olacak
            i2c_data_wr_out         => s_i2c_data_wr,
            i2c_start_transaction_out=> s_i2c_start_transaction,
            i2c_transaction_ack_in  => s_i2c_transaction_ack,
            i2c_busy_in             => s_i2c_busy,
            i2c_ack_error_in        => s_i2c_ack_error
        );

    i2c_master_inst : p05_mba_I2C
        port map (
            clk             => clk_internal,
            reset_n         => reset_n_internal,
            scl             => OLED_SCL,
            sda_o           => OLED_SDA_O,
            sda_i           => OLED_SDA_I,
            address         => s_i2c_address, -- oled_i2c_controller'dan gelir (aslýnda sabit)
            rw              => s_i2c_rw,      -- oled_i2c_controller'dan gelir (aslýnda '0')
            data_wr         => s_i2c_data_wr, -- oled_i2c_controller'dan gelir
            data_rd         => s_i2c_data_rd, -- Bu projede okunmuyor
            start_transaction => s_i2c_start_transaction, -- oled_i2c_controller'dan gelir
            transaction_ack => s_i2c_transaction_ack,
            busy            => s_i2c_busy,
            ack_error       => s_i2c_ack_error
        );

end architecture behavioral;