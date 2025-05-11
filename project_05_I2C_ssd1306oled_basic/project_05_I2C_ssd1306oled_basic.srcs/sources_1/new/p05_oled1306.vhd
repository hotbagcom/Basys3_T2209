----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2025 08:59:51
-- Design Name: 
-- Module Name: p05_oled1306 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 3c
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



entity p05_oled1306 is
    generic (
        constant SSD1306_WIDTH : integer  := 128;
        constant SSD1306_HEIGHT : integer := 64
    );
    
    Port (
    debug_stage :out std_logic_vector(2 downto 0) := "000";
        clk        : in  std_logic; -- Yeni eklenen saat giriþi
        reset_n    : in  std_logic := '0'; -- Yeni eklenen aktif-düþük reset giriþi
        btn_triger : in  std_logic := '0';
        en_com     : out std_logic := '0';
        adrr_1306_d1 :out std_logic_vector(6 downto 0) := "0111100";
        R_W        : out std_logic := '0';
        data_wr    : out std_logic_vector(7 downto 0);
        busy       : in  std_logic := '0';
        data_rd    : in  std_logic_vector(7 downto 0)
    );
end p05_oled1306;






architecture Behavioral of p05_oled1306 is

    -- Tüm SSD1306 init komutlarý (kontrol baytlarý hariç)
    type CMD_SEQ_ARRAY is array(natural range <>) of std_logic_vector(7 downto 0);
    constant SSD1306_INIT_SEQUENCE : CMD_SEQ_ARRAY := (
        X"AE",      -- Display OFF
        X"D5", X"80", -- Set Display Clock Divide Ratio / Oscillator Frequency
        X"A8", X"3F", -- Set Multiplex Ratio (for 64 height, if 32 use X"1F")
        X"D3", X"00", -- Set Display Offset
        X"40",      -- Set Display Start Line (0x40 + 0)
        X"8D", X"14", -- Charge Pump Setting (Enable Charge Pump)
        X"20", X"02", -- Memory Addressing Mode (0x02 = Page Addressing Mode)
        X"A1",      -- Segment Remap (Column Address 0 mapped to SEG0)
        X"C8",      -- COM Output Scan Direction (Remapped mode)
        X"DA",      -- COM Pins Hardware Configuration
        -- Bu deðeri ekran yüksekliðinize göre ayarlayýn:
        -- 128x64 için X"12"
        -- 128x32 için X"02"
        X"12",
        X"81", X"CF", -- Set Contrast Control (Max brightness)
        X"D9", X"F1", -- Set Pre-charge Period
        X"DB", X"40", -- Set VCOM Deselect Level
        X"A4",      -- Entire Display ON / Resume to RAM content
        X"A6",      -- Set Normal Display (0xA7 for inverse)
        X"2E",      -- Deactivate scroll
        X"AF"       -- Display ON
    );
    constant NUM_INIT_CMDS : integer := SSD1306_INIT_SEQUENCE'length;

    -- 8x8 Gülen Yüz Bitmap Verisi (C++ örneðindeki gibi)
    type BITMAP_SEQ_ARRAY is array(natural range <>) of std_logic_vector(7 downto 0);
    constant SMILEY_FACE_8X8_DATA : BITMAP_SEQ_ARRAY := (
        X"3d", -- Sütun 0
        X"42", -- Sütun 1
        X"A5", -- Sütun 2
        X"81", -- Sütun 3
        X"A5", -- Sütun 4
        X"99", -- Sütun 5
        X"42", -- Sütun 6
        X"3f"  -- Sütun 7
    );
    constant NUM_SMILEY_BYTES : integer := SMILEY_FACE_8X8_DATA'length;

    -- Ekraný temizlemek için gerekli adresleme ve 0x00 veri baytlarý
    -- (0x21, 0x00, 0x7F), (0x22, 0x00, 0x07) komutlarý ile ardýndan tüm data'lar 0x00
    constant SCREEN_CLEAR_ADDR_CMDS : CMD_SEQ_ARRAY := (
        X"21", X"00", X"7F", -- Set Column Address (Start=0, End=127)
        X"22", X"00", X"07"  -- Set Page Address (Start=0, End=7 for 64px height)
    );
    constant NUM_CLEAR_ADDR_CMDS : integer := SCREEN_CLEAR_ADDR_CMDS'length;

    -- Durum makinesi için durum tipleri
    type OLED_STATE is (
        S_IDLE,             -- Hazýrda bekle
        S_INIT_CMD_CTRL,    -- Komut kontrol baytýný gönder (0x00)
        S_INIT_CMD_DATA,    -- Komut verisini gönder
        S_CLEAR_ADDR_CTRL,  -- Ekraný temizleme adres komutu kontrol baytý
        S_CLEAR_ADDR_DATA,  -- Ekraný temizleme adres komutu verisi
        S_CLEAR_DATA_CTRL,  -- Ekraný temizleme veri kontrol baytý (0x40)
        S_CLEAR_DATA_PIXEL, -- Ekraný temizleme piksel verisi (0x00)
        S_DRAW_ADDR_CTRL,   -- Bitmap çizim adres komutu kontrol baytý
        S_DRAW_ADDR_DATA,   -- Bitmap çizim adres komutu verisi
        S_DRAW_DATA_CTRL,   -- Bitmap çizim veri kontrol baytý (0x40)
        S_DRAW_DATA_PIXEL,  -- Bitmap çizim piksel verisi
        S_DONE              -- Ýþlem tamamlandý
    );
    signal current_state : OLED_STATE := S_IDLE;
    signal S_en_com : std_logic := '0';
    
    -- Çeþitli sayaçlar
    signal cmd_idx      : integer range 0 to NUM_INIT_CMDS := 0;
    signal clear_addr_idx : integer range 0 to NUM_CLEAR_ADDR_CMDS := 0;
    signal pixel_data_idx : integer range 0 to SSD1306_WIDTH * (SSD1306_HEIGHT / 8) := 0;
    signal bitmap_idx   : integer range 0 to NUM_SMILEY_BYTES := 0;

    -- I2C IP çekirdeðine gönderilecek mevcut veri
    signal current_data_to_i2c : std_logic_vector(7 downto 0);
    
