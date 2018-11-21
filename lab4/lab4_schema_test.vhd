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
    signal d, r, q, q_struct: std_logic;
    signal c: std_logic := '0';
begin
    s1: lab4_schema port map (d, c, r, q);
    s_struct1: lab4_struct_schema port map (d, c, r, q_struct);

    R <= '1', '1' after 50 ns, '1' after 100 ns, '1' after 150 ns, '0' after 200 ns, '0' after 250 ns, '0' after 300 ns,
	'0' after 350 ns, '0' after 400 ns, '0' after 450 ns, '0' after 500 ns, '0' after 550 ns, '0' after 600 ns,
	'1' after 650 ns, '1' after 700 ns, '0' after 750 ns, '0' after 800 ns, '1' after 850 ns, '0' after 900 ns,
	'1' after 950 ns, '1' after 1000 ns;

	D <= '0', '0' after 50 ns, '1' after 100 ns, '1' after 150 ns, '1' after 200 ns, '1' after 250 ns, '1' after 300 ns,
	'1' after 350 ns, '0' after 400 ns, '0' after 450 ns, '0' after 500 ns, '1' after 550 ns, '0' after 600 ns,
	'0' after 650 ns, '0' after 700 ns, '1' after 750 ns, '1' after 800 ns, '0' after 850 ns, '0' after 900 ns,
	'1' after 950 ns, '1' after 1000 ns;

	C <= '0', '1' after 50 ns, '0' after 100 ns, '1' after 150 ns, '0' after 200 ns, '1' after 250 ns, '0' after 300 ns,
	'1' after 350 ns, '0' after 400 ns, '1' after 450 ns, '0' after 500 ns, '1' after 550 ns, '0' after 600 ns,
	'1' after 650 ns, '0' after 700 ns, '1' after 750 ns, '1' after 800 ns, '0' after 850 ns, '0' after 900 ns,
	'1' after 950 ns, '0' after 1000 ns;

end my_arch ; -- my_arch
