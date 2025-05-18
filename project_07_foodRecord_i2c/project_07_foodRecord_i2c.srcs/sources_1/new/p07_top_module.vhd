library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.food_definitions_pkg.all;

entity p07_top_module is
    port (
        -- Clock and Reset
        CLK100MHZ      : in  std_logic;
        CPU_RESETN     : in  std_logic;

        -- Switches for food ID (4-bit example)
        SW             : in  std_logic_vector(3 downto 0);

        -- Button for triggering display update
        BTN_TRIGGER    : in  std_logic;

        -- I2C OLED Connections
        OLED_SCL       : inout std_logic; -- Düzeltildi: INOUT
        OLED_SDA       : inout std_logic  -- Düzeltildi: Tek INOUT portu
    );
end entity p07_top_module;

architecture behavioral of p07_top_module is

    signal reset_n_internal : std_logic;
    signal clk_internal     : std_logic;

    -- food_id and cost
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
    signal s_char_data_ack_to_seq   : std_logic;
    signal s_oled_module_busy_to_seq: std_logic;

    -- Signals connecting oled_i2c_controller to p05_mba_I2C
    -- These names are based on p07_oled_i2c_controller's perspective
    signal s_i2c_ctrl_address           : std_logic_vector(6 downto 0);
    signal s_i2c_ctrl_rw                : std_logic;
    signal s_i2c_ctrl_data_wr           : std_logic_vector(7 downto 0);
    signal s_i2c_ctrl_start_transaction : std_logic; -- Drives 'ena' of p05_mba_I2C

    -- Signals from p05_mba_I2C to oled_i2c_controller
    signal s_i2c_master_transaction_ack : std_logic; -- This signal needs careful handling. See note below.
    signal s_i2c_master_busy            : std_logic;
    signal s_i2c_master_ack_error       : std_logic;
    signal s_i2c_master_data_rd         : std_logic_vector(7 downto 0); -- From p05_mba_I2C

    --------------------------------------------------------------------------
    -- p05_mba_I2C Component Declaration - BU BÖLÜM KESÝNLÝKLE IP CORE ENTITY'SÝ ÝLE AYNI OLMALI
    --------------------------------------------------------------------------
    component p05_mba_I2C
        generic (
            input_clk : integer := 100_000_000; --input clock speed from user logic in Hz
            bus_clk   : integer := 400_000     --speed the i2c bus (scl) will run at in Hz
        );
        port (
            clk       : in  std_logic;                         --system clock
            reset_n   : in  std_logic;                         --active low reset
            ena       : in  std_logic;                         --latch in command
            addr      : in  std_logic_vector(6 downto 0);    --address of target slave
            rw        : in  std_logic;                         --'0' is write, '1' is read
            data_wr   : in  std_logic_vector(7 downto 0);    --data to write to slave
            busy      : out std_logic;                         --indicates transaction in progress
            data_rd   : out std_logic_vector(7 downto 0);    --data read from slave
            ack_error : buffer std_logic;                      --flag if improper acknowledge from slave
            sda       : inout std_logic;                       --serial data output of i2c bus
            scl       : inout std_logic                        --serial clock output of i2c bus
        );
    end component p05_mba_I2C;

    -- oled_content_sequencer instance
    component p07_oled_content_sequencer
        port (
            clk                      : in  std_logic;
            reset_n                  : in  std_logic;
            trigger_display_update   : in  std_logic;
            selected_food_id         : in  food_id_t;
            selected_food_cost_bcd   : in  unsigned(15 downto 0);
            char_data_ack            : in  std_logic;
            oled_module_busy         : in  std_logic;
            sequencer_busy           : out std_logic;
            output_char              : out character;
            output_char_valid        : out std_logic;
            target_oled_page         : out integer range 0 to 7;
            clear_oled_page_cmd      : out std_logic
        );
    end component p07_oled_content_sequencer;

    -- oled_i2c_controller instance
    component p07_oled_i2c_controller
        port (
            clk                        : in  std_logic;
            reset_n                    : in  std_logic;
            sequencer_char_in          : in  character;
            sequencer_char_valid       : in  std_logic;
            sequencer_target_page      : in  integer range 0 to 7;
            sequencer_clear_page_cmd   : in  std_logic;
            sequencer_char_ack         : out std_logic;
            sequencer_busy_out         : out std_logic;
            -- Connections to the I2C Master (p05_mba_I2C)
            i2c_address_out            : out std_logic_vector(6 downto 0);
            i2c_rw_out                 : out std_logic;
            i2c_data_wr_out            : out std_logic_vector(7 downto 0);
            i2c_start_transaction_out  : out std_logic;
            -- Connections from the I2C Master (p05_mba_I2C)
            i2c_transaction_ack_in     : in  std_logic; -- See note about s_i2c_master_transaction_ack
            i2c_busy_in                : in  std_logic;
            i2c_ack_error_in           : in  std_logic
        );
    end component p07_oled_i2c_controller;

    component p07_debounce
      generic (
        CLK_FREQ_HZ   : integer := 100_000_000;
        STABLE_TIME_MS : integer := 20
      );
      port (
        clk_i         : in  std_logic;
        reset_n_i     : in  std_logic;
        button_in_i   : in  std_logic;
        button_out_o  : out std_logic
      );
    end component p07_debounce;
    -- signal s_btn_trigger_raw : std_logic; -- Bu sinyal zaten BTN_TRIGGER olarak geliyor.

