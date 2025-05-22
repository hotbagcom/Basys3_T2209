----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.05.2025 15:18:49
-- Design Name: 
-- Module Name: p08_init - Behavioral
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
entity p08_init is
    generic (
        SYS_CLK_FREQ_HZ : integer := 100_000_000; -- For Basys3
        I2C_BUS_FREQ_HZ : integer := 400_000     -- SSD1306 can handle 400kHz
    );
    port (
        clk       : IN     STD_LOGIC := '0'; 
        reset_n   : IN     STD_LOGIC := '0'; 
--        ena       : IN     STD_LOGIC := '0';    
        
        
        --mode : 0 genel -   1 page -    2 horizontal 
        init_mode : in std_logic_vector(4 downto 0) := "0000" ;
        page_number   : in std_logic_vector(2 downto 0) := "000" ;
        colum_number : in std_logic_vector(7 downto 0) := x"00" ;
       
       
i2c_transaction_active : in  std_logic; 
start_i2c_transaction  : out  std_logic := '0';            
i2c_byte1              : out std_logic_vector(7 downto 0);
i2c_byte2              : out std_logic_vector(7 downto 0);
i2c_transaction_done   : out std_logic;                   
i2c_transaction_ack_err: out std_logic;                  
        
        busy : out std_logic := '0';
        done : out std_logic := '0';
        module_used_cntr : out std_logic_vector(3 downto 0 ) := "0000"

    );
end entity p08_init;

