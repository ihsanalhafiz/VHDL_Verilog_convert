-- top.vhd : top level tying the PWM generator and the sequence detector together
library ieee;
use ieee.std_logic_1164.all;

entity top is
  generic (
    PWM_WIDTH : positive := 8
  );
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    duty    : in  std_logic_vector(PWM_WIDTH-1 downto 0);
    din     : in  std_logic;
    pwm_out : out std_logic;
    found   : out std_logic
  );
end entity top;

architecture rtl of top is
begin
  u_pwm : entity work.pwm_gen
    generic map (WIDTH => PWM_WIDTH)
    port map (
      clk  => clk,
      rst  => rst,
      duty => duty,
      pwm  => pwm_out
    );

  u_det : entity work.seq_detect
    port map (
      clk   => clk,
      rst   => rst,
      din   => din,
      found => found
    );
end architecture rtl;
