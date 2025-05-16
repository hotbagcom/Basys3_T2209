library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.food_definitions_pkg.all; -- MAX_STRING_LENGTH için

entity p07_oled_i2c_controller is
    port (
        clk                     : in  std_logic;
        reset_n                 : in  std_logic;

        -- Arayüz: oled_content_sequencer
        sequencer_char_in       : in  character;
        sequencer_char_valid    : in  std_logic;
        sequencer_target_page   : in  integer range 0 to 7;
        sequencer_clear_page_cmd: in  std_logic; -- '1' pulse
        sequencer_char_ack      : out std_logic;
        sequencer_busy_out      : out std_logic; -- Bu modül meþgulse '1'

        -- Arayüz: p05_mba_I2C
        i2c_address_out         : out std_logic_vector(6 downto 0);
        i2c_rw_out              : out std_logic;
        i2c_data_wr_out         : out std_logic_vector(7 downto 0);
        i2c_start_transaction_out: out std_logic;
        i2c_transaction_ack_in  : in  std_logic;
        i2c_busy_in             : in  std_logic;
        i2c_ack_error_in        : in  std_logic
    );
end entity p07_oled_i2c_controller;

architecture behavioral of p07_oled_i2c_controller is

    -- SSD1306 I2C Adresi (7-bit)
    constant OLED_I2C_SLAVE_ADDR : std_logic_vector(6 downto 0) := "0111100"; -- X"3C"

    -- SSD1306 Komutlarý/Kontrol Byte'larý
    constant CMD_CONTROL_BYTE   : std_logic_vector(7 downto 0) := X"00"; -- Co=0, D/C#=0
    constant DATA_CONTROL_BYTE  : std_logic_vector(7 downto 0) := X"40"; -- Co=0, D/C#=1

    constant CMD_SET_PAGE_BASE      : unsigned(7 downto 0) := X"B0";
    constant CMD_SET_COL_LOW_BASE   : unsigned(7 downto 0) := X"00";
    constant CMD_SET_COL_HIGH_BASE  : unsigned(7 downto 0) := X"10";

    -- Karakter baþýna sütun geniþliði (font 8x8 ise)
    constant CHAR_WIDTH_COLUMNS : integer := 8;
    constant MAX_COLUMNS_PER_PAGE : integer := 128;

    type state_t is (
        S_IDLE,
        S_LATCH_COMMAND,
        
        --noidea
        S_CLEAR_SET_COL_LOW_WAIT_CMD_CTRL ,
        S_CLEAR_SET_PAGE_WAIT_CMD_CTRL,
        S_CLEAR_SET_COL_HIGH_WAIT_CMD_CTRL,
        S_CHAR_SET_PAGE_WAIT_CMD_CTRL ,
        S_CHAR_SET_COL_LOW_WAIT_CMD_CTRL ,S_CHAR_SET_COL_HIGH_WAIT_CMD_CTRL,

        -- Sayfa Temizleme Durumlarý
        S_CLEAR_SET_PAGE,
        S_CLEAR_SET_COL_LOW,
        S_CLEAR_SET_COL_HIGH,
        S_CLEAR_SEND_DATA_CTRL,
        S_CLEAR_SEND_BYTE,
        S_CLEAR_WAIT_BYTE_SENT,
        S_CLEAR_DONE,

        -- Karakter Yazma Durumlarý
        S_CHAR_PROCESS,
        S_CHAR_SET_PAGE,         -- Sadece sayfa deðiþtiyse veya ilk karakterse
        S_CHAR_SET_COL_LOW,
        S_CHAR_SET_COL_HIGH,
        S_CHAR_SEND_DATA_CTRL,
        S_CHAR_FETCH_PIXEL_ROW,
        S_CHAR_SEND_PIXEL_ROW,
        S_CHAR_WAIT_PIXEL_ROW_SENT,
        S_CHAR_ROW_DONE,
        S_CHAR_DONE_ACK
    );
    signal current_state, next_state : state_t;

    signal latched_char          : character;
    signal latched_target_page   : integer range 0 to 7;
    signal latched_clear_cmd     : std_logic;
    signal latched_char_valid    : std_logic;

    signal current_char_pixel_byte : std_logic_vector(7 downto 0);
    signal char_byte_index       : integer range 0 to 7; -- 0-7 for 8 rows of a char
    signal clear_byte_count      : integer range 0 to MAX_COLUMNS_PER_PAGE; -- 0-128
    signal current_column        : integer range 0 to MAX_COLUMNS_PER_PAGE; -- 0-128

    signal prev_page             : integer range 0 to 7 := -1; -- Sayfa deðiþimini izlemek için
    signal is_first_char_on_page : std_logic := '1';

    -- char_to_pixel_rom instantiation
    component p07_char_to_pixel_rom
        port (
            char_in     : in  character;
            byte_index_in : in  integer range 0 to 7;
            pixel_byte_out: out std_logic_vector(7 downto 0)
        );
    end component p07_char_to_pixel_rom;

    signal p_start_transaction : std_logic; -- p05_mba_I2C için start_transaction

