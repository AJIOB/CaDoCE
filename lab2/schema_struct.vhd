library IEEE;
use IEEE.std_logic_1164.all;

entity schema_struct is
  port (
    x1, x2, x3, x4: in std_logic;
    y1, y2, y3, y4: out std_logic
  ) ;
end schema_struct ;

architecture main_arch of schema_struct is
  signal a1: std_logic;
  signal b1, b2, b3, b4: std_logic;
  signal c1, c2, c3, c4, c5: std_logic;
  signal d1, d2, d3, d4: std_logic;
begin
  a1 <= not x1 after 1 ns;

  b1 <= not d2 after 1 ns;
  b2 <= not (x2 or a1) after 3 ns;
  b3 <= not (x3 or x1) after 3 ns;
  b4 <= not x4 after 1 ns;

  c1 <= not b1 after 1 ns;
  c2 <= (b1 or x1 or x2) after 3 ns;
  c3 <= not ((x3 and b2) or (x2 and b3)) after 4 ns;
  c4 <= not x2 after 1 ns;
  c5 <= not x3 after 1 ns;

  d1 <= not (c2 and (x3 or (c1 and x1))) after 4 ns;
  d2 <= not (c3 and (x4 or (c4 and x1))) after 4 ns;
  d3 <= not (c5 or (x1 and b4 and x2)) after 5 ns;
  d4 <= not (x4 or b4) after 3 ns;

  -- outs
  y1 <= d1;
  y2 <= d3;
  y3 <= d2;
  y4 <= d4;
end main_arch ; -- main_arch
