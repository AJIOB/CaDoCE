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
    signal d, r, q: std_logic;
    signal c: std_logic := '0';
    signal ready: std_logic := '0';

    constant c_half_period: time := 6 ns;
    constant r_delay: time := 4 ns;
    constant d_before_delay: time := 7 ns;
    constant d_after_delay: time := 4 ns;

    constant c_period: time := 2 * c_half_period;
    constant d_period_align: time := c_period - d_before_delay - d_after_delay;
    constant r_period_align: time := c_period - r_delay;
begin
    s1: lab4_schema port map (d, c, r, q);

    process
    begin
        -- init
        ready <= '0';
        r <= '1';
        d <= '0';
        wait for c_half_period * 3 - d_before_delay;

        -- d = '1', 2 periods
        r <= '0';
        d <= '1';
        wait for c_period * 2;

        -- reset, 1 delay
        r <= '1';
        wait for r_delay;

        -- d = '1', continue (1,...) period
        r <= '0';
        wait for r_period_align + c_period;

        -- d = '0', (1, ...) period
        d <= '0';
        wait for c_period + r_period_align;

        -- r = '1', 1 delay
        r <= '1';
        wait for r_delay;

        -- d = '0', 1 period
        r <= '0';
        wait for c_period;

        -- d = '1', (1, ...) period
        d <= '1';
        wait for c_period + r_period_align;
        
        -- r = '1', 1 delay
        r <= '1';
        wait for r_delay;

        -- d = '0', 1 period
        r <= '0';
        d <= '0';
        wait for c_period;
        
        -- r = '1' with d = '1', 1 delay
        r <= '1';
        d <= '1';
        wait for r_delay;

        -- d = '1', 1 period
        r <= '0';
        wait for c_period;

        ready <= '1';
        wait for c_period;

        wait;
    end process;

    c <= not c after c_half_period;

    file_work : process
        file file_res : text is out "output_results.txt";
        variable out_line : line;
    begin
        while (ready /= '1') loop
            wait for 1 ns;
            -- d r c
            write(out_line, d, right, 1);
            write(out_line, r, right, 1);
            write(out_line, c, right, 1);
            writeline(file_res, out_line);
        end loop;
        
        wait;
    end process ;
end my_arch ; -- my_arch
