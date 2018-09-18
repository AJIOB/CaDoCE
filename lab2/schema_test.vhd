library IEEE;
use IEEE.std_logic_1164.all;

entity schema_test is
end schema_test ;

architecture my_arch of schema_test is
    component schema_struct
        port (
          x1, x2, x3, x4: in std_logic;
          y1, y2, y3, y4: out std_logic
        ) ;
    end component;
    signal x1, x2, x3, x4: std_logic;
    signal y1, y2, y3, y4: std_logic;
begin
    s1: schema_struct port map 
        (x1, x2, x3, x4,
         y1, y2, y3, y4);

    x1 <= '1', '1' after 100 ns, '0' after 200 ns,  '1' after 300 ns,  '1' after 400 ns,
               '0' after 500 ns, '0' after 600 ns,  '1' after 700 ns,  '0' after 800 ns,
               '0' after 900 ns, '0' after 1000 ns, '1' after 1100 ns, '1' after 1200 ns;
    x2 <= '1', '0' after 100 ns, '1' after 200 ns,  '1' after 300 ns,  '0' after 400 ns,
               '0' after 500 ns, '0' after 600 ns,  '1' after 700 ns,  '1' after 800 ns,
               '0' after 900 ns, '1' after 1000 ns, '1' after 1100 ns, '1' after 1200 ns;
    x3 <= '1', '0' after 100 ns, '0' after 200 ns,  '0' after 300 ns,  '1' after 400 ns,
               '1' after 500 ns, '1' after 600 ns,  '1' after 700 ns,  '1' after 800 ns,
               '0' after 900 ns, '1' after 1000 ns, '0' after 1100 ns, '0' after 1200 ns;
    x4 <= '1', '0' after 100 ns, '1' after 200 ns,  '0' after 300 ns,  '0' after 400 ns,
               '0' after 500 ns, '1' after 600 ns,  '0' after 700 ns,  '0' after 800 ns,
               '1' after 900 ns, '1' after 1000 ns, '1' after 1100 ns, '1' after 1200 ns;
end my_arch ; -- my_arch
