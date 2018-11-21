library IEEE;
use IEEE.std_logic_1164.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity lab4_schema_test_scagener is
end lab4_schema_test_scagener ;

architecture my_arch of lab4_schema_test_scagener is
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

    R <= '1', '0' after 50 ns, '0' after 100 ns, '0' after 150 ns, '0' after 200 ns, '1' after 250 ns, '1' after 300 ns;

	D <= '0', '0' after 50 ns, '1' after 100 ns, '1' after 150 ns, '1' after 200 ns, '1' after 250 ns, '0' after 300 ns;

	C <= '0', '1' after 50 ns, '0' after 100 ns, '1' after 150 ns, '0' after 200 ns, '0' after 250 ns, '1' after 300 ns;

end my_arch ; -- my_arch
