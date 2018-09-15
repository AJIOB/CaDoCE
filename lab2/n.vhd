library IEEE;
use IEEE.std_logic_1164.all;

entity n is
  port (
    x: in std_logic;
    y: out std_logic
  ) ;
end n ;

architecture my_arch of n is
begin
    y <= not x after 1 ns;
end my_arch ; -- my_arch
