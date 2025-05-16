library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.food_definitions_pkg.all; -- MAX_STRING_LENGTH i�in

entity p07_oled_i2c_controller is
    port (
        clk                     : in  std_logic;
        reset_n                 : in  std_logic;

        -- Aray�z: oled_content_sequencer
        sequencer_char_in       : in  character;
        sequencer_char_valid    : in  std_logic;
        sequencer_target_page   : in  integer range 0 to 7;
        sequencer_clear_page_cmd: in  std_logic; -- '1' pulse
        sequencer_char_ack      : out std_logic;
        sequencer_busy_out      : out std_logic; -- Bu mod�l me�gulse '1'

        -- Aray�z: p05_mba_I2C
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

    -- SSD1306 Komutlar�/Kontrol Byte'lar�
    constant CMD_CONTROL_BYTE   : std_logic_vector(7 downto 0) := X"00"; -- Co=0, D/C#=0
    constant DATA_CONTROL_BYTE  : std_logic_vector(7 downto 0) := X"40"; -- Co=0, D/C#=1

    constant CMD_SET_PAGE_BASE      : unsigned(7 downto 0) := X"B0";
    constant CMD_SET_COL_LOW_BASE   : unsigned(7 downto 0) := X"00";
    constant CMD_SET_COL_HIGH_BASE  : unsigned(7 downto 0) := X"10";

    -- Karakter ba��na s�tun geni�li�i (font 8x8 ise)
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

        -- Sayfa Temizleme Durumlar�
        S_CLEAR_SET_PAGE,
        S_CLEAR_SET_COL_LOW,
        S_CLEAR_SET_COL_HIGH,
        S_CLEAR_SEND_DATA_CTRL,
        S_CLEAR_SEND_BYTE,
        S_CLEAR_WAIT_BYTE_SENT,
        S_CLEAR_DONE,

        -- Karakter Yazma Durumlar�
        S_CHAR_PROCESS,
        S_CHAR_SET_PAGE,         -- Sadece sayfa de�i�tiyse veya ilk karakterse
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

    signal prev_page             : integer range 0 to 7 := -1; -- Sayfa de�i�imini izlemek i�in
    signal is_first_char_on_page : std_logic := '1';

    -- char_to_pixel_rom instantiation
    component p07_char_to_pixel_rom
        port (
            char_in     : in  character;
            byte_index_in : in  integer range 0 to 7;
            pixel_byte_out: out std_logic_vector(7 downto 0)
        );
    end component p07_char_to_pixel_rom;

    signal p_start_transaction : std_logic; -- p05_mba_I2C i�in start_transaction

begin

    char_rom_inst : p07_char_to_pixel_rom
        port map (
            char_in        => latched_char,
            byte_index_in  => char_byte_index,
            pixel_byte_out => current_char_pixel_byte
        );

    -- p05_mba_I2C ba�lant�lar�
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
            prev_page <= 0; -- veya ge�ersiz bir de�er
            is_first_char_on_page <= '1';
        elsif rising_edge(clk) then
            current_state <= next_state;
            p_start_transaction <= '0'; -- Pulse
            sequencer_char_ack  <= '0'; -- Pulse

            -- Komutlar� latch'le (S_IDLE'da iken)
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
                    current_column <= 0; -- Her yeni komut dizisi i�in s�tunu s�f�rla
                    clear_byte_count <= 0;
                    char_byte_index <= 0;
                    if latched_clear_cmd = '1' then
                        is_first_char_on_page <= '1'; -- Temizlemeden sonra ilk karakter olacak
                        next_state <= S_CLEAR_SET_PAGE;
                    elsif latched_char_valid = '1' then
                         -- Sayfa de�i�ti mi veya bu sayfadaki ilk karakter mi kontrol et
                        if latched_target_page /= prev_page then
                            is_first_char_on_page <= '1';
                            prev_page <= latched_target_page;
                        end if;
                        next_state <= S_CHAR_PROCESS;
                    else
                        next_state <= S_IDLE; -- Hata durumu, buraya gelmemeli
                    end if;
                    latched_clear_cmd <= '0'; -- Latch'lenen komutlar� temizle
                    latched_char_valid <= '0';


                -- Sayfa Temizleme Mant���
                when S_CLEAR_SET_PAGE =>
                    if i2c_busy_in = '0' then
                        i2c_data_wr_out <= CMD_CONTROL_BYTE; -- �nce komut kontrol byte'�
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
                        i2c_data_wr_out <= std_logic_vector(CMD_SET_COL_LOW_BASE); -- S�tun 0
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
                        i2c_data_wr_out <= std_logic_vector(CMD_SET_COL_HIGH_BASE); -- S�tun 0
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
                            i2c_data_wr_out <= X"00"; -- Temizleme i�in 0x00 g�nder
                            p_start_transaction <= '1';
                            next_state <= S_CLEAR_WAIT_BYTE_SENT;
                        else
                            next_state <= S_CLEAR_DONE; -- T�m byte'lar g�nderildi
                        end if;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CLEAR_SEND_BYTE; -- �lk byte i�in bekle
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
                    -- sequencer_char_ack <= '1'; -- Temizleme i�in ack sequencer'a �zel de�il, busy ile halledilir.
                    next_state <= S_IDLE;


                -- Karakter Yazma Mant���
                when S_CHAR_PROCESS =>
                    if is_first_char_on_page = '1' then
                         current_column <= 0; -- Sayfadaki ilk karakterse s�tunu s�f�rla
                         next_state <= S_CHAR_SET_PAGE;
                    else
                        -- S�tun ayar� gerekli mi? (Genellikle evet, her karakter i�in)
                        -- Veya sadece veri g�ndermeye devam et (e�er OLED otomatik art�r�yorsa ve sadece sayfa ba��nda ayarland�ysa)
                        -- Basitlik ad�na her karakter i�in s�tun ayarlayal�m
                         next_state <= S_CHAR_SET_COL_LOW;
                    end if;
                    is_first_char_on_page <= '0'; -- S�f�rla

                when S_CHAR_SET_PAGE => -- Sadece sayfa ba��/de�i�iminde
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
                         next_state <= S_CHAR_SET_COL_LOW; -- �lk karakterse bekle
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
                        char_byte_index <= 0; -- Karakterin ilk sat�r�ndan ba�la
                        next_state <= S_CHAR_FETCH_PIXEL_ROW;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                        next_state <= S_IDLE; -- Hata
                    else
                        next_state <= S_CHAR_SEND_DATA_CTRL;
                    end if;

                when S_CHAR_FETCH_PIXEL_ROW => -- current_char_pixel_byte bir sonraki cycle'da g�ncellenir
                    if i2c_transaction_ack_in = '1' and i2c_ack_error_in = '0' then
                        next_state <= S_CHAR_SEND_PIXEL_ROW;
                    elsif i2c_transaction_ack_in = '1' and i2c_ack_error_in = '1' then
                         next_state <= S_IDLE; -- Hata
                    else
                         next_state <= S_CHAR_FETCH_PIXEL_ROW; -- Data control byte'�n�n g�nderilmesini bekle
                    end if;


                when S_CHAR_SEND_PIXEL_ROW =>
                    if i2c_busy_in = '0' then -- Sadece p05_mba_I2C me�gul de�ilse g�nder
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
                    if char_byte_index < 7 then -- Karakterin t�m sat�rlar� g�nderildi mi?
                        char_byte_index <= char_byte_index + 1;
                        next_state <= S_CHAR_FETCH_PIXEL_ROW; -- ROM'dan bir sonraki sat�r� al
                    else
                        current_column <= current_column + 1; -- Sonraki karakter i�in s�tunu art�r (karakter geni�li�i 1 s�tun varsay�l�yor, 8 piksel i�in bu 1 I2C veri yaz�m� demek)
                                                             -- E�er karakter geni�li�i > 1 s�tun ise (�rn. 8 piksel = 1 s�tun), bu art�� do�ru.
                                                             -- E�er font 5x7 ise ve her s�tun 1 piksel ise, current_column += CHAR_WIDTH_PIXELS olmal�.
                                                             -- �u anki mant�kta her bir piksel sat�r� bir "s�tun" gibi i�leniyor.
                                                             -- Do�rusu: Karakterin 8 byte'� (8 sat�r�) ayn� OLED s�tununa yaz�l�r.
                                                             -- S�tun, bir sonraki karaktere ge�erken art�r�lmal�.
                                                             -- Bu y�zden `current_column` art��� burada de�il, S_CHAR_DONE_ACK'ten sonra olmal�.
                                                             -- VEYA, SSD1306 otomatik olarak s�tunu art�r�r. E�er �yleyse, `current_column`'u sadece sat�r ba��nda ayarlamak yeterli.
                                                             -- SSD1306 sayfa modunda s�tunu otomatik art�r�r.
                        next_state <= S_CHAR_DONE_ACK;
                    end if;

                when S_CHAR_DONE_ACK =>
                    sequencer_char_ack <= '1';
                    -- current_column <= current_column + 1; -- S�tun otomatik art�yorsa bu gereksiz. Sadece bir sonraki string i�in s�f�rlanacak.
                    next_state <= S_IDLE;

                when others =>
                    next_state <= S_IDLE;
            end case;
        end if;
    end process;

    -- S_CLEAR_SET_PAGE_WAIT_CMD_CTRL gibi ara bekleme durumlar� ekledim,
    -- ��nk� p05_mba_I2C'ye g�nderilen her komut/veri i�in transaction_ack beklenmeli.
    -- Bu FSM, p05_mba_I2C'nin 'busy' ve 'transaction_ack' sinyallerine g�re ilerler.
    -- Eklenen _WAIT_CMD_CTRL durumlar�, CMD_CONTROL_BYTE g�nderildikten sonra as�l komutun
    -- g�nderilmesini senkronize eder.

end architecture behavioral;