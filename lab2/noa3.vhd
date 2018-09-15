library IEEE;
use IEEE.std_logic_1164.all;

entity noa3 is
  port (
    x1, x2, x3, x4: in std_logic;
    y: out std_logic
  ) ;
end noa3 ;

architecture my_arch of noa3 is
begin
    y <= not (x1 or (x2 and x3 and x4)) after 5 ns;
end my_arch ; -- my_arch
