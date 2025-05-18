library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- work.food_definitions_pkg.all; -- string_t ve MAX_STRING_LENGTH için (bu modülde doðrudan kullanýlmýyor ama projenin bütünlüðü için kalabilir)

entity p07_char_to_pixel_rom is
    port (
        char_in        : in  character;                      -- Giriþ ASCII karakteri
        byte_index_in  : in  integer range 0 to 7;           -- Karakterin hangi byte'ý (satýrý) (0-7)
        pixel_byte_out : out std_logic_vector(7 downto 0)   -- Çýkýþ piksel byte'ý (MSB solda)
    );
end entity p07_char_to_pixel_rom;

architecture behavioral of p07_char_to_pixel_rom is
    type font_char_t is array (0 to 7) of std_logic_vector(7 downto 0);

    -- Temel Font Verileri (8x8)
    -- Sans-serif, okunaklý bir stil hedeflenmiþtir.

    -- ' ' (Boþluk)
    constant FONT_SPACE: font_char_t := (
        X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00"
    );

    -- '!'
    constant FONT_EXCLAMATION: font_char_t := (
        X"00", X"18", X"18", X"18", X"18", X"00", X"18", X"00"
    );

    -- '"'
--    constant FONT_DOUBLE_QUOTE: font_char_t := (
--        X"00", X"66", X"66", X"24", X"00", X"00", X"00", X"00"
--    );

    -- '#'
    constant FONT_HASH: font_char_t := (
        X"24", X"7E", X"24", X"7E", X"24", X"7E", X"24", X"00"
    );

    -- '$'
    constant FONT_DOLLAR: font_char_t := (
        X"24", X"2A", X"7F", X"2A", X"2A", X"7F", X"2A", X"24" -- Orijinal $ tanýmý korundu
    );

    -- '%'
    constant FONT_PERCENT: font_char_t := (
        X"00", X"C2", X"C4", X"08", X"10", X"26", X"46", X"00"
    );

    -- '&'
    constant FONT_AMPERSAND: font_char_t := (
        X"38", X"4C", X"54", X"28", X"54", X"4C", X"3A", X"00"
    );

    -- ''' (Tek týrnak)
    constant FONT_SINGLE_QUOTE: font_char_t := (
        X"00", X"18", X"18", X"0C", X"00", X"00", X"00", X"00"
    );

    -- '('
    constant FONT_LPAREN: font_char_t := (
        X"00", X"0C", X"18", X"18", X"18", X"18", X"0C", X"00"
    );

    -- ')'
    constant FONT_RPAREN: font_char_t := (
        X"00", X"30", X"18", X"18", X"18", X"18", X"30", X"00"
    );

    -- '*'
    constant FONT_ASTERISK: font_char_t := (
        X"00", X"00", X"2A", X"1C", X"7F", X"1C", X"2A", X"00"
    );

    -- '+'
    constant FONT_PLUS: font_char_t := (
        X"00", X"08", X"08", X"3E", X"08", X"08", X"00", X"00"
    );

    -- ','
    constant FONT_COMMA: font_char_t := (
        X"00", X"00", X"00", X"00", X"00", X"18", X"18", X"0C"
    );

    -- '-'
    constant FONT_MINUS: font_char_t := (
        X"00", X"00", X"00", X"7E", X"00", X"00", X"00", X"00"
    );

    -- '.'
    constant FONT_PERIOD: font_char_t := (
        X"00", X"00", X"00", X"00", X"00", X"18", X"18", X"00" -- Orijinal '.' tanýmýndan biraz farklý
    );

    -- '/'
    constant FONT_SLASH: font_char_t := (
        X"00", X"02", X"04", X"08", X"10", X"20", X"40", X"00"
    );

    -- Rakamlar
    constant FONT_0: font_char_t := (
        X"3E", X"51", X"49", X"45", X"43", X"3E", X"00", X"00" -- Orijinal
    );
    constant FONT_1: font_char_t := (
        X"00", X"42", X"7F", X"40", X"00", X"00", X"00", X"00" -- Orijinal
    );
    constant FONT_2: font_char_t := (
        X"00", X"72", X"4A", X"4A", X"4A", X"46", X"00", X"00"
    );
    constant FONT_3: font_char_t := (
        X"00", X"22", X"49", X"49", X"49", X"36", X"00", X"00"
    );
    constant FONT_4: font_char_t := (
        X"00", X"0C", X"14", X"24", X"7E", X"04", X"04", X"00"
    );
    constant FONT_5: font_char_t := (
        X"00", X"7A", X"4A", X"4A", X"4A", X"34", X"00", X"00"
    );
    constant FONT_6: font_char_t := (
        X"00", X"3C", X"4A", X"4A", X"4A", X"38", X"00", X"00"
    );
    constant FONT_7: font_char_t := (
        X"00", X"03", X"02", X"7E", X"02", X"02", X"00", X"00"
    );
    constant FONT_8: font_char_t := (
        X"00", X"36", X"49", X"49", X"49", X"36", X"00", X"00"
    );
    constant FONT_9: font_char_t := (
        X"00", X"0E", X"11", X"11", X"11", X"3F", X"00", X"00"
    );

    -- ':'
    constant FONT_COLON: font_char_t := (
        X"00", X"00", X"18", X"18", X"00", X"18", X"18", X"00"
    );

    -- ';'
    constant FONT_SEMICOLON: font_char_t := (
        X"00", X"00", X"18", X"18", X"00", X"18", X"18", X"0C"
    );

    -- '<'
    constant FONT_LESS_THAN: font_char_t := (
        X"00", X"08", X"1C", X"3E", X"1C", X"08", X"00", X"00"
    );

    -- '='
    constant FONT_EQUALS: font_char_t := (
        X"00", X"00", X"7E", X"00", X"7E", X"00", X"00", X"00"
    );

    -- '>'
    constant FONT_GREATER_THAN: font_char_t := (
        X"00", X"20", X"38", X"7C", X"38", X"20", X"00", X"00"
    );

    -- '?'
    constant FONT_QUESTION: font_char_t := (
        X"00", X"78", X"44", X"0C", X"18", X"00", X"18", X"00"
    );

    -- '@'
    constant FONT_AT_SIGN: font_char_t := (
        X"7E", X"41", X"5D", X"55", X"5D", X"40", X"7E", X"00"
    );

    -- Büyük Harfler
    constant FONT_A: font_char_t := (X"7E", X"11", X"11", X"11", X"7E", X"11", X"11", X"00"); -- Orijinal
    constant FONT_B: font_char_t := (X"7F", X"49", X"49", X"7F", X"49", X"49", X"7F", X"00"); -- Orijinal
    constant FONT_C: font_char_t := (X"3E", X"41", X"41", X"41", X"41", X"41", X"3E", X"00"); -- Orijinal
    constant FONT_D: font_char_t := (X"7F", X"41", X"41", X"41", X"41", X"41", X"3E", X"00");
    constant FONT_E: font_char_t := (X"7F", X"49", X"49", X"49", X"49", X"41", X"41", X"00");
    constant FONT_F: font_char_t := (X"7F", X"09", X"09", X"09", X"09", X"01", X"01", X"00");
    constant FONT_G: font_char_t := (X"3E", X"41", X"41", X"51", X"51", X"41", X"3E", X"00");
    constant FONT_H: font_char_t := (X"7F", X"08", X"08", X"08", X"08", X"08", X"7F", X"00");
    constant FONT_I: font_char_t := (X"00", X"41", X"7F", X"7F", X"41", X"00", X"00", X"00"); -- Basit I
    constant FONT_J: font_char_t := (X"00", X"40", X"40", X"40", X"40", X"40", X"7E", X"00");
    constant FONT_K: font_char_t := (X"7F", X"08", X"0C", X"12", X"22", X"41", X"00", X"00");
    constant FONT_L: font_char_t := (X"7F", X"40", X"40", X"40", X"40", X"40", X"40", X"00");
    constant FONT_M: font_char_t := (X"7F", X"02", X"0C", X"0C", X"02", X"7F", X"00", X"00");
    constant FONT_N: font_char_t := (X"7F", X"02", X"04", X"08", X"10", X"20", X"7F", X"00");
    constant FONT_O: font_char_t := (X"3E", X"41", X"41", X"41", X"41", X"41", X"3E", X"00");
    constant FONT_P: font_char_t := (X"7F", X"09", X"09", X"09", X"09", X"0F", X"01", X"00");
    constant FONT_Q: font_char_t := (X"3E", X"41", X"41", X"51", X"61", X"40", X"3E", X"00");
    constant FONT_R: font_char_t := (X"7F", X"09", X"09", X"19", X"29", X"49", X"0F", X"00");
    constant FONT_S: font_char_t := (X"4E", X"49", X"49", X"49", X"49", X"31", X"00", X"00");
    constant FONT_T: font_char_t := (X"01", X"01", X"7F", X"7F", X"01", X"01", X"00", X"00");
    constant FONT_U: font_char_t := (X"3F", X"40", X"40", X"40", X"40", X"40", X"3F", X"00");
    constant FONT_V: font_char_t := (X"1F", X"20", X"40", X"40", X"20", X"1F", X"00", X"00");
    constant FONT_W: font_char_t := (X"3F", X"40", X"38", X"38", X"40", X"3F", X"00", X"00");
    constant FONT_X: font_char_t := (X"41", X"22", X"14", X"08", X"14", X"22", X"41", X"00");
    constant FONT_Y: font_char_t := (X"07", X"08", X"70", X"70", X"08", X"07", X"00", X"00");
    constant FONT_Z: font_char_t := (X"61", X"51", X"49", X"45", X"43", X"00", X"00", X"00");

    -- '[', '\', ']', '^', '_' (Bu karakterler için FONT_QUESTION kullanýlacak, gerekirse tanýmlanabilir)
    constant FONT_LBRACKET: font_char_t := FONT_QUESTION;
    constant FONT_BACKSLASH: font_char_t := FONT_QUESTION;
    constant FONT_RBRACKET: font_char_t := FONT_QUESTION;
    constant FONT_CARET: font_char_t := FONT_QUESTION;
    constant FONT_UNDERSCORE: font_char_t := (X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"FF");

    -- '`'
    constant FONT_GRAVE_ACCENT: font_char_t := (X"00",X"0C",X"18",X"00",X"00",X"00",X"00",X"00");

    -- Küçük Harfler
    constant FONT_sa: font_char_t := (X"00", X"00", X"78", X"04", X"7C", X"44", X"78", X"00");
    constant FONT_sb: font_char_t := (X"7F", X"48", X"48", X"48", X"48", X"30", X"00", X"00");
    constant FONT_sc: font_char_t := (X"00", X"00", X"38", X"44", X"44", X"44", X"44", X"00");
    constant FONT_sd: font_char_t := (X"00", X"30", X"48", X"48", X"48", X"48", X"7F", X"00");
    constant FONT_se: font_char_t := (X"00", X"00", X"38", X"4C", X"4C", X"4C", X"38", X"00");
    constant FONT_sf: font_char_t := (X"00", X"0C", X"1E", X"0C", X"0C", X"0C", X"00", X"00"); -- Basit f
    constant FONT_sg: font_char_t := (X"00", X"00", X"3C", X"4A", X"4A", X"3A", X"0A", X"7C");
    constant FONT_sh: font_char_t := (X"7F", X"08", X"08", X"08", X"08", X"70", X"00", X"00");
    constant FONT_si: font_char_t := (X"00", X"00", X"18", X"58", X"18", X"18", X"00", X"00");
    constant FONT_sj: font_char_t := (X"00", X"00", X"20", X"20", X"20", X"A0", X"60", X"00");
    constant FONT_sk: font_char_t := (X"7F", X"10", X"28", X"44", X"00", X"00", X"00", X"00");
    constant FONT_sl: font_char_t := (X"00", X"18", X"7F", X"40", X"00", X"00", X"00", X"00"); -- Basit l
    constant FONT_sm: font_char_t := (X"00", X"00", X"7C", X"08", X"70", X"08", X"70", X"00");
    constant FONT_sn: font_char_t := (X"00", X"00", X"7C", X"08", X"08", X"08", X"70", X"00");
    constant FONT_so: font_char_t := (X"00", X"00", X"38", X"44", X"44", X"44", X"38", X"00");
    constant FONT_sp: font_char_t := (X"00", X"00", X"7C", X"24", X"24", X"24", X"18", X"00");
    constant FONT_sq: font_char_t := (X"00", X"00", X"18", X"24", X"24", X"7C", X"20", X"70");
    constant FONT_sr: font_char_t := (X"00", X"00", X"7C", X"08", X"04", X"04", X"08", X"00");
    constant FONT_ss: font_char_t := (X"00", X"00", X"58", X"4C", X"4C", X"4C", X"34", X"00");
    constant FONT_st: font_char_t := (X"00", X"08", X"3E", X"48", X"48", X"20", X"00", X"00");
    constant FONT_su: font_char_t := (X"00", X"00", X"3C", X"40", X"40", X"20", X"7C", X"00");
    constant FONT_sv: font_char_t := (X"00", X"00", X"3C", X"40", X"40", X"20", X"1C", X"00");
    constant FONT_sw: font_char_t := (X"00", X"00", X"78", X"40", X"70", X"40", X"78", X"00");
    constant FONT_sx: font_char_t := (X"00", X"00", X"44", X"28", X"10", X"28", X"44", X"00");
    constant FONT_sy: font_char_t := (X"00", X"00", X"3C", X"40", X"40", X"3C", X"04", X"78");
    constant FONT_sz: font_char_t := (X"00", X"00", X"4C", X"54", X"64", X"44", X"00", X"00");

    -- '{', '|', '}', '~' (Bu karakterler için FONT_QUESTION kullanýlacak, gerekirse tanýmlanabilir)
    constant FONT_LBRACE: font_char_t := FONT_QUESTION;
    constant FONT_PIPE: font_char_t := FONT_QUESTION;
    constant FONT_RBRACE: font_char_t := FONT_QUESTION;
    constant FONT_TILDE: font_char_t := FONT_QUESTION;

    -- Diðer karakterler için varsayýlan font
    constant FONT_UNKNOWN : font_char_t := FONT_QUESTION;

begin
    process(char_in, byte_index_in)
        variable selected_font : font_char_t;
    begin
        case char_in is
            -- Boþluk ve Özel Karakterler (ASCII 32-47)
            when ' '            => selected_font := FONT_SPACE;
            when '!'            => selected_font := FONT_EXCLAMATION;
            --when '"'            => selected_font := FONT_DOUBLE_QUOTE;
            when '#'            => selected_font := FONT_HASH;
            when '$'            => selected_font := FONT_DOLLAR;
            when '%'            => selected_font := FONT_PERCENT;
            when '&'            => selected_font := FONT_AMPERSAND;
            when '''            => selected_font := FONT_SINGLE_QUOTE;
            when '('            => selected_font := FONT_LPAREN;
            when ')'            => selected_font := FONT_RPAREN;
            when '*'            => selected_font := FONT_ASTERISK;
            when '+'            => selected_font := FONT_PLUS;
            when ','            => selected_font := FONT_COMMA;
            when '-'            => selected_font := FONT_MINUS;
            when '.'            => selected_font := FONT_PERIOD;
            when '/'            => selected_font := FONT_SLASH;

            -- Rakamlar (ASCII 48-57)
            when '0'            => selected_font := FONT_0;
            when '1'            => selected_font := FONT_1;
            when '2'            => selected_font := FONT_2;
            when '3'            => selected_font := FONT_3;
            when '4'            => selected_font := FONT_4;
            when '5'            => selected_font := FONT_5;
            when '6'            => selected_font := FONT_6;
            when '7'            => selected_font := FONT_7;
            when '8'            => selected_font := FONT_8;
            when '9'            => selected_font := FONT_9;

            -- Özel Karakterler (ASCII 58-64)
            when ':'            => selected_font := FONT_COLON;
            when ';'            => selected_font := FONT_SEMICOLON;
            when '<'            => selected_font := FONT_LESS_THAN;
            when '='            => selected_font := FONT_EQUALS;
            when '>'            => selected_font := FONT_GREATER_THAN;
            when '?'            => selected_font := FONT_QUESTION;
            when '@'            => selected_font := FONT_AT_SIGN;

            -- Büyük Harfler (ASCII 65-90)
            when 'A'            => selected_font := FONT_A;
            when 'B'            => selected_font := FONT_B;
            when 'C'            => selected_font := FONT_C;
            when 'D'            => selected_font := FONT_D;
            when 'E'            => selected_font := FONT_E;
            when 'F'            => selected_font := FONT_F;
            when 'G'            => selected_font := FONT_G;
            when 'H'            => selected_font := FONT_H;
            when 'I'            => selected_font := FONT_I;
            when 'J'            => selected_font := FONT_J;
            when 'K'            => selected_font := FONT_K;
            when 'L'            => selected_font := FONT_L;
            when 'M'            => selected_font := FONT_M;
            when 'N'            => selected_font := FONT_N;
            when 'O'            => selected_font := FONT_O;
            when 'P'            => selected_font := FONT_P;
            when 'Q'            => selected_font := FONT_Q;
            when 'R'            => selected_font := FONT_R;
            when 'S'            => selected_font := FONT_S;
            when 'T'            => selected_font := FONT_T;
            when 'U'            => selected_font := FONT_U;
            when 'V'            => selected_font := FONT_V;
            when 'W'            => selected_font := FONT_W;
            when 'X'            => selected_font := FONT_X;
            when 'Y'            => selected_font := FONT_Y;
            when 'Z'            => selected_font := FONT_Z;

            -- Özel Karakterler (ASCII 91-96)
            when '['            => selected_font := FONT_LBRACKET;
            when '\'           => selected_font := FONT_BACKSLASH; -- VHDL'de ters slash için kaçýþ karakteri gerekebilir, test edin
            when ']'            => selected_font := FONT_RBRACKET;
            when '^'            => selected_font := FONT_CARET;
            when '_'            => selected_font := FONT_UNDERSCORE;
            when '`'            => selected_font := FONT_GRAVE_ACCENT;

            -- Küçük Harfler (ASCII 97-122)
            when 'a'            => selected_font := FONT_sa;
            when 'b'            => selected_font := FONT_sb;
            when 'c'            => selected_font := FONT_sc;
            when 'd'            => selected_font := FONT_sd;
            when 'e'            => selected_font := FONT_se;
            when 'f'            => selected_font := FONT_sf;
            when 'g'            => selected_font := FONT_sg;
            when 'h'            => selected_font := FONT_sh;
            when 'i'            => selected_font := FONT_si;
            when 'j'            => selected_font := FONT_sj;
            when 'k'            => selected_font := FONT_sk;
            when 'l'            => selected_font := FONT_sl;
            when 'm'            => selected_font := FONT_sm;
            when 'n'            => selected_font := FONT_sn;
            when 'o'            => selected_font := FONT_so;
            when 'p'            => selected_font := FONT_sp;
            when 'q'            => selected_font := FONT_sq;
            when 'r'            => selected_font := FONT_sr;
            when 's'            => selected_font := FONT_ss;
            when 't'            => selected_font := FONT_st;
            when 'u'            => selected_font := FONT_su;
            when 'v'            => selected_font := FONT_sv;
            when 'w'            => selected_font := FONT_sw;
            when 'x'            => selected_font := FONT_sx;
            when 'y'            => selected_font := FONT_sy;
            when 'z'            => selected_font := FONT_sz;

            -- Özel Karakterler (ASCII 123-126)
            when '{'            => selected_font := FONT_LBRACE;
            when '|'            => selected_font := FONT_PIPE;
            when '}'            => selected_font := FONT_RBRACE;
            when '~'            => selected_font := FONT_TILDE;

            -- Diðer tüm karakterler için
            when others         => selected_font := FONT_UNKNOWN;
        end case;

        pixel_byte_out <= selected_font(byte_index_in);
    end process;

end architecture behavioral;