begin
    clk_internal <= CLK100MHZ;
    reset_n_internal <= CPU_RESETN;

    s_selected_food_id <= unsigned(SW); -- Switch'lerden food_id al

    debounce_inst : p07_debounce
      generic map (
          CLK_FREQ_HZ    => 100_000_000,
          STABLE_TIME_MS => 20
      )
      port map (
          clk_i        => clk_internal,
          reset_n_i    => reset_n_internal,
          button_in_i  => BTN_TRIGGER,
          button_out_o => s_trigger_display_update_debounced
      );

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

    sequencer_inst : p07_oled_content_sequencer
        port map (
            clk                      => clk_internal,
            reset_n                  => reset_n_internal,
            trigger_display_update   => s_trigger_display_update,
            selected_food_id         => s_selected_food_id,
            selected_food_cost_bcd   => s_food_cost_bcd,
            char_data_ack            => s_char_data_ack_to_seq,
            oled_module_busy         => s_oled_module_busy_to_seq,
            sequencer_busy           => s_sequencer_busy,
            output_char              => s_output_char,
            output_char_valid        => s_output_char_valid,
            target_oled_page         => s_target_oled_page,
            clear_oled_page_cmd      => s_clear_oled_page_cmd
        );

    i2c_ctrl_inst : p07_oled_i2c_controller
        port map (
            clk                        => clk_internal,
            reset_n                    => reset_n_internal,
            sequencer_char_in          => s_output_char,
            sequencer_char_valid       => s_output_char_valid,
            sequencer_target_page      => s_target_oled_page,
            sequencer_clear_page_cmd   => s_clear_oled_page_cmd,
            sequencer_char_ack         => s_char_data_ack_to_seq,
            sequencer_busy_out         => s_oled_module_busy_to_seq,
            -- Connections to the I2C Master
            i2c_address_out            => s_i2c_ctrl_address,
            i2c_rw_out                 => s_i2c_ctrl_rw,
            i2c_data_wr_out            => s_i2c_ctrl_data_wr,
            i2c_start_transaction_out  => s_i2c_ctrl_start_transaction,
            -- Connections from the I2C Master
            i2c_transaction_ack_in     => s_i2c_master_transaction_ack,
            i2c_busy_in                => s_i2c_master_busy,
            i2c_ack_error_in           => s_i2c_master_ack_error
        );

    -- p05_mba_I2C (I2C Master IP Core) Instantiation
    i2c_master_inst : p05_mba_I2C
        generic map (
            input_clk => 100_000_000, -- CLK100MHZ frekansýna göre
            bus_clk   => 400_000      -- Hedef I2C hýzý (örneðin 100kHz veya 400kHz)
        )
        port map (
            clk       => clk_internal,
            reset_n   => reset_n_internal,
            ena       => s_i2c_ctrl_start_transaction, -- p07_oled_i2c_controller'dan gelen baþlatma sinyali
            addr      => s_i2c_ctrl_address,           -- p07_oled_i2c_controller'dan gelen adres
            rw        => s_i2c_ctrl_rw,                -- p07_oled_i2c_controller'dan gelen R/W biti
            data_wr   => s_i2c_ctrl_data_wr,           -- p07_oled_i2c_controller'dan gelen yazýlacak veri
            busy      => s_i2c_master_busy,            -- p07_oled_i2c_controller'a giden meþgul sinyali
            data_rd   => s_i2c_master_data_rd,         -- p07_oled_i2c_controller'a giden okunan veri (bu projede kullanýlmýyor gibi)
            ack_error => s_i2c_master_ack_error,       -- p07_oled_i2c_controller'a giden ACK hata sinyali
            sda       => OLED_SDA,                     -- Top-level INOUT SDA pini
            scl       => OLED_SCL                      -- Top-level INOUT SCL pini
        );

    -- s_i2c_master_transaction_ack sinyalinin üretilmesi:
    -- p05_mba_I2C IP'si doðrudan bir "transaction_ack" sinyali vermez.
    -- Genellikle, 'busy' düþük olduðunda ve 'ack_error' düþükse iþlem baþarýlýdýr.
    -- p07_oled_i2c_controller'ýn bu sinyali nasýl beklediðine baðlý olarak bu mantýk deðiþebilir.
    -- En basit (ama dikkatli kullanýlmasý gereken) varsayým: ack_error'ýn tersi.
    -- DAHA ÝYÝ BÝR YAKLAÞIM: p07_oled_i2c_controller'ýn sadece busy ve ack_error'ý kullanmasýdýr.
    -- Þimdilik, p07_oled_i2c_controller'ýn beklentisini karþýlamak için ack_error'un tersini atayalým:
    s_i2c_master_transaction_ack <= not s_i2c_master_ack_error;
    -- UYARI: Bu atama, s_i2c_master_ack_error sinyalinin geçerli olduðu zamanlamalara
    -- dikkat edilerek yapýlmalýdýr. p07_oled_i2c_controller, busy sinyali ile birlikte
    -- bu ack sinyallerini deðerlendirmelidir.

end architecture behavioral;