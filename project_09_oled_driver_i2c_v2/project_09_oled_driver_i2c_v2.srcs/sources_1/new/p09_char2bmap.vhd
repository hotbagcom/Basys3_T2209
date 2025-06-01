----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2025 17:18:33
-- Design Name: 
-- Module Name: p09_char2bmap - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity p09_char2bmap is
    Port ( 
    
    clk : in std_logic  := '0';
    bmap_rst        : in std_logic := '0';
    bmap_ena        : in std_logic := '0';
    bmap_activate   :  in std_logic := '0';
    
    
    --str_char_in_asciTable : integer range 0 to 127 := 0 ;-- every char first index is length
    
    i2c_tx_character_acsii_number : in  integer range 0 to 127  := 31 ;
      i2c_tx_req_4pre       : out std_logic := '0';-- to hand shake with pre  this req comes from bitmap 
      i2c_tx_byte1_4pre     : out std_logic_vector(7 downto 0) := x"00" ; -- command foe write           
      i2c_tx_byte2_4pre     : out std_logic_vector(7 downto 0) := x"00" ; -- bit map to byte             
    --txt_i2c_tx_avail_4bitmap    : in std_logic := '0'; -- tribe gets permision from preudo to send data to MBA
    
    
    
    tribe_pre_busy   :  in std_logic := '0';   
    tribe_pre_done   :  in std_logic := '0';   
    tribe_pre_error  :  in std_logic := '0';
    
    
    
      bmap_busy     :  out std_logic := '0';
      bmap_done     :  out std_logic := '0';
      bmap_error    :  out std_logic := '0'
      
    );
end p09_char2bmap;

architecture Behavioral of p09_char2bmap is




type state_t is (                  -- this command tor one abovemodule update this comment --TO DO --


    St_CHECK_BMAP  ,---  if bmap_activate = '1' then take currentchar number and find char in ascii table  and   ST_TRIBE = St_SET_BMAP                                                                                                                                                               
    St_SET_BMAP    ,---  set index= 0 and busy = 1 and done = 0  and ST_TRIBE = St_SEND_BMAP                                                                                                                                                                                                          
    St_SEND_BMAP   ,---   bitmap(index) ,   ST_TRIBE = St_WAIT_BMAP                                                                                                                                                                                                                                   
    St_WAIT_BMAP   ,--- if index<lengthofbmap then ( if i2c_transaction_done = 1 then  INCBmapindex and ST_TRIBE = St_SEND_BMAP    ) elsif index<lengthofbmap then     else error = 1                                                                                                                 
    St_DONE_BMAP    --- set bmap_busy = 0 , bmap_done = 1 , ST_TRIBE = St_SEND_STR      



    );
signal ST_BMAP  : state_t := St_CHECK_BMAP;

signal Si_i2c_tx_character_acsii_number :  integer range 0 to 127  := 48 ;
signal Si_index_bmap : integer range 0 to 9  := 0 ;
signal Si_index_bmap_limit : integer range 0 to 9  := 0 ;

type char_pixbyte_t is array (0 to 7) of std_logic_vector(7 downto 0)  ;
type char_asciT_array_t is array (31 to 127) of char_pixbyte_t ;
Constant C_asciT : char_asciT_array_t := (
        --31 (not defined)
        (X"ff", X"81", X"BD", X"A5", X"A5", X"BD", X"81", X"ff"),
        -- 32: ' ' (space)
        (X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00"),
        -- 33: !
        (X"00", X"18", X"3C", X"3C", X"18", X"18", X"00", X"18"),
        -- 34: "
        (X"00", X"66", X"66", X"24", X"00", X"00", X"00", X"00"),
        -- 35: #
        (X"00", X"24", X"7E", X"24", X"7E", X"24", X"00", X"00"),
        -- 36: $
        (X"00", X"18", X"3A", X"4C", X"5A", X"38", X"18", X"00"),
        -- 37: %
        (X"00", X"63", X"66", X"0C", X"18", X"33", X"63", X"00"),
        -- 38: &
        (X"00", X"38", X"4C", X"54", X"2C", X"56", X"4C", X"38"),
        -- 39: '
        (X"00", X"18", X"18", X"30", X"00", X"00", X"00", X"00"),
        -- 40: (
        (X"00", X"0C", X"18", X"30", X"30", X"18", X"0C", X"00"),
        -- 41: )
        (X"00", X"30", X"18", X"0C", X"0C", X"18", X"30", X"00"),
        -- 42: *
        (X"00", X"00", X"18", X"7E", X"3C", X"7E", X"18", X"00"),
        -- 43: +
        (X"00", X"00", X"18", X"18", X"7E", X"18", X"18", X"00"),
        -- 44: ,
        (X"00", X"00", X"00", X"00", X"30", X"18", X"30", X"00"),
        -- 45: -
        (X"00", X"00", X"00", X"00", X"7E", X"00", X"00", X"00"),
        -- 46: .
        (X"00", X"00", X"00", X"00", X"30", X"30", X"00", X"00"),
        -- 47: /
        (X"00", X"03", X"06", X"0C", X"18", X"30", X"60", X"00"),
        -- 48: 0
        (X"00", X"3C", X"66", X"6E", X"76", X"66", X"3C", X"00"),
        -- 49: 1
        (X"00", X"18", X"38", X"18", X"18", X"18", X"3C", X"00"),
        -- 50: 2
        (X"00", X"3C", X"66", X"06", X"1C", X"30", X"7E", X"00"),
        -- 51: 3
        (X"00", X"3C", X"66", X"06", X"3C", X"06", X"66", X"3C"),
        -- 52: 4
        (X"00", X"0C", X"1C", X"3C", X"6C", X"7E", X"0C", X"0C"),
        -- 53: 5
        (X"00", X"7E", X"60", X"7C", X"06", X"06", X"66", X"3C"),
        -- 54: 6
        (X"00", X"3C", X"60", X"60", X"7C", X"66", X"66", X"3C"),
        -- 55: 7
        (X"00", X"7E", X"66", X"0C", X"18", X"30", X"30", X"00"),
        -- 56: 8
        (X"00", X"3C", X"66", X"66", X"3C", X"66", X"66", X"3C"),
        -- 57: 9
        (X"00", X"3C", X"66", X"66", X"3E", X"06", X"0C", X"38"),
        -- 58: :
        (X"00", X"00", X"18", X"18", X"00", X"18", X"18", X"00"),
        -- 59: ;
        (X"00", X"00", X"18", X"18", X"00", X"18", X"18", X"0C"),
        -- 60: <
        (X"00", X"0C", X"18", X"30", X"60", X"30", X"18", X"0C"),
        -- 61: =
        (X"00", X"00", X"7E", X"00", X"00", X"7E", X"00", X"00"),
        -- 62: >
        (X"00", X"60", X"30", X"18", X"0C", X"18", X"30", X"60"),
        -- 63: ?
        (X"00", X"3C", X"66", X"0C", X"18", X"18", X"00", X"18"),
        -- 64: @
        (X"00", X"3C", X"66", X"6E", X"7E", X"70", X"66", X"3C"),
        -- 65: A
        (X"00", X"18", X"3C", X"66", X"66", X"7E", X"66", X"66"),
        -- 66: B
        (X"00", X"7C", X"66", X"66", X"7C", X"66", X"66", X"7C"),
        -- 67: C
        (X"00", X"3C", X"66", X"60", X"60", X"60", X"66", X"3C"),
        -- 68: D
        (X"00", X"78", X"6C", X"66", X"66", X"6C", X"78", X"00"),
        -- 69: E
        (X"00", X"7E", X"60", X"60", X"7C", X"60", X"60", X"7E"),
        -- 70: F
        (X"00", X"7E", X"60", X"60", X"7C", X"60", X"60", X"60"),
        -- 71: G
        (X"00", X"3C", X"66", X"60", X"6E", X"66", X"66", X"3C"),
        -- 72: H
        (X"00", X"66", X"66", X"66", X"7E", X"66", X"66", X"66"),
        -- 73: I
        (X"00", X"3C", X"18", X"18", X"18", X"18", X"18", X"3C"),
        -- 74: J
        (X"00", X"1E", X"0C", X"0C", X"0C", X"6C", X"6C", X"38"),
        -- 75: K
        (X"00", X"66", X"6C", X"78", X"70", X"78", X"6C", X"66"),
        -- 76: L
        (X"00", X"60", X"60", X"60", X"60", X"60", X"60", X"7E"),
        -- 77: M
        (X"00", X"C6", X"EE", X"FE", X"D6", X"C6", X"C6", X"C6"),
        -- 78: N
        (X"00", X"66", X"E6", X"F6", X"DE", X"CE", X"66", X"66"),
        -- 79: O
        (X"00", X"3C", X"66", X"66", X"66", X"66", X"66", X"3C"),
        -- 80: P
        (X"00", X"7C", X"66", X"66", X"7C", X"60", X"60", X"60"),
        -- 81: Q
        (X"00", X"3C", X"66", X"66", X"66", X"6E", X"3C", X"06"),
        -- 82: R
        (X"00", X"7C", X"66", X"66", X"7C", X"78", X"6C", X"66"),
        -- 83: S
        (X"00", X"3C", X"66", X"30", X"18", X"0C", X"66", X"3C"),
        -- 84: T
        (X"00", X"7E", X"7E", X"18", X"18", X"18", X"18", X"18"),
        -- 85: U
        (X"00", X"66", X"66", X"66", X"66", X"66", X"66", X"3C"),
        -- 86: V
        (X"00", X"66", X"66", X"66", X"66", X"66", X"3C", X"18"),
        -- 87: W
        (X"00", X"C6", X"C6", X"C6", X"D6", X"FE", X"EE", X"C6"),
        -- 88: X
        (X"00", X"66", X"66", X"3C", X"18", X"3C", X"66", X"66"),
        -- 89: Y
        (X"00", X"66", X"66", X"66", X"3C", X"18", X"18", X"18"),
        -- 90: Z
        (X"00", X"7E", X"06", X"0C", X"18", X"30", X"60", X"7E"),
        -- 91: [
        (X"00", X"3C", X"30", X"30", X"30", X"30", X"30", X"3C"),
        -- 92: '\'
        (X"00", X"60", X"30", X"18", X"0C", X"06", X"03", X"00"),
        -- 93: ]
        (X"00", X"3C", X"0C", X"0C", X"0C", X"0C", X"0C", X"3C"),
        -- 94: ^
        (X"00", X"00", X"18", X"3C", X"66", X"00", X"00", X"00"),
        -- 95: _
        (X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"FF"),
        -- 96: `
        (X"00", X"30", X"18", X"0C", X"00", X"00", X"00", X"00"),
        -- 97: a
        (X"00", X"00", X"00", X"3C", X"06", X"3E", X"66", X"3E"),
        -- 98: b
        (X"00", X"60", X"60", X"7C", X"66", X"66", X"66", X"7C"),
        -- 99: c
        (X"00", X"00", X"00", X"3C", X"66", X"60", X"66", X"3C"),
        -- 100: d
        (X"00", X"06", X"06", X"3E", X"66", X"66", X"66", X"3E"),
        -- 101: e
        (X"00", X"00", X"00", X"3C", X"66", X"7E", X"60", X"3C"),
        -- 102: f
        (X"00", X"0C", X"18", X"18", X"7E", X"18", X"18", X"00"),
        -- 103: g
        (X"00", X"00", X"3E", X"66", X"66", X"3E", X"06", X"3C"),
        -- 104: h
        (X"00", X"60", X"60", X"7C", X"66", X"66", X"66", X"66"),
        -- 105: i
        (X"00", X"18", X"00", X"38", X"18", X"18", X"18", X"3C"),
        -- 106: j
        (X"00", X"06", X"00", X"0C", X"0C", X"0C", X"6C", X"38"),
        -- 107: k
        (X"00", X"60", X"60", X"6C", X"78", X"70", X"6C", X"66"),
        -- 108: l
        (X"00", X"18", X"18", X"18", X"18", X"18", X"18", X"3C"),
        -- 109: m
        (X"00", X"00", X"00", X"EC", X"FE", X"D6", X"D6", X"D6"),
        -- 110: n
        (X"00", X"00", X"00", X"7C", X"66", X"66", X"66", X"66"),
        -- 111: o
        (X"00", X"00", X"00", X"3C", X"66", X"66", X"66", X"3C"),
        -- 112: p
        (X"00", X"00", X"7C", X"66", X"66", X"7C", X"60", X"60"),
        -- 113: q
        (X"00", X"00", X"3E", X"66", X"66", X"3E", X"06", X"06"),
        -- 114: r
        (X"00", X"00", X"00", X"7C", X"66", X"60", X"60", X"60"),
        -- 115: s
        (X"00", X"00", X"00", X"3E", X"60", X"3C", X"06", X"7C"),
        -- 116: t
        (X"00", X"10", X"10", X"3E", X"10", X"10", X"12", X"0C"),
        -- 117: u
        (X"00", X"00", X"00", X"66", X"66", X"66", X"66", X"3E"),
        -- 118: v
        (X"00", X"00", X"00", X"66", X"66", X"66", X"3C", X"18"),
        -- 119: w
        (X"00", X"00", X"00", X"C6", X"D6", X"D6", X"FE", X"6C"),
        -- 120: x
        (X"00", X"00", X"00", X"66", X"3C", X"18", X"3C", X"66"),
        -- 121: y
        (X"00", X"00", X"66", X"66", X"66", X"3E", X"06", X"3C"),
        -- 122: z
        (X"00", X"00", X"00", X"7E", X"0C", X"18", X"30", X"7E"),
        -- 123: {
        (X"00", X"0C", X"18", X"18", X"70", X"18", X"18", X"0C"),
        -- 124: |
        (X"00", X"0C", X"0C", X"0C", X"0C", X"0C", X"0C", X"0C"),
        -- 125: }
        (X"00", X"70", X"18", X"18", X"0C", X"18", X"18", X"70"),
        -- 126: ~
        (X"00", X"00", X"00", X"38", X"46", X"00", X"00", X"00"),
        -- 127: empty - no clue character 
        (X"00", X"7E", X"60", X"7C", X"0C", X"38", X"60", X"7E")
        
);




begin


Si_i2c_tx_character_acsii_number <= i2c_tx_character_acsii_number ;





process (clk) begin 
    if rising_edge(clk) and (bmap_ena = '1') then 
        if (bmap_rst = '1') then
        
        else 
        
            case (ST_BMAP) is 
                
                when St_CHECK_BMAP => 
                    if ( bmap_activate = '1' ) and ( tribe_pre_busy = '0')  then 
                        ST_BMAP <= St_SET_BMAP ;
                        if ( Si_i2c_tx_character_acsii_number < 31) then 
                            Si_i2c_tx_character_acsii_number <= 31 ;
                        end if ;
                    end if ; 
                
                when St_SET_BMAP   => 
                    Si_index_bmap  <= 0 ;
                    i2c_tx_byte1_4pre <= X"40";
                    Si_index_bmap_limit <= C_asciT(Si_i2c_tx_character_acsii_number)'length ;
                
                when St_SEND_BMAP  => 
                    if (tribe_pre_busy = '0' and Si_index_bmap < Si_index_bmap_limit ) then
                        i2c_tx_byte2_4pre <=   C_asciT(Si_i2c_tx_character_acsii_number)(Si_index_bmap) ;
                    end if ;
                
                when St_WAIT_BMAP  => 
                    if ( tribe_pre_done = '1' ) then                  
                        Si_index_bmap <= Si_index_bmap +1 ;   
                        ST_BMAP <= St_SEND_BMAP ;                                 
                    end if ;
                when St_DONE_BMAP  => 
                    bmap_busy  <= '0' ;
                    bmap_done  <= '1' ;
                    if ( bmap_activate = '0') then
                        ST_BMAP <= St_CHECK_BMAP ;
                    end if ;
                

            end case ;

        end if ;
    end if ;
end process ;











end Behavioral;
