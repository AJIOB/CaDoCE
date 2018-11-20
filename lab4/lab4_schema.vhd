library IEEE;
use IEEE.std_logic_1164.all;

entity lab4_schema is
  port (
    d, c, r: in std_logic;
    q: out std_logic
  ) ;
end lab4_schema ;

architecture main_arch of lab4_schema is
  signal val : std_logic := 'Z';

  signal clk_prev_t : time := 0 ns;

  constant clk_duration : time := 5 ns;
begin

  process(c)

  begin
    clk_prev_t <= now;

    if (c = '0') then
      val <= d;
    elsif (c = '1' and ((now - clk_prev_t) > clk_duration)) then
      val <= not d;
    -- elsif (c'event and (c'last_event < 30 ns)) then
    --   val <= 'X';
    else
      val <= 'X';
    end if;
    --TODO:
  end process;

  -- outs
  q <= val;
end main_arch ; -- main_arch
