----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2025 17:18:33
-- Design Name: 
-- Module Name: p09_preMBA - Behavioral
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

entity p09_preMBA is
    Port ( 
    
    clk : in std_logic  := '0';
    pre_rst      :  in std_logic := '0';
    pre_ena      :  in std_logic := '0'; 
    
    -- Control Inputs
    pre_activate :  in std_logic := '0';  -- start_transaction   : in  std_logic; -- continious Pulse to initiate
    slave_i2c_addr      : in  std_logic_vector(6 downto 0);
    byte1_to_send       : in  std_logic_vector(7 downto 0); -- Typically SSD1306_COMMAND or SSD1306_DATA
    byte2_to_send       : in  std_logic_vector(7 downto 0); -- Actual command or data
   
    --Status Outputs  
      pre_busy   :  out std_logic := '0'; -- transaction_active  : out std_logic := '0';                                      
      pre_done   :  out std_logic := '0'; -- transaction_done    : out std_logic := '0'; -- Pulses high for one clock when done  
      pre_error  :  out std_logic := '0'; -- transaction_ack_err : out std_logic := '0';                                     
      
   
sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
scl       : INOUT  STD_LOGIC                   --serial clock output of i2c bus
      
      );
end p09_preMBA;

architecture Behavioral of p09_preMBA is


signal Si_reset_n                 : STD_LOGIC := '0';                    --active low reset                   
signal Si_i2c_ena_to_master       : STD_LOGIC:= '0';                    --latch in command                          
signal Si_i2c_addr_to_master      : STD_LOGIC_VECTOR(6 DOWNTO 0):= "0000000"; --address of target slave                   
signal Si_i2c_rw_to_master        : STD_LOGIC:= '0';                    --'0' is write, '1' is read                 
signal Si_i2c_data_wr_to_master   : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00"; --data to write to slave                    
signal Si_i2c_busy_from_master    : STD_LOGIC:= '0';                    --indicates transaction in progress         
signal Si_i2c_data_rd_from_master : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00"; --data read from slave                      
signal Si_i2c_ack_err_from_master : STD_LOGIC:= '0';                    --flag if improper acknowledge from slave   
  --   signal Si_sda                     : STD_LOGIC;                    --serial data output of i2c bus             
  --   signal Si_scl                     : STD_LOGIC;                                                                




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


