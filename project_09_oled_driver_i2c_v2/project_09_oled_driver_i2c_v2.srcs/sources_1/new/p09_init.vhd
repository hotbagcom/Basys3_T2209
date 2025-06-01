----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2025 17:18:33
-- Design Name: 
-- Module Name: p09_init - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity p09_init is
    Port ( 
    
    clk : in std_logic  := '0';
    init_rst          : in std_logic := '0';
    init_ena          : in std_logic := '0';
    init_activate     : in std_logic := '0';
    
    
       i2c_tx_req_4pre       : out std_logic := '0';--   this req comes from both init type     --- impulse 
       i2c_tx_byte1_4pre      : out std_logic_vector(7 downto 0) := x"00" ; -- init command to MBA 
       i2c_tx_byte2_4pre      : out std_logic_vector(7 downto 0) := x"00" ; -- init command to MBA             
   --not required I have tribe_pre_busy and tribe_pre_done anymore .  i2c_tx_avail_4init       : in std_logic := '0'; -- tribe gets permision from preudo to send data to MBA
    
    init_mode           : in std_logic_vector(3 downto 0) := "0000" ;  
    page_number         : in std_logic_vector(2 downto 0) := "000" ;
    colum_number        : in std_logic_vector(7 downto 0) := x"00" ; 

    tribe_pre_busy   :  in std_logic := '0';   
    tribe_pre_done   :  in std_logic := '0';   
    tribe_pre_error  :  in std_logic := '0';

      init_busy       :  out std_logic := '0';
      init_done       :  out std_logic := '0';
      init_error      :  out std_logic := '0'
    );
end p09_init;

architecture Behavioral of p09_init is

    constant SSD1306_CONTROL_CMD    : std_logic_vector(7 downto 0) := x"00";
    constant SSD1306_CONTROL_DATA   : std_logic_vector(7 downto 0) := x"40";

    constant SSD1306_WIDTH          : natural := 128;
    constant SSD1306_HEIGHT         : natural := 64;



    type command_array_t is array (natural range <>) of std_logic_vector(7 downto 0);

    -- From ssd1306_init()
    constant INIT_CMDS : command_array_t := (
        x"AE",   --(index : 0)                      -- Display OFF
        x"D5", x"80",                  -- Set Display Clock Divide Ratio/Oscillator Frequency
        x"A8", std_logic_vector(to_unsigned(SSD1306_HEIGHT - 1, 8)), -- Set Multiplex Ratio (e.g., 63 for 64)
        x"D3", x"00",                  -- Set Display Offset
        x"40",                         -- Set Display Start Line (0)
        x"8D", x"14",                  -- Charge Pump Setting (Enable)
        x"20", x"00",                  -- Memory Addressing Mode (Horizontal Addressing)
        x"A1",                         -- Segment Re-map (col 127 to SEG0)
        x"C8",                         -- COM Output Scan Direction (remapped)
        x"DA", x"12",                  -- Set COM Pins (0x12 for 128x64, 0x02 for 128x32)
        x"81", x"CF",--(index : 17 , 18)                 -- Set Contrast Control
        x"D9", x"F1",                  -- Set Pre-charge Period
        x"DB", x"40",                  -- Set VCOMH Deselect Level
        x"A4",                         -- Entire Display ON from RAM
        x"A6",       --(index : 24)                  -- Set Normal Display     Inverse display X"A7"
        x"2E",                         -- Deactivate Scroll
        x"AF"                          -- Display ON
    );

    constant CLEAR_X1_POS  : natural := 0;
    constant CLEAR_Y1_PAGE : natural := 0; -- y/8
    constant CLEAR_X2_POS  : natural := SSD1306_WIDTH-1;
    constant CLEAR_Y2_PAGE : natural := (SSD1306_HEIGHT / 8) - 1; -- y/8
    
    constant CLEAR_SETUP_CMDS : command_array_t := (
        x"21",  std_logic_vector(to_unsigned( CLEAR_X1_POS , 8)), std_logic_vector(to_unsigned( CLEAR_X2_POS , 8)),       -- Set Col Addr: 0 to WIDTH-1
        x"22",  std_logic_vector(to_unsigned( CLEAR_Y1_PAGE , 8)), std_logic_vector(to_unsigned( CLEAR_Y2_PAGE , 8)) -- Set Page Addr: 0 to (HEIGHT/8)-1
    );constant CLEAR_FILL_TOTAL_BYTES : natural := SSD1306_WIDTH * (SSD1306_HEIGHT / 8); -- e.g., 128 * 8 = 1024




