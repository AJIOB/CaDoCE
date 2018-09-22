library IEEE;
use IEEE.std_logic_1164.all;

entity schema_behav is
  port (
    x1, x2, x3, x4: in std_logic;
    y1, y2, y3, y4: out std_logic
  ) ;
end schema_behav ;

architecture main_arch of schema_behav is
  signal d2: std_logic;
begin

  d2 <= ((x1) and (not x2) and (x3)) or ((not x1) and (x2) and (not x3)) or ((x2) and (not x4)) or ((not x1) and (not x4));
  
  -- outs
  y1 <= (((not x3) and (not d2)) or ((not x1) and  (not x3)) or ((d2) and (not x1) and (not x2)));
  y2 <= x3 and ((not x1) or (not x2) or x4);
  y3 <= d2;
  y4 <= '0';
end main_arch ; -- main_arch