architecture behavioral of p08_init is

    -- SSD1306 Constants
    constant SSD1306_I2C_SLAVE_ADDR : std_logic_vector(6 downto 0) := "0111100"; -- 0x3C
    constant SSD1306_CONTROL_CMD    : std_logic_vector(7 downto 0) := x"00";
    constant SSD1306_CONTROL_DATA   : std_logic_vector(7 downto 0) := x"40";

    constant SSD1306_WIDTH          : natural := 128;
    constant SSD1306_HEIGHT         : natural := 64;

    -- ROM Definitions for command sequences (payloads only)
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
    );
    constant CLEAR_FILL_TOTAL_BYTES : natural := SSD1306_WIDTH * (SSD1306_HEIGHT / 8); -- e.g., 128 * 8 = 1024


    -- Main FSM states
    type main_fsm_state_t is (
        S_IDLE,--according to mode value 
        
        S_INIT_CMDS_START, S_INIT_CMDS_SEND, S_INIT_CMDS_WAIT,
        S_CLEAR_SETUP_START, S_CLEAR_SETUP_SEND, S_CLEAR_SETUP_WAIT,
        S_CLEAR_FILL_START, S_CLEAR_FILL_SEND, S_CLEAR_FILL_WAIT,
        
        S_MOD_SETUP_START, S_MOD_SETUP_SEND, S_MOD_SETUP_WAIT,
        
        
        
        S_ALL_DONE
    );
    signal current_main_state   : main_fsm_state_t := S_IDLE;
    signal command_index        : natural := 0;
    signal data_byte_count      : natural := 0;
    signal Si_init_mode         : std_logic_vector(4 downto 0) := "0000" ;
    signal Si_zero :  std_logic_vector(7 downto 0) := "00000000" ;
  

    signal MODe : command_array_t := (
         x"00" , x"00" , x"00" 
    );
    type command_buffer_array_t is array (integer) of command_array_t;
  --  signal Si_page_number : std_logic_vector(7 downto 0 ) := "00000"& page_number ;
    signal MOD_SETUP_CMDS : command_buffer_array_t := (
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
     
    -- Signals for i2c_transaction_sender instance
    signal sig_start_i2c_transaction : std_logic := '0';
    signal sig_i2c_byte1             : std_logic_vector(7 downto 0);
    signal sig_i2c_byte2             : std_logic_vector(7 downto 0);
    signal sig_i2c_transaction_active: std_logic;
    signal sig_i2c_transaction_done  : std_logic;
    signal sig_i2c_transaction_ack_err: std_logic;

    -- Signals for p05_mba_I2C instance
    signal i2c_ena_to_master    : std_logic;
    signal i2c_addr_to_master   : std_logic_vector(6 downto 0);
    signal i2c_rw_to_master     : std_logic;
    signal i2c_data_wr_to_master: std_logic_vector(7 downto 0);
    signal i2c_busy_from_master : std_logic;
    signal i2c_data_rd_from_master : std_logic_vector(7 downto 0); -- Not used in this design
    signal i2c_ack_err_from_master : std_logic;

    -- Delay counter for startup
    signal startup_delay_counter : unsigned(23 downto 0) := (others => '0'); -- Approx 0.16s at 100MHz
    constant STARTUP_DELAY_MAX : unsigned(23 downto 0) := to_unsigned(10000000, 24); -- Wait 10M cycles

begin

sig_start_i2c_transaction <= i2c_transaction_active;
 
start_i2c_transaction    <=  sig_start_i2c_transaction             ;
i2c_byte1                <=  sig_i2c_byte1                         ;
i2c_byte2                <=  sig_i2c_byte2                         ;
i2c_transaction_done     <=  sig_i2c_transaction_done              ;
i2c_transaction_ack_err  <=  sig_i2c_transaction_ack_err           ;

    
    process (  init_mode  ) begin
        if reset_n = '0' then
            Si_init_mode <= "0000";
        elsif  current_main_state = S_ALL_DONE then
           Si_init_mode <= init_mode ;
        end if ;
    end process ;

    process (clk , reset_n) begin
        if  falling_edge(clk) then
            MOD_SETUP_CMDS(1)(1) <=   colum_number ;
            MOD_SETUP_CMDS(7)(1)(2 downto 0) <=  page_number ;
        end if ;
    end process ;
    
    -- Main state machine process
    process(clk, reset_n)
    begin
    
        
        if reset_n = '1' then
            current_main_state <= S_IDLE;
            command_index      <= 0;
            data_byte_count    <= 0;
            sig_start_i2c_transaction <= '0';
            startup_delay_counter <= (others => '0');
        elsif rising_edge(clk) then
            -- Default actions / De-assert pulse
            sig_start_i2c_transaction <= '0';
            
            if current_main_state = S_ALL_DONE and (Si_init_mode /= "0000") then
                current_main_state <= S_MOD_SETUP_START;
            end if ;
            
            case current_main_state is
                when S_IDLE =>
                    if startup_delay_counter < STARTUP_DELAY_MAX then
                        startup_delay_counter <= startup_delay_counter + 1;
                    else
                        current_main_state <= S_INIT_CMDS_START;
                    end if;

                ---------------- INIT SEQUENCE ----------------
                when S_INIT_CMDS_START =>
                    command_index      <= 0;
                    current_main_state <= S_INIT_CMDS_SEND;

                when S_INIT_CMDS_SEND =>
                    if command_index < INIT_CMDS'length then
                        if sig_i2c_transaction_active= '0' then
                            sig_i2c_byte1 <= SSD1306_CONTROL_CMD;
                            sig_i2c_byte2 <= INIT_CMDS(command_index);
                            sig_start_i2c_transaction <= '1';
                            current_main_state <= S_INIT_CMDS_WAIT;
                        end if;
                    else
                        current_main_state <= S_CLEAR_SETUP_START; -- Move to next sequence
                    end if;

                when S_INIT_CMDS_WAIT =>
                    if sig_i2c_transaction_done = '1' then
                        if sig_i2c_transaction_ack_err = '1' then
                            current_main_state <= S_ALL_DONE; -- Or an error state
                        else
                            command_index <= command_index + 1;
                            current_main_state <= S_INIT_CMDS_SEND;
                        end if;
                    end if;

                ---------------- CLEAR DISPLAY SETUP SEQUENCE ----------------
                when S_CLEAR_SETUP_START =>
                    command_index      <= 0;
                    current_main_state <= S_CLEAR_SETUP_SEND;

                when S_CLEAR_SETUP_SEND =>
                    if command_index < CLEAR_SETUP_CMDS'length then
                        if sig_i2c_transaction_active = '0'then
                            sig_i2c_byte1 <= SSD1306_CONTROL_CMD;
                            sig_i2c_byte2 <= CLEAR_SETUP_CMDS(command_index);
                            sig_start_i2c_transaction <= '1';
                            current_main_state <= S_CLEAR_SETUP_WAIT;
                        end if;
                    else
                        current_main_state <= S_CLEAR_FILL_START;
                    end if;

                when S_CLEAR_SETUP_WAIT =>
                    if sig_i2c_transaction_done = '1' then
                         if sig_i2c_transaction_ack_err = '1' then
                            current_main_state <= S_ALL_DONE; -- Or an error state
                        else
                            command_index <= command_index + 1;
                            current_main_state <= S_CLEAR_SETUP_SEND;
                        end if;
                    end if;

                ---------------- CLEAR DISPLAY FILL SEQUENCE ----------------
                when S_CLEAR_FILL_START =>
                    data_byte_count    <= 0;
                    current_main_state <= S_CLEAR_FILL_SEND;

                when S_CLEAR_FILL_SEND =>
                    if data_byte_count < CLEAR_FILL_TOTAL_BYTES then
                        if sig_i2c_transaction_active = '0'then
                            sig_i2c_byte1 <= SSD1306_CONTROL_DATA;
                            sig_i2c_byte2 <= x"00"; -- Data to clear screen
                            sig_start_i2c_transaction <= '1';
                            current_main_state <= S_CLEAR_FILL_WAIT;
                        end if;
                    else
                        current_main_state <= S_ALL_DONE;
                    end if;

                when S_CLEAR_FILL_WAIT =>
                    if sig_i2c_transaction_done = '1' then
                        if sig_i2c_transaction_ack_err = '1' then
                            current_main_state <= S_ALL_DONE; -- Or an error state
                        else
                            data_byte_count <= data_byte_count + 1;
                            current_main_state <= S_CLEAR_FILL_SEND;
                        end if;
                    end if;

                ---------------- MOD SETUP SEQUENCE ----------------S_MOD_SETUP_START, S_MOD_SETUP_SEND, S_MOD_SETUP_WAIT,
                when S_MOD_SETUP_START =>
                    command_index      <= 0;
                    current_main_state <= S_MOD_SETUP_SEND;
                    
                    MODe <= MOD_SETUP_CMDS( to_integer( unsigned(Si_init_mode) ) );
                    
                    
                when S_MOD_SETUP_SEND =>
                
                    if command_index < MODe'length then
                        if sig_i2c_transaction_active = '0' then
                            sig_i2c_byte1 <= SSD1306_CONTROL_CMD;
                            sig_i2c_byte2 <= MODe(command_index);
                            sig_start_i2c_transaction <= '1';
                            current_main_state <= S_MOD_SETUP_WAIT;
                        end if;
                    else
                        current_main_state <= S_ALL_DONE;
                    end if;

                when S_MOD_SETUP_WAIT =>
                    if sig_i2c_transaction_done = '1' then
                        if sig_i2c_transaction_ack_err = '1' then
                            current_main_state <= S_ALL_DONE; -- Or an error state
                        else
                            command_index <= command_index + 1;
                            current_main_state <= S_MOD_SETUP_SEND;
                        end if;
                    end if;

               
                ---------------- ALL DONE ----------------
                when S_ALL_DONE =>
                    -- Stay here, OLED is configured and smiley is drawn.
                    null;

            end case;
        end if;
    end process;

end architecture behavioral;







