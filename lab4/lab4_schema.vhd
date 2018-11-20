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
  signal clk_filtered : std_logic := '0';

  constant clk_duration : time := 4 ns;
begin

  process(c)
  variable c_delta : time;
  begin
    clk_prev_t <= now;

    c_delta := now - clk_prev_t;
    if ((c_delta < clk_duration) ) and (c_delta > 0 ns) then
      clk_filtered <= 'X';
      assert false report "C need at least 4ns wait between switching" severity error;
    else
      clk_filtered <= c;
    end if;

  end process;

  --TODO:

  -- outs
  q <= val;
end main_arch ; -- main_arch
