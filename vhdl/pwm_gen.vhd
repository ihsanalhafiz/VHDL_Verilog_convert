-- pwm_gen.vhd : PWM generator built on top of the counter entity
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_gen is
  generic (
    WIDTH : positive := 8
  );
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    duty  : in  std_logic_vector(WIDTH-1 downto 0);  -- duty cycle (0 = always low)
    pwm   : out std_logic
  );
end entity pwm_gen;

architecture rtl of pwm_gen is
  signal count : std_logic_vector(WIDTH-1 downto 0);
begin
  u_counter : entity work.counter
    generic map (WIDTH => WIDTH)
    port map (
      clk   => clk,
      rst   => rst,
      en    => '1',
      count => count
    );

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        pwm <= '0';
      elsif unsigned(count) < unsigned(duty) then
        pwm <= '1';
      else
        pwm <= '0';
      end if;
    end if;
  end process;
end architecture rtl;
