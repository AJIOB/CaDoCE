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
  y1 <= x1 or x2 or (not x3);
  y2 <= x3 and ((not x1) or (not x2) or x4);
  y3 <= ((x1) and (not x2) and (x3)) or ((not x1) and (x2) and (not x3)) or ((x2) and (not x4)) or ((not x1) and (not x4));
  y4 <= '0';
end main_arch ; -- main_arch