p05_mba_I2C_mdl : entity work.p05_mba_I2C
    Port MAP(
     clk         =>    clk   , 

    --clk       : IN     STD_LOGIC;                  --system clock
    reset_n     => Si_reset_n                  ,     --active low reset
    ena         => Si_i2c_ena_to_master        ,     --latch in command
    addr        => Si_i2c_addr_to_master       ,     --address of target slave
    rw          => Si_i2c_rw_to_master         ,     --'0' is write, '1' is read
    data_wr     => Si_i2c_data_wr_to_master    ,     --data to write to slave
      busy      => Si_i2c_busy_from_master     ,     --indicates transaction in progress
      data_rd   => Si_i2c_data_rd_from_master  ,     --data read from slave
    ack_error   => Si_i2c_ack_err_from_master  ,     --flag if improper acknowledge from slave
     sda        => sda                      ,     --serial data output of i2c bus
     scl        => scl        
    );



    process( clk )
    begin
    if (rising_edge(clk)) then
        if pre_rst = '0' then
            current_state              <= S_IDLE;
            Si_i2c_ena_to_master       <= '0';                  
            Si_i2c_rw_to_master        <= '0'; -- Fixed to write
            pre_busy             <= '0';
            pre_done             <= '0';
            pre_error            <= '0';
            prev_i2c_master_busy <= '0';
            internal_ack_error   <= '0';
        else
            -- Default actions / De-assert pulses
            pre_done <= '0';

            -- Store previous busy state for edge detection
            prev_i2c_master_busy <= Si_i2c_busy_from_master;
            
            case current_state is                                                                
                when S_IDLE =>                                                                   
                    pre_busy  <= '0';                                                  
                    pre_error <= '0'; -- Clear error for next transaction              
                    internal_ack_error        <= '0';                                                  
                    Si_i2c_ena_to_master      <= '0';                                                  
                    if pre_activate = '1' then                                              
                        Si_i2c_addr_to_master    <= slave_i2c_addr;                                    
                        Si_i2c_rw_to_master      <= '0'; -- Write operation                            
                        Si_i2c_data_wr_to_master <= byte1_to_send;                                     
                        Si_i2c_ena_to_master     <= '1';                                               
                        pre_busy <= '1';                                               
                        current_state      <= S_TRIGGER_BYTE1; -- Changed to S_TRIGGER_BYTE1     
                    end if;                                                                      
                                                                                                 
                when S_TRIGGER_BYTE1 => -- ena is high, data_wr has byte1
                    -- Wait for the I2C master to pick up the first byte.
                    -- Busy will go from 0 to 1.
                    if Si_i2c_busy_from_master = '1' and prev_i2c_master_busy = '0' then
                        current_state <= S_WAIT_BUSY_RISE_FOR_BYTE1;
                    end if;
                    -- If master_busy is already '1' (e.g. if start pulse was held),
                    -- this logic might need adjustment or assume start_transaction is a single cycle pulse.
                    -- For now, assume simple 0->1 transition after ena goes high.

                when S_WAIT_BUSY_RISE_FOR_BYTE1 =>        
                    -- Master is busy with byte1. Now prepare and send byte2.
                    -- ena is still '1'. Change data_wr for the I2C master to pick up next.
                    Si_i2c_data_wr_to_master <= byte2_to_send;
                    current_state           <= S_TRIGGER_BYTE2;

                when S_TRIGGER_BYTE2 =>      
                    -- Wait for I2C master to effectively start sending byte2.
                    -- This means busy might have gone 1->0 (byte1 done) then 0->1 (byte2 starts).
                    -- Or, if the I2C master keeps busy high for consecutive internal bytes,
                    -- we need a different signal.
                    -- Given the IP's example (external busyCntr increments on 0->1 busy transitions),
                    -- we assume a 0->1 transition for each byte the IP processes *if* it were separate internal ops.
                    -- More simply: wait for busy to go low (byte1 finished) then it will go high again for byte2.
                    if Si_i2c_busy_from_master = '0' and prev_i2c_master_busy = '1' then -- byte 1 ack phase is over
                        current_state <= S_WAIT_BUSY_RISE_FOR_BYTE2;
                    end if;
                    -- Capture any ack error from the first byte
                    if Si_i2c_ack_err_from_master = '1' then
                       internal_ack_error <= '1';
                    end if;


                when S_WAIT_BUSY_RISE_FOR_BYTE2 =>   
                     -- Now master should become busy sending the second byte
                    if Si_i2c_busy_from_master = '1' and prev_i2c_master_busy = '0' then
                        current_state <= S_TRIGGER_STOP;
                    end if;

                when S_TRIGGER_STOP =>    
                    -- Master is busy with byte2. Tell it to STOP after byte2.
                    Si_i2c_ena_to_master <= '0';
                    current_state  <= S_WAIT_BUSY_FALL_FINAL;
                     -- Capture any ack error from the second byte (though master ack_error might be sticky)
                    if Si_i2c_ack_err_from_master = '1' then
                       internal_ack_error <= '1';
                    end if;

                when S_WAIT_BUSY_FALL_FINAL =>
                    -- Wait for the I2C master to become non-busy.
                    if Si_i2c_busy_from_master = '0' and prev_i2c_master_busy = '1' then
                        pre_done    <= '1';
                        pre_busy  <= '0';
                        pre_error <= internal_ack_error or Si_i2c_ack_err_from_master; -- Combine potential errors
                        current_state       <= S_IDLE;
                    end if;
                    -- Ensure ack_error is captured if it asserts late
                    if Si_i2c_ack_err_from_master = '1' then
                       internal_ack_error <= '1';
                    end if;

            end case;
        end if;
    end if ;
end process ;

end Behavioral;
