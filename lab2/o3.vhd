library IEEE;
use IEEE.std_logic_1164.all;

entity o3 is
  port (
    x1, x2, x3: in std_logic;
    y: out std_logic
  ) ;
end o3 ;

architecture my_arch of o3 is
begin
    y <= (x1 or x2 or x3) after 3 ns;
end my_arch ; -- my_arch