begin


process (current_data_to_i2c ,S_en_com ) begin
    data_wr <= current_data_to_i2c; -- I2C IP çekirdeðine gönderilecek veri
    en_com <= S_en_com ;
end process ;


    process (clk, reset_n)
    begin
        if reset_n = '1' then
            current_state <= S_IDLE;
            S_en_com <= '0';
            adrr_1306_d1 <= "0111100"; -- SSD1306 I2C adresi (0x3C)
            R_W <= '0';                -- Her zaman yazma modu
            cmd_idx <= 0;
            clear_addr_idx <= 0;
            pixel_data_idx <= 0;
            bitmap_idx <= 0;
            current_data_to_i2c <= (others => '0');

        elsif rising_edge(clk) then
            -- btn_triger ile iþlemi baþlatma
            if btn_triger = '1' and current_state = S_IDLE then
                current_state <= S_INIT_CMD_CTRL;
                S_en_com <= '1'; -- I2C iþlemi için ena'yý yüksek tut
                cmd_idx <= 0;
            elsif busy = '0' and S_en_com = '1' then -- I2C IP çekirdeði bir bayt göndermeyi tamamladýðýnda
                case current_state is
                    when S_INIT_CMD_CTRL =>
                        current_data_to_i2c <= X"00"; -- Komut kontrol baytý
                        current_state <= S_INIT_CMD_DATA;

                    when S_INIT_CMD_DATA =>
                        current_data_to_i2c <= SSD1306_INIT_SEQUENCE(cmd_idx); -- Asýl komut baytý
                        cmd_idx <= cmd_idx + 1;
                        if cmd_idx = NUM_INIT_CMDS then
                            current_state <= S_CLEAR_ADDR_CTRL; -- Init bitti, temizleme adres komutlarýna geç
                            clear_addr_idx <= 0;
                        else
                            current_state <= S_INIT_CMD_CTRL; -- Bir sonraki komut için kontrol baytýna geri dön
                        end if;

                    when S_CLEAR_ADDR_CTRL =>
                        current_data_to_i2c <= X"00"; -- Komut kontrol baytý
                        current_state <= S_CLEAR_ADDR_DATA;

                    when S_CLEAR_ADDR_DATA =>

                        current_data_to_i2c <= SCREEN_CLEAR_ADDR_CMDS(clear_addr_idx); -- Adres komut verisi
                        clear_addr_idx <= clear_addr_idx + 1;
                        if clear_addr_idx = NUM_CLEAR_ADDR_CMDS then
                            current_state <= S_CLEAR_DATA_CTRL; -- Adres komutlarý bitti, temizleme veri baytlarýna geç
                            pixel_data_idx <= 0;
                        else
                            current_state <= S_CLEAR_ADDR_CTRL; -- Bir sonraki adres komutu için kontrol baytýna geri dön
                        end if;

                    when S_CLEAR_DATA_CTRL =>
                        current_data_to_i2c <= X"40"; -- Veri kontrol baytý
                        current_state <= S_CLEAR_DATA_PIXEL;

                    when S_CLEAR_DATA_PIXEL =>
                        current_data_to_i2c <= X"00"; -- Ekraný temizlemek için 0x00 piksel verisi
                        pixel_data_idx <= pixel_data_idx + 1;
                        if pixel_data_idx = (SSD1306_WIDTH * (SSD1306_HEIGHT / 8)) then
                            current_state <= S_DRAW_ADDR_CTRL; -- Temizleme bitti, bitmap çizim adres komutlarýna geç
                            bitmap_idx <= 0; -- bitmap_idx'i sýfýrla
                        else
                            current_state <= S_CLEAR_DATA_CTRL; -- Bir sonraki piksel için kontrol baytýna geri dön
                        end if;

                    when S_DRAW_ADDR_CTRL =>
                        current_data_to_i2c <= X"00"; -- Komut kontrol baytý
                        current_state <= S_DRAW_ADDR_DATA;

                    when S_DRAW_ADDR_DATA =>
    
                        case bitmap_idx is
                            when 0 =>
                                current_data_to_i2c <= X"21";  -- Set Column Address
                                bitmap_idx <= 1;
                                current_state <= S_DRAW_ADDR_CTRL;
                            when 1 =>
                                current_data_to_i2c <= X"00";  -- Start = 0
                                bitmap_idx <= 2;
                                current_state <= S_DRAW_ADDR_CTRL;
                            when 2 =>
                                current_data_to_i2c <= X"7F";  -- End = 127
                                bitmap_idx <= 3;
                                current_state <= S_DRAW_ADDR_CTRL;
                            when 3 =>
                                current_data_to_i2c <= X"22";  -- Set Page Address
                                bitmap_idx <= 4;
                                current_state <= S_DRAW_ADDR_CTRL;
                            when 4 =>
                                current_data_to_i2c <= X"00";  -- Start page = 0
                                bitmap_idx <= 5;
                                current_state <= S_DRAW_ADDR_CTRL;
                            when 5 =>
                                current_data_to_i2c <= X"07";  -- End page = 7
                                bitmap_idx <= 6;
                                current_state <= S_DRAW_ADDR_CTRL;
  debug_stage <=  "001";
                            when others =>
                                current_state <= S_DRAW_DATA_CTRL;  -- Çizime geç
                                bitmap_idx <= 0;
                        end case;


                    when S_DRAW_DATA_CTRL =>
                        current_data_to_i2c <= X"40"; -- Veri kontrol baytý
                        current_state <= S_DRAW_DATA_PIXEL;

                    when S_DRAW_DATA_PIXEL =>
                        current_data_to_i2c <= SMILEY_FACE_8X8_DATA(bitmap_idx); -- Gülen yüz piksel verisi
                        bitmap_idx <= bitmap_idx + 1;
    debug_stage <=  "010";
                        if bitmap_idx = NUM_SMILEY_BYTES then
    debug_stage <=  "100";
                            current_state <= S_DONE; -- Tüm bitmap gönderildi
                            S_en_com <= '0'; -- I2C iþlemini sonlandýr
                        else
                            current_state <= S_DRAW_DATA_CTRL; -- Bir sonraki piksel için kontrol baytýna geri dön
                        end if;

                    when S_DONE =>
                        -- Ýþlem tamamlandý, yeni bir iþlem için btn_triger'ýn düþmesini bekle
                        if btn_triger = '0' then
                            current_state <= S_IDLE;
                        end if;
                        S_en_com <= '0'; -- Ena'yý düþük tut

                    when others =>
                        current_state <= S_IDLE;
                        S_en_com <= '0';
                end case;
            end if; -- busy='0' and S_en_com='1'
        end if; -- rising_edge(clk)
    end process;

end Behavioral;
