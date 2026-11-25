-- seq_detect.vhd : Moore FSM that detects the serial bit pattern "1011"
library ieee;
use ieee.std_logic_1164.all;

entity seq_detect is
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;     -- asynchronous, active high
    din   : in  std_logic;
    found : out std_logic
  );
end entity seq_detect;

architecture rtl of seq_detect is
  type state_t is (S_IDLE, S_1, S_10, S_101, S_1011);
  signal state, next_state : state_t;
begin
  -- state register
  process (clk, rst)
  begin
    if rst = '1' then
      state <= S_IDLE;
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  -- next-state logic
  process (state, din)
  begin
    next_state <= state;
    case state is
      when S_IDLE => if din = '1' then next_state <= S_1;    else next_state <= S_IDLE; end if;
      when S_1    => if din = '0' then next_state <= S_10;   else next_state <= S_1;    end if;
      when S_10   => if din = '1' then next_state <= S_101;  else next_state <= S_IDLE; end if;
      when S_101  => if din = '1' then next_state <= S_1011; else next_state <= S_10;   end if;
      when S_1011 => if din = '1' then next_state <= S_1;    else next_state <= S_10;   end if;
    end case;
  end process;

  -- Moore output
  found <= '1' when state = S_1011 else '0';
end architecture rtl;
