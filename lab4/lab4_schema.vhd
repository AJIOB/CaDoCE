library IEEE;
use IEEE.std_logic_1164.all;

entity lab4_schema is
  port (
    d, c, r: in std_logic;
    q: out std_logic
  ) ;
end lab4_schema ;

architecture main_arch of lab4_schema is
    component n
        port (
          x: in std_logic;
          y: out std_logic
        ) ;
    end component;
    component no2
        port (
          x1, x2: in std_logic;
          y:      out std_logic
        ) ;
    end component;
    component noa22
        port (
          x1, x2, x3, x4: in std_logic;
          y: out std_logic
        ) ;
    end component;

    signal x1, x2, x3, x4, x5, x7, x8: std_logic;
begin
    xx1: n port map (x8, x1);
    xx2: noa22 port map (x3, x1, d, x8, x2);
    xx3: no2 port map (r, x2, x3);
    xx4: noa22 port map (x5, x8, x3, x1, x4);
    xx5: no2 port map (r, x4, x5);
    xx7: n port map (x4, x7);
    xx8: n port map (c, x8);

    -- outs
    q <= x7;
end main_arch ; -- main_arch
