library IEEE;
use IEEE.std_logic_1164.all;

entity naoa2 is
  port (
    x1, x2, x3, x4: in std_logic;
    y: out std_logic
  ) ;
end naoa2 ;

architecture my_arch of naoa2 is
begin
  y <= not (x1 and (x2 or (x3 and x4))) after 4 ns;
end my_arch ; -- my_arch