----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.05.2025 16:26:17
-- Design Name: 
-- Module Name: p08_preMBA - Behavioral
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

--entity p08_preMBA is
----  Port ( );
--end p08_preMBA;

--architecture Behavioral of p08_preMBA is

--begin
-- diðer modüllerden biri silinecek 

--end Behavioral;

entity p08_preMBA is
    Port (
    
        -- OLED Control Inputs
        init_start_transaction   : in  std_logic; -- Pulse to initiate
        init_slave_i2c_addr      : in  std_logic_vector(6 downto 0);
        init_byte1_to_send       : in  std_logic_vector(7 downto 0); -- Typically SSD1306_COMMAND or SSD1306_DATA
        init_byte2_to_send       : in  std_logic_vector(7 downto 0); -- Actual command or data
        
        -- Init Status Outputs
        init_transaction_active  : out std_logic := '0';
        init_transaction_done    : out std_logic := '0'; -- Pulses high for one clock when done
        init_transaction_ack_err : out std_logic := '0';
    
        -- Interface to p05_mba_I2C master
        i2c_master_ena      : out std_logic := '0';
        i2c_master_addr     : out std_logic_vector(6 downto 0);
        i2c_master_rw       : out std_logic := '0'; -- Always write for SSD1306 commands/data
        i2c_master_data_wr  : out std_logic_vector(7 downto 0);
        i2c_master_busy     : in  std_logic;
        i2c_master_ack_error: in  std_logic ;-- From p05_mba_I2C (buffered)

    
    
    
    rst : in std_logic ;
    clk : in std_logic);
end p08_preMBA;

architecture Behavioral of p08_preMBA is    

    type state_t is (
        S_IDLE,
        S_TRIGGER_BYTE1,
        S_WAIT_BUSY_RISE_FOR_BYTE1,
        S_TRIGGER_BYTE2,
        S_WAIT_BUSY_RISE_FOR_BYTE2,
        S_TRIGGER_STOP,
        S_WAIT_BUSY_FALL_FINAL
    );
    signal current_state        : state_t := S_IDLE;
    signal prev_i2c_master_busy : std_logic := '0';
    signal internal_ack_error   : std_logic := '0';
    
    
    
begin


    process(clk, rst)
    begin
        if rst = '1' then
            current_state        <= S_IDLE;
            i2c_master_ena       <= '0';
            i2c_master_rw        <= '0'; -- Fixed to write
            init_transaction_active   <= '0';
            init_transaction_done     <= '0';
            init_transaction_ack_err  <= '0';
            prev_i2c_master_busy <= '0';
            internal_ack_error   <= '0';
        elsif rising_edge(clk) then
            -- Default actions / De-assert pulses
            init_transaction_done <= '0';

            -- Store previous busy state for edge detection
            prev_i2c_master_busy <= i2c_master_busy;

            case current_state is
                when S_IDLE =>
                    init_transaction_active  <= '0';
                    init_transaction_ack_err <= '0'; -- Clear error for next transaction
                    internal_ack_error  <= '0';
                    i2c_master_ena      <= '0';
                    if init_start_transaction = '1' then
                        i2c_master_addr    <= init_slave_i2c_addr;
                        i2c_master_rw      <= '0'; -- Write operation
                        i2c_master_data_wr <= init_byte1_to_send;
                        i2c_master_ena     <= '1';
                        init_transaction_active <= '1';
                        current_state      <= S_TRIGGER_BYTE1; -- Changed to S_TRIGGER_BYTE1
                    end if;

                when S_TRIGGER_BYTE1 => -- ena is high, data_wr has byte1
                    -- Wait for the I2C master to pick up the first byte.
                    -- Busy will go from 0 to 1.
                    if i2c_master_busy = '1' and prev_i2c_master_busy = '0' then
                        current_state <= S_WAIT_BUSY_RISE_FOR_BYTE1;
                    end if;
                    -- If master_busy is already '1' (e.g. if start pulse was held),
                    -- this logic might need adjustment or assume start_transaction is a single cycle pulse.
                    -- For now, assume simple 0->1 transition after ena goes high.

                when S_WAIT_BUSY_RISE_FOR_BYTE1 =>
                    -- Master is busy with byte1. Now prepare and send byte2.
                    -- ena is still '1'. Change data_wr for the I2C master to pick up next.
                    i2c_master_data_wr <= init_byte2_to_send;
                    current_state      <= S_TRIGGER_BYTE2;

                when S_TRIGGER_BYTE2 =>
                    -- Wait for I2C master to effectively start sending byte2.
                    -- This means busy might have gone 1->0 (byte1 done) then 0->1 (byte2 starts).
                    -- Or, if the I2C master keeps busy high for consecutive internal bytes,
                    -- we need a different signal.
                    -- Given the IP's example (external busyCntr increments on 0->1 busy transitions),
                    -- we assume a 0->1 transition for each byte the IP processes *if* it were separate internal ops.
                    -- More simply: wait for busy to go low (byte1 finished) then it will go high again for byte2.
                    if i2c_master_busy = '0' and prev_i2c_master_busy = '1' then -- byte 1 ack phase is over
                        current_state <= S_WAIT_BUSY_RISE_FOR_BYTE2;
                    end if;
                    -- Capture any ack error from the first byte
                    if i2c_master_ack_error = '1' then
                       internal_ack_error <= '1';
                    end if;


                when S_WAIT_BUSY_RISE_FOR_BYTE2 =>
                     -- Now master should become busy sending the second byte
                    if i2c_master_busy = '1' and prev_i2c_master_busy = '0' then
                        current_state <= S_TRIGGER_STOP;
                    end if;

                when S_TRIGGER_STOP =>
                    -- Master is busy with byte2. Tell it to STOP after byte2.
                    i2c_master_ena <= '0';
                    current_state  <= S_WAIT_BUSY_FALL_FINAL;
                     -- Capture any ack error from the second byte (though master ack_error might be sticky)
                    if i2c_master_ack_error = '1' then
                       internal_ack_error <= '1';
                    end if;

                when S_WAIT_BUSY_FALL_FINAL =>
                    -- Wait for the I2C master to become non-busy.
                    if i2c_master_busy = '0' and prev_i2c_master_busy = '1' then
                        init_transaction_done    <= '1';
                        init_transaction_active  <= '0';
                        init_transaction_ack_err <= internal_ack_error or i2c_master_ack_error; -- Combine potential errors
                        current_state       <= S_IDLE;
                    end if;
                    -- Ensure ack_error is captured if it asserts late
                    if i2c_master_ack_error = '1' then
                       internal_ack_error <= '1';
                    end if;

            end case;
        end if;
    end process;




end Behavioral;
