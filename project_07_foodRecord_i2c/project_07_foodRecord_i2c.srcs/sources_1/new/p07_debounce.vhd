library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity p07_debounce is
  generic (
    CLK_FREQ_HZ     : integer := 100_000_000; -- Clock frequency in Hz
    STABLE_TIME_MS  : integer := 20           -- Stable time in ms for debounce
  );
  port (
    clk_i           : in  std_logic;
    reset_n_i       : in  std_logic;
    button_in_i     : in  std_logic;
    button_out_o    : out std_logic
  );
end entity p07_debounce;

architecture rtl of p07_debounce is
  constant COUNTER_MAX_VALUE  : integer := (CLK_FREQ_HZ / 1000) * STABLE_TIME_MS;
  signal counter_q            : integer range 0 to COUNTER_MAX_VALUE;
  signal button_sync1_q       : std_logic;
  signal button_sync2_q       : std_logic;
  signal button_state_q       : std_logic;
begin

  -- Synchronize the asynchronous button input
  sync_proc : process (clk_i, reset_n_i)
  begin
    if reset_n_i = '0' then
      button_sync1_q <= '0';
      button_sync2_q <= '0';
    elsif rising_edge(clk_i) then
      button_sync1_q <= button_in_i;
      button_sync2_q <= button_sync1_q;
    end if;
  end process sync_proc;

  -- Debounce logic
  debounce_proc : process (clk_i, reset_n_i)
  begin
    if reset_n_i = '0' then
      counter_q      <= 0;
      button_state_q <= '0';
    elsif rising_edge(clk_i) then
      if button_sync2_q /= button_state_q then
        -- Button state has changed, reset counter
        counter_q <= 0;
      elsif counter_q < COUNTER_MAX_VALUE then
        -- Button state is stable but not for long enough, increment counter
        counter_q <= counter_q + 1;
      else
        -- Button state has been stable for long enough, update output
        button_state_q <= button_sync2_q;
      end if;
    end if;
  end process debounce_proc;

  button_out_o <= button_state_q;

end architecture rtl;