signal Si_init_mode      : std_logic_vector(3 downto 0) := "0000" ;
--signal MODe : command_array_t := (
--         x"00" , x"00" , x"00" 
--    );
    type Mcommand_array_t is array (integer range 0 to 2) of std_logic_vector(7 downto 0);
    type command_buffer_array_t is array (integer range 0 to 15) of Mcommand_array_t;
  --  signal Si_page_number : std_logic_vector(7 downto 0 ) := "00000"& page_number ;
constant  MOD_SETUP_CMDS : command_buffer_array_t := (
        ( x"00" , x"00" , x"00" ) , --nop index 0000
        ( x"21",  x"00" , x"7F" ) ,     -- Set Col Addr: 0 to WIDTH-1 index 0001
        ( x"A6" , x"00" , x"00" ) ,-- index 0010        normal
        ( x"A7" , x"00" , x"00" ) ,-- index 0011        inverse
        ( x"20" , x"00" , x"00" ) ,-- index 0100     MaM H
        ( x"20" , x"01" , x"00" ) ,-- index 0101     MaM V
        ( x"20" , x"02" , x"00" ) ,-- index 0110     MaM P
        ( x"22" , x"00" , x"07" ) ,-- Set Page Addr: 0 to (HEIGHT/8)-1 index 0111
        
        ( x"81" , x"19" , x"00" ) ,--nop index 1000 contrast control 25
        ( x"81" , x"3C" , x"00" ) ,--nop index 1001 contrast control 60
        ( x"81" , x"64" , x"00" ) ,--nop index 1010 contrast control 100
        ( x"81" , x"7D" , x"00" ) ,--nop index 1011 contrast control 125
        ( x"81" , x"96" , x"00" ) ,--nop index 1100 contrast control 150
        ( x"81" , x"AF" , x"00" ) ,--nop index 1101 contrast control 175
        ( x"81" , x"C8" , x"00" ) ,--nop index 1110 contrast control 200
        ( x"81" , x"F0" , x"00" ) --nop index 1111 contrast control 240
        
        
    );








    
    

type state_t is (                  
    St_CHECK_Init    ,--   if tribe_pre_busy = 0  if MInitactv = 0 then ST_TRIBE = St_SET_CInit else ST_TRIBE = St_SET_MInit
    St_SET_CInit     ,--  index = 0 , Si_init_busy = 1 ,  tribe_busy = 1  ST_TRIBE = St_SEND_CInit                                                                 
    St_SEND_CInit    ,--  send command(index) ,   ST_TRIBE = St_WAIT_CInit .                                                                                       
    St_WAIT_CInit    ,--  if index < length (if tribe_pre_done = 1 then  ST_TRIBE = St_SEND_CInit INCindex) else  ST_TRIBE = St_DONE_Init                    
    St_SET_MInit     ,--  set index = 0  , Si_init_busy = 1 , ST_TRIBE = St_SEND_MInit                                                                                                   
    St_SEND_MInit    ,--  send command(index) ,   ST_TRIBE = St_WAIT_MInit                                                                                                               
    St_WAIT_MInit    ,-- if index < length (if tribe_pre_done = 1 then  ST_TRIBE = St_SEND_MInit INCindex) else  ST_TRIBE = St_DONE_Init                                           
    St_DONE_Init     ,--  set init_busy = 0 , init_done = 1 , MInitactv = 1 , ST_TRIBE = St_CHECK_STR
         
                
    ------    direct coppy
    S_CLEAR_SETUP_START  ,
    S_CLEAR_SETUP_SEND   ,
    S_CLEAR_SETUP_WAIT   ,
    S_CLEAR_FILL_START   ,
    S_CLEAR_FILL_SEND    ,
    S_CLEAR_FILL_WAIT

    );
