-- uart_tx.vhd : self-contained UART transmitter (8N1).
-- Two entities in one file: baud_gen is used by uart_tx, so uart_tx is the top.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity baud_gen is
  generic (
    CLKS_PER_BIT : positive := 16
  );
  port (
    clk  : in  std_logic;
    rst  : in  std_logic;
    en   : in  std_logic;
    tick : out std_logic
  );
end entity baud_gen;

architecture rtl of baud_gen is
  signal cnt : natural range 0 to CLKS_PER_BIT-1;
begin
  process (clk)
  begin
    if rising_edge(clk) then
      tick <= '0';
      if rst = '1' or en = '0' then
        cnt <= 0;
      elsif cnt = CLKS_PER_BIT-1 then
        cnt  <= 0;
        tick <= '1';
      else
        cnt <= cnt + 1;
      end if;
    end if;
  end process;
end architecture rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
  generic (
    CLKS_PER_BIT : positive := 16
  );
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    tx_start : in  std_logic;
    tx_data  : in  std_logic_vector(7 downto 0);
    tx       : out std_logic;
    busy     : out std_logic
  );
end entity uart_tx;

architecture rtl of uart_tx is
  type state_t is (IDLE, START, DATA, STOP);
  signal state   : state_t;
  signal shreg   : std_logic_vector(7 downto 0);
  signal bit_idx : unsigned(2 downto 0);
  signal tick    : std_logic;
  signal running : std_logic;
begin
  running <= '0' when state = IDLE else '1';
  busy    <= running;

  u_baud : entity work.baud_gen
    generic map (CLKS_PER_BIT => CLKS_PER_BIT)
    port map (clk => clk, rst => rst, en => running, tick => tick);

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        state   <= IDLE;
        tx      <= '1';
        shreg   <= (others => '0');
        bit_idx <= (others => '0');
      else
        case state is
          when IDLE =>
            tx <= '1';
            if tx_start = '1' then
              shreg <= tx_data;
              state <= START;
              tx    <= '0';
            end if;
          when START =>
            if tick = '1' then
              tx      <= shreg(0);
              bit_idx <= (others => '0');
              state   <= DATA;
            end if;
          when DATA =>
            if tick = '1' then
              if bit_idx = 7 then
                tx    <= '1';
                state <= STOP;
              else
                shreg   <= '0' & shreg(7 downto 1);
                tx      <= shreg(1);
                bit_idx <= bit_idx + 1;
              end if;
            end if;
          when STOP =>
            if tick = '1' then
              state <= IDLE;
            end if;
        end case;
      end if;
    end if;
  end process;
end architecture rtl;
