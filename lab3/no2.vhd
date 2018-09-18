library IEEE;
use IEEE.std_logic_1164.all;

entity no2 is
  port (
    x1, x2: in std_logic;
    y:      out std_logic
  ) ;
end no2 ;

architecture my_arch of no2 is
begin
    y <= not (x1 or x2) after 3 ns;
end my_arch ; -- my_arch
