library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.food_definitions_pkg.all; -- string_t ve MAX_STRING_LENGTH i�in

entity p07_char_to_pixel_rom is
    port (
        char_in     : in  character;                         -- Giri� ASCII karakteri
        byte_index_in : in  integer range 0 to 7;            -- Karakterin hangi byte'� (sat�r�) (0-7)
        pixel_byte_out: out std_logic_vector(7 downto 0)     -- ��k�� piksel byte'� (MSB solda)
    );
end entity p07_char_to_pixel_rom;

architecture behavioral of p07_char_to_pixel_rom is
    type font_char_t is array (0 to 7) of std_logic_vector(7 downto 0);

    -- �rnek Font Verileri (8x8)
    -- http://www.Loselect.com/notes/electronics/pic/lcd/fonts/ (veya benzeri bir kaynaktan)
    -- Karakterler: 'A', 'B', 'C', '0', '1', ' ', '$', '.'
    -- ' ' (Bo�luk)
    constant FONT_SPACE: font_char_t := (
        X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00"
    );
    -- 'A'
    constant FONT_A: font_char_t := (
        X"7E", X"11", X"11", X"11", X"7E", X"11", X"11", X"00" -- Biraz farkl� A
    );
    -- 'B'
    constant FONT_B: font_char_t := (
        X"7F", X"49", X"49", X"7F", X"49", X"49", X"7F", X"00"
    );
    -- 'C'
    constant FONT_C: font_char_t := (
        X"3E", X"41", X"41", X"41", X"41", X"41", X"3E", X"00"
    );
    -- '0'
    constant FONT_0: font_char_t := (
        X"3E", X"51", X"49", X"45", X"43", X"3E", X"00", X"00"
    );
    -- '1'
    constant FONT_1: font_char_t := (
        X"00", X"42", X"7F", X"40", X"00", X"00", X"00", X"00"
    );
    -- '$'
    constant FONT_DOLLAR: font_char_t := (
        X"24", X"2A", X"7F", X"2A", X"2A", X"7F", X"2A", X"24" -- Basit bir $
    );
    -- '.'
    constant FONT_PERIOD: font_char_t := (
        X"00", X"00", X"00", X"00", X"00", X"60", X"60", X"00"
    );
    -- Di�er karakterler i�in FONT_SPACE veya FONT_UNKNOWN kullan�labilir
    constant FONT_UNKNOWN : font_char_t := FONT_SPACE;


begin
    process(char_in, byte_index_in)
        variable selected_font : font_char_t;
    begin
        case char_in is
            when 'A' | 'a' => selected_font := FONT_A;
            when 'B' | 'b' => selected_font := FONT_B;
            when 'C' | 'c' => selected_font := FONT_C;
            when '0'       => selected_font := FONT_0;
            when '1'       => selected_font := FONT_1;
            when ' '       => selected_font := FONT_SPACE;
            when '$'       => selected_font := FONT_DOLLAR;
            when '.'       => selected_font := FONT_PERIOD;
            -- oled_content_sequencer'daki string'lerde kullan�lan di�er karakterleri ekleyin
            when 'D' | 'd' => selected_font := FONT_UNKNOWN; -- �rnek
            when 'E' | 'e' => selected_font := FONT_UNKNOWN;
            when 'F' | 'f' => selected_font := FONT_UNKNOWN;
            when 'G' | 'g' => selected_font := FONT_UNKNOWN;
            when 'H' | 'h' => selected_font := FONT_UNKNOWN;
            when 'I' | 'i' => selected_font := FONT_UNKNOWN;
            when 'K' | 'k' => selected_font := FONT_UNKNOWN;
            when 'L' | 'l' => selected_font := FONT_UNKNOWN;
            when 'M' | 'm' => selected_font := FONT_UNKNOWN;
            when 'N' | 'n' => selected_font := FONT_UNKNOWN;
            when 'O' | 'o' => selected_font := FONT_UNKNOWN;
            when 'P' | 'p' => selected_font := FONT_UNKNOWN;
            when 'R' | 'r' => selected_font := FONT_UNKNOWN;
            when 'S' | 's' => selected_font := FONT_UNKNOWN;
            when 'T' | 't' => selected_font := FONT_UNKNOWN;
            when 'U' | 'u' => selected_font := FONT_UNKNOWN;
            when 'V' | 'v' => selected_font := FONT_UNKNOWN;
            when 'W' | 'w' => selected_font := FONT_UNKNOWN;
            when 'Y' | 'y' => selected_font := FONT_UNKNOWN;
            -- ... Di�er karakterler i�in font verilerini ekleyin
            when others    => selected_font := FONT_UNKNOWN;
        end case;

        pixel_byte_out <= selected_font(byte_index_in);
    end process;

end architecture behavioral;----    ama bu mod�le de�i�tirilecek 



--bana atm�� oldu�un food_data_provider dosyas�ndaki isimleri yazabilece�im 
--t�m harfleri ekle font ekleme (tk tip olsun m�mk�nse Calibri) ve ascideki 
--t�m karakterler i�in d�n���m olsun . B�y�k ve k���k harfler i�in farkl� farkl� d�n���nler olsun . 