signal ST_INIT  : state_t := St_CHECK_Init;


signal Si_MInitactv : std_logic := '0' ;
signal Si_index_init : integer range 0 to 1200 := 0 ;
signal Si_init_busy       :   std_logic := '0';
signal Si_init_done       :   std_logic := '0';












begin
init_busy  <= Si_init_busy ;
init_done  <= Si_init_done ;
Si_init_mode <= init_mode  ;


process (clk) begin 
    if rising_edge(clk) and (init_ena = '1') then 
        if (init_rst = '1') then
        
        else 
        
            case (ST_INIT) is
                when St_CHECK_Init  => --   if tribe_pre_busy = 0  if Si_MInitactv = 0 then ST_TRIBE = St_SET_CInit else ST_TRIBE = St_SET_MInit      
                    if ( init_activate = '1' ) and ( tribe_pre_busy = '0')  then
                        if ( Si_MInitactv = '0' ) then
                            ST_INIT <= St_SET_CInit ;
                        else 
                            ST_INIT <= St_SET_MInit ;
--                            if (Si_init_mode = x"1") then                                                   
--                            MOD_SETUP_CMDS( to_integer( unsigned(Si_init_mode) ) )(1) <= colum_number      ;        
--                            elsif (Si_init_mode = x"7") then                                              
--                            MOD_SETUP_CMDS( to_integer( unsigned(Si_init_mode) ) )(1) <= "0000" & page_number ;
--                            end if ;
                            
                        end if ;
                    end if ;         
                          
                when St_SET_CInit   => --  index = 0 , Si_init_busy = 1 ,  tribe_busy = 1  ST_TRIBE = St_SEND_CInit 
                    Si_index_init <= 0;
                    Si_init_busy   <= '1';
                    Si_init_done   <= '0'; 
                    ST_INIT <= St_SEND_CInit ; 
                                     
                when St_SEND_CInit  => --  send command(index) ,   ST_TRIBE = St_WAIT_CInit .               
                    if (Si_index_init < INIT_CMDS'length ) then 
                        if (tribe_pre_busy = '0') then
                            ST_INIT <= St_WAIT_CInit ;
                            i2c_tx_req_4pre <= '1' ;
                            i2c_tx_byte1_4pre <= SSD1306_CONTROL_CMD ;
                            i2c_tx_byte2_4pre  <= INIT_CMDS(Si_index_init);
                            
                        end if ;
                    else
                        ST_INIT <= St_DONE_Init ;
                        
                    end if ;
                    
                                                                      
                when St_WAIT_CInit  => --  if index < length (if tribe_pre_done = 1 then  ST_TRIBE = St_SEND_CInit INCindex) else  ST_TRIBE = St_DONE_Init 
                    i2c_tx_req_4pre <= '0' ;
                    if (tribe_pre_done = '1') then
                        ST_INIT <= St_SEND_CInit ;
                        Si_index_init <= Si_index_init +1;
                    end if ;
                    
                --------------------------------------------------------------
                
                ---------------- CLEAR DISPLAY SETUP SEQUENCE ----------------
                when S_CLEAR_SETUP_START =>
                    Si_index_init      <= 0;
                    ST_INIT <= S_CLEAR_SETUP_SEND;

                when S_CLEAR_SETUP_SEND =>
                
                    if Si_index_init < CLEAR_SETUP_CMDS'length then
                        if tribe_pre_busy = '0'then
                            i2c_tx_byte1_4pre <= SSD1306_CONTROL_CMD;
                            i2c_tx_byte2_4pre <= CLEAR_SETUP_CMDS(Si_index_init);
                            i2c_tx_req_4pre <= '1';
                            ST_INIT <= S_CLEAR_SETUP_WAIT;
                        end if;
                    else
                        ST_INIT <= S_CLEAR_FILL_START;
                    end if;

                when S_CLEAR_SETUP_WAIT => 
                    i2c_tx_req_4pre <= '0' ;
                    if tribe_pre_done = '1' then
                         
                        Si_index_init <= Si_index_init + 1;
                        ST_INIT <= S_CLEAR_SETUP_SEND;
                        
                    end if;

                ---------------- CLEAR DISPLAY FILL SEQUENCE ----------------
                when S_CLEAR_FILL_START => 
                    Si_index_init    <= 0;
                    ST_INIT <= S_CLEAR_FILL_SEND;

                when S_CLEAR_FILL_SEND => 
                
                    if Si_index_init < CLEAR_FILL_TOTAL_BYTES then
                        if tribe_pre_busy = '0'then
                            i2c_tx_byte1_4pre <= SSD1306_CONTROL_DATA;
                            i2c_tx_byte2_4pre <= x"00"; -- Data to clear screen
                            i2c_tx_req_4pre <= '1';
                            ST_INIT <= S_CLEAR_FILL_WAIT;
                        end if;
                    else
                        ST_INIT <= St_DONE_Init;
                        
                    end if;

                when S_CLEAR_FILL_WAIT => 
                    i2c_tx_req_4pre <= '0' ;
                    if tribe_pre_done = '1' then
                            Si_index_init <= Si_index_init + 1;
                            ST_INIT <= S_CLEAR_FILL_SEND;
                            
                    end if;

                
                
                
                ---------------------------------------------------------------------------------------------------------------------------
                when St_SET_MInit   => --  set index = 0  , Si_init_busy = 1 , ST_TRIBE = St_SEND_MInit    
                    ST_INIT <= St_SEND_MInit ;      
                    Si_index_init <= 0;    
                    Si_init_busy   <= '1'; 
                    Si_init_done   <= '0'; 
                 --   MODe <= MOD_SETUP_CMDS( to_integer( unsigned(Si_init_mode) ) );
                                                                  
                when St_SEND_MInit  => --  send command(index) ,   ST_TRIBE = St_WAIT_MInit  
                 --   if ( Si_index_init<MODe'length ) then 
                      if ( Si_index_init< MOD_SETUP_CMDS( to_integer( unsigned(Si_init_mode) ) )'length ) then 
                 
                        if (tribe_pre_busy = '0') then
                            ST_INIT <= St_WAIT_MInit ;
                            i2c_tx_req_4pre <= '1' ;
                            i2c_tx_byte1_4pre <= SSD1306_CONTROL_CMD ;
                 --           i2c_tx_byte2_4pre  <= MODe(Si_index_init);
                            
                            if  ( Si_index_init = 1) then
                                if (Si_init_mode = x"1")then
                                    i2c_tx_byte2_4pre  <=    colum_number      ;   
                                elsif (Si_init_mode = x"7") then
                                    i2c_tx_byte2_4pre  <=   "00000" & page_number ;
                                end if ;
                            else
                            i2c_tx_byte2_4pre  <= MOD_SETUP_CMDS( to_integer( unsigned(Si_init_mode) ) )(Si_index_init);
                            end if ;
                            
                        end if ;
                    else
                        ST_INIT <= St_DONE_Init ;
                        
                    end if ;
                    
                                                                                     
                when St_WAIT_MInit  => -- if index < length (if tribe_pre_done = 1 then  ST_TRIBE = St_SEND_MInit INCindex) else  ST_TRIBE = St_DONE_Init  
                    
                    
                    i2c_tx_req_4pre <= '0' ;
                     if (tribe_pre_done = '1') then
                            ST_INIT <= St_SEND_MInit ;
                            Si_index_init <= Si_index_init +1;
                        end if ;
                    
                    
                when St_DONE_Init   => --  set init_busy = 0 , init_done = 1 , Si_MInitactv = 1 , if ( init_activate = '0' ) then ST_TRIBE = St_CHECK_Init                                            
                    init_busy <= '0';
                    init_done <= '1';
                    Si_MInitactv <= '1';
                    if ( init_activate = '0' ) then
                        ST_INIT <= St_CHECK_Init ;
                        
                    end if ;
            
            end case ;
        end if ;
    end if ;
end process ;


end Behavioral;
