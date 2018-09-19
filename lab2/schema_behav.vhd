library IEEE;
use IEEE.std_logic_1164.all;

entity schema_behav is
  port (
    x1, x2, x3, x4: in std_logic;
    y1, y2, y3, y4: out std_logic
  ) ;
end schema_behav ;

architecture main_arch of schema_behav is
begin
  -- outs
  y1 <= '0';
  y2 <= '0';
  y3 <= '0';
  y4 <= '0';
end main_arch ; -- main_arch