begin

    char_rom_inst : p07_char_to_pixel_rom
        port map (
            char_in        => latched_char,
            byte_index_in  => char_byte_index,
            pixel_byte_out => current_char_pixel_byte
        );

    -- p05_mba_I2C baðlantýlarý
    i2c_address_out <= OLED_I2C_SLAVE_ADDR;
    i2c_rw_out      <= '0'; -- Her zaman yazma
    i2c_start_transaction_out <= p_start_transaction;

    process(clk, reset_n)
    begin
        if reset_n = '0' then
            current_state <= S_IDLE;
            sequencer_busy_out <= '0';
            sequencer_char_ack <= '0';
            p_start_transaction <= '0';
            i2c_data_wr_out <= (others => '0');
            latched_clear_cmd <= '0';
            latched_char_valid <= '0';
            char_byte_index <= 0;
            clear_byte_count <= 0;
            current_column <= 0;
            prev_page <= 0; -- veya geçersiz bir deðer
            is_first_char_on_page <= '1';
        elsif rising_edge(clk) then
            current_state <= next_state;
            p_start_transaction <= '0'; -- Pulse
            sequencer_char_ack  <= '0'; -- Pulse

            -- Komutlarý latch'le (S_IDLE'da iken)
            if current_state = S_IDLE then
                latched_clear_cmd  <= sequencer_clear_page_cmd;
                latched_char_valid <= sequencer_char_valid;
                if sequencer_char_valid = '1' then
                    latched_char        <= sequencer_char_in;
                    latched_target_page <= sequencer_target_page;
                elsif sequencer_clear_page_cmd = '1' then
                     latched_target_page <= sequencer_target_page;
                end if;
            end if;


            case current_state is
                when S_IDLE =>
                    sequencer_busy_out <= '0';
                    if latched_clear_cmd = '1' then
                        next_state <= S_LATCH_COMMAND;
                    elsif latched_char_valid = '1' then
                        next_state <= S_LATCH_COMMAND;
                    else
                        next_state <= S_IDLE;
                    end if;

                when S_LATCH_COMMAND =>
                    sequencer_busy_out <= '1';
                    current_column <= 0; -- Her yeni komut dizisi için sütunu sýfýrla
                    clear_byte_count <= 0;
                    char_byte_index <= 0;
                    if latched_clear_cmd = '1' then
                        is_first_char_on_page <= '1'; -- Temizlemeden sonra ilk karakter olacak
                        next_state <= S_CLEAR_SET_PAGE;
                    elsif latched_char_valid = '1' then
                         -- Sayfa deðiþti mi veya bu sayfadaki ilk karakter mi kontrol et
                        if latched_target_page /= prev_page then
                            is_first_char_on_page <= '1';
                            prev_page <= latched_target_page;
                        end if;
                        next_state <= S_CHAR_PROCESS;
                    else
                        next_state <= S_IDLE; -- Hata durumu, buraya gelmemeli
                    end if;
                    latched_clear_cmd <= '0'; -- Latch'lenen komutlarý temizle
                    latched_char_valid <= '0';


                -- Sayfa Temizleme Mantýðý
                when S_CLEAR_SET_PAGE =>
                    if i2c_busy_in = '0' then
                        i2c_data_wr_out <= CMD_CONTROL_BYTE; -- Önce komut kontrol byte'ý
                        p_start_transaction <= '1';
                        next_state <= S_CLEAR_SET_PAGE_WAIT_CMD_CTRL;
                    else
                        next_state <= S_CLEAR_SET_PAGE;
                    end if;
                when S_CLEAR_SET_PAGE_WAIT_CMD_CTRL =>
                     if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        i2c_data_wr_out <= std_logic_vector(CMD_SET_PAGE_BASE + to_unsigned(latched_target_page, 8));
                        p_start_transaction <= '1';
                        next_state <= S_CLEAR_SET_COL_LOW;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CLEAR_SET_PAGE_WAIT_CMD_CTRL;
                    end if;

                when S_CLEAR_SET_COL_LOW =>
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        i2c_data_wr_out <= CMD_CONTROL_BYTE;
                        p_start_transaction <= '1';
                        next_state <= S_CLEAR_SET_COL_LOW_WAIT_CMD_CTRL;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CLEAR_SET_COL_LOW;
                    end if;
                when S_CLEAR_SET_COL_LOW_WAIT_CMD_CTRL =>
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        i2c_data_wr_out <= std_logic_vector(CMD_SET_COL_LOW_BASE); -- Sütun 0
                        p_start_transaction <= '1';
                        next_state <= S_CLEAR_SET_COL_HIGH;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CLEAR_SET_COL_LOW_WAIT_CMD_CTRL;
                    end if;

                when S_CLEAR_SET_COL_HIGH =>
                     if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        i2c_data_wr_out <= CMD_CONTROL_BYTE;
                        p_start_transaction <= '1';
                        next_state <= S_CLEAR_SET_COL_HIGH_WAIT_CMD_CTRL;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CLEAR_SET_COL_HIGH;
                    end if;
                when S_CLEAR_SET_COL_HIGH_WAIT_CMD_CTRL =>
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        i2c_data_wr_out <= std_logic_vector(CMD_SET_COL_HIGH_BASE); -- Sütun 0
                        p_start_transaction <= '1';
                        next_state <= S_CLEAR_SEND_DATA_CTRL;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CLEAR_SET_COL_HIGH_WAIT_CMD_CTRL;
                    end if;


                when S_CLEAR_SEND_DATA_CTRL =>
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        i2c_data_wr_out <= DATA_CONTROL_BYTE;
                        p_start_transaction <= '1';
                        next_state <= S_CLEAR_SEND_BYTE;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CLEAR_SEND_DATA_CTRL;
                    end if;

                when S_CLEAR_SEND_BYTE =>
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        if clear_byte_count < MAX_COLUMNS_PER_PAGE then
                            i2c_data_wr_out <= X"00"; -- Temizleme için 0x00 gönder
                            p_start_transaction <= '1';
                            next_state <= S_CLEAR_WAIT_BYTE_SENT;
                        else
                            next_state <= S_CLEAR_DONE; -- Tüm byte'lar gönderildi
                        end if;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CLEAR_SEND_BYTE; -- Ýlk byte için bekle
                    end if;


                when S_CLEAR_WAIT_BYTE_SENT =>
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        clear_byte_count <= clear_byte_count + 1;
                        next_state <= S_CLEAR_SEND_BYTE;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CLEAR_WAIT_BYTE_SENT;
                    end if;

                when S_CLEAR_DONE =>
                    -- sequencer_char_ack <= '1'; -- Temizleme için ack sequencer'a özel deðil, busy ile halledilir.
                    next_state <= S_IDLE;


                -- Karakter Yazma Mantýðý
                when S_CHAR_PROCESS =>
                    if is_first_char_on_page = '1' then
                         current_column <= 0; -- Sayfadaki ilk karakterse sütunu sýfýrla
                         next_state <= S_CHAR_SET_PAGE;
                    else
                        -- Sütun ayarý gerekli mi? (Genellikle evet, her karakter için)
                        -- Veya sadece veri göndermeye devam et (eðer OLED otomatik artýrýyorsa ve sadece sayfa baþýnda ayarlandýysa)
                        -- Basitlik adýna her karakter için sütun ayarlayalým
                         next_state <= S_CHAR_SET_COL_LOW;
                    end if;
                    is_first_char_on_page <= '0'; -- Sýfýrla

                when S_CHAR_SET_PAGE => -- Sadece sayfa baþý/deðiþiminde
                    if i2c_busy_in = '0' then
                        i2c_data_wr_out <= CMD_CONTROL_BYTE;
                        p_start_transaction <= '1';
                        next_state <= S_CHAR_SET_PAGE_WAIT_CMD_CTRL;
                    else
                        next_state <= S_CHAR_SET_PAGE;
                    end if;
                when S_CHAR_SET_PAGE_WAIT_CMD_CTRL =>
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        i2c_data_wr_out <= std_logic_vector(CMD_SET_PAGE_BASE + to_unsigned(latched_target_page, 8));
                        p_start_transaction <= '1';
                        next_state <= S_CHAR_SET_COL_LOW;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CHAR_SET_PAGE_WAIT_CMD_CTRL;
                    end if;
                when S_CHAR_SET_COL_LOW =>
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        i2c_data_wr_out <= CMD_CONTROL_BYTE;
                        p_start_transaction <= '1';
                        next_state <= S_CHAR_SET_COL_LOW_WAIT_CMD_CTRL;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                         next_state <= S_IDLE; -- Hata
                    else
                         next_state <= S_CHAR_SET_COL_LOW; -- Ýlk karakterse bekle
                    end if;
                when S_CHAR_SET_COL_LOW_WAIT_CMD_CTRL =>
                     if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        i2c_data_wr_out <= std_logic_vector(CMD_SET_COL_LOW_BASE + to_unsigned(current_column mod 16, 8));
                        p_start_transaction <= '1';
                        next_state <= S_CHAR_SET_COL_HIGH;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CHAR_SET_COL_LOW_WAIT_CMD_CTRL;
                    end if;


                when S_CHAR_SET_COL_HIGH =>
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        i2c_data_wr_out <= CMD_CONTROL_BYTE;
                        p_start_transaction <= '1';
                        next_state <= S_CHAR_SET_COL_HIGH_WAIT_CMD_CTRL;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CHAR_SET_COL_HIGH;
                    end if;
                when S_CHAR_SET_COL_HIGH_WAIT_CMD_CTRL =>
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        i2c_data_wr_out <= std_logic_vector(CMD_SET_COL_HIGH_BASE + to_unsigned(current_column / 16, 8));
                        p_start_transaction <= '1';
                        next_state <= S_CHAR_SEND_DATA_CTRL;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CHAR_SET_COL_HIGH_WAIT_CMD_CTRL;
                    end if;

                when S_CHAR_SEND_DATA_CTRL =>
                     if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        i2c_data_wr_out <= DATA_CONTROL_BYTE;
                        p_start_transaction <= '1';
                        char_byte_index <= 0; -- Karakterin ilk satýrýndan baþla
                        next_state <= S_CHAR_FETCH_PIXEL_ROW;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CHAR_SEND_DATA_CTRL;
                    end if;

                when S_CHAR_FETCH_PIXEL_ROW => -- current_char_pixel_byte bir sonraki cycle'da güncellenir
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        next_state <= S_CHAR_SEND_PIXEL_ROW;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                         next_state <= S_IDLE; -- Hata
                    else
                         next_state <= S_CHAR_FETCH_PIXEL_ROW; -- Data control byte'ýnýn gönderilmesini bekle
                    end if;


                when S_CHAR_SEND_PIXEL_ROW =>
                    if i2c_busy_in = '0' then -- Sadece p05_mba_I2C meþgul deðilse gönder
                        i2c_data_wr_out <= current_char_pixel_byte;
                        p_start_transaction <= '1';
                        next_state <= S_CHAR_WAIT_PIXEL_ROW_SENT;
                    else
                        next_state <= S_CHAR_SEND_PIXEL_ROW;
                    end if;

                when S_CHAR_WAIT_PIXEL_ROW_SENT =>
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        next_state <= S_CHAR_ROW_DONE;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CHAR_WAIT_PIXEL_ROW_SENT;
                    end if;

                when S_CHAR_ROW_DONE =>
                    if char_byte_index < 7 then -- Karakterin tüm satýrlarý gönderildi mi?
                        char_byte_index <= char_byte_index + 1;
                        next_state <= S_CHAR_FETCH_PIXEL_ROW; -- ROM'dan bir sonraki satýrý al
                    else
                        current_column <= current_column + 1; -- Sonraki karakter için sütunu artýr (karakter geniþliði 1 sütun varsayýlýyor, 8 piksel için bu 1 I2C veri yazýmý demek)
                                                             -- Eðer karakter geniþliði > 1 sütun ise (örn. 8 piksel = 1 sütun), bu artýþ doðru.
                                                             -- Eðer font 5x7 ise ve her sütun 1 piksel ise, current_column += CHAR_WIDTH_PIXELS olmalý.
                                                             -- Þu anki mantýkta her bir piksel satýrý bir "sütun" gibi iþleniyor.
                                                             -- Doðrusu: Karakterin 8 byte'ý (8 satýrý) ayný OLED sütununa yazýlýr.
                                                             -- Sütun, bir sonraki karaktere geçerken artýrýlmalý.
                                                             -- Bu yüzden `current_column` artýþý burada deðil, S_CHAR_DONE_ACK'ten sonra olmalý.
                                                             -- VEYA, SSD1306 otomatik olarak sütunu artýrýr. Eðer öyleyse, `current_column`'u sadece satýr baþýnda ayarlamak yeterli.
                                                             -- SSD1306 sayfa modunda sütunu otomatik artýrýr.
                        next_state <= S_CHAR_DONE_ACK;
                    end if;

                when S_CHAR_DONE_ACK =>
                    sequencer_char_ack <= '1';
                    -- current_column <= current_column + 1; -- Sütun otomatik artýyorsa bu gereksiz. Sadece bir sonraki string için sýfýrlanacak.
                    next_state <= S_IDLE;

                when others =>
                    next_state <= S_IDLE;
            end case;
        end if;
    end process;

    -- S_CLEAR_SET_PAGE_WAIT_CMD_CTRL gibi ara bekleme durumlarý ekledim,
    -- çünkü p05_mba_I2C'ye gönderilen her komut/veri için transaction_ack beklenmeli.
    -- Bu FSM, p05_mba_I2C'nin 'busy' ve 'transaction_ack' sinyallerine göre ilerler.
    -- Eklenen _WAIT_CMD_CTRL durumlarý, CMD_CONTROL_BYTE gönderildikten sonra asýl komutun
    -- gönderilmesini senkronize eder.

end architecture behavioral;