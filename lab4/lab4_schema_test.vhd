library IEEE;
use IEEE.std_logic_1164.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity lab4_schema_test is
end lab4_schema_test ;

architecture my_arch of lab4_schema_test is
    component lab4_schema
        port (
          d, c, r: in std_logic;
          q: out std_logic
        ) ;
      end component;
    component lab4_struct_schema
        port (
          d, c, r: in std_logic;
          q: out std_logic
        ) ;
      end component;
    signal d, r, q_behav, q_struct: std_logic;
    signal c: std_logic := '0';
begin
    s1: lab4_schema port map (d, c, r, q_behav);
    s_struct1: lab4_struct_schema port map (d, c, r, q_struct);

    -- D в 1
    -- тест для проверки времени предустановки D
    R <= '1', '0' after 50 ns; -- для D
    D <= '0', '1' after 297 ns; -- проверка предустановки D 3нс
    -- D <= '0', '1' after 298 ns; -- проверка предустановки D 2нс

    -- -- тест для проверки времени удержания D
    -- R <= '1', '0' after 50 ns; -- для D
    -- D <= '0', '1' after 297 ns,  '0' after 301 ns; -- проверка удержания D 4нс
    -- -- D <= '0', '1' after 297 ns,  '0' after 300 ns; -- проверка удержания D 3нс

    -- -- D в 0
    -- -- тест для проверки времени предустановки D
    -- R <= '0'; -- для D
    -- D <= '1', '0' after 298 ns; -- проверка предустановки D 2нс
    -- -- D <= '1', '0' after 299 ns; -- проверка предустановки D 1нс

    -- -- тест для проверки времени удержания D
    -- R <= '0'; -- для D
    -- D <= '1', '0' after 298 ns,  '1' after 301 ns; -- проверка удержания D 3нс
    -- -- D <= '1', '0' after 298 ns,  '1' after 300 ns; -- проверка удержания D 2нс

    -- -- R
    -- -- тест для проверки времени предустановки R
    -- R <= '0', '1' after 320 ns, '0' after 324 ns; -- проверка предустановки R 4нс
    -- -- R <= '0', '1' after 320 ns, '0' after 323 ns; -- проверка предустановки R 3нс
    -- D <= '1';

    C <= '0', '1' after 100 ns, '0' after 200 ns, '1' after 300 ns,
     '0' after 400 ns, '1' after 500 ns, '0' after 600 ns,
     '1' after 700 ns, '0' after 800 ns, '1' after 900 ns,
     '0' after 1000 ns, '1' after 1100 ns, '0' after 1200 ns,
     '1' after 1300 ns;

end my_arch ; -- my_arch
