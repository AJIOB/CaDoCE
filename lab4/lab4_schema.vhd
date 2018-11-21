library IEEE;
use IEEE.std_logic_1164.all;

entity lab4_schema is
  port (
    d, c, r: in std_logic;
    q: out std_logic
  ) ;
end lab4_schema ;

architecture main_arch of lab4_schema is
  signal val : std_logic := 'Z';

  signal d_prev_t : time := 0 ns;
  signal d_filtered : std_logic := '0';
  signal d_filtered_after_c : std_logic := '0';
  signal d_out_future_1 : std_logic := '0';

  signal clk_prev_t : time := 0 ns;
  signal c_filtered : std_logic := '0';
  signal c_out_now_for_d : std_logic := '0';

  signal r_prev_t : time := 0 ns;
  signal r_filtered : std_logic := '0';
  signal r_out_now : std_logic := '0';

  constant d_duration : time := 4 ns;
  constant clk_duration : time := 4 ns;
  constant r_duration : time := 4 ns;
begin

  process(c)
  variable c_delta : time;
  begin
    clk_prev_t <= now;

    c_delta := now - clk_prev_t;
    if ((c_delta < clk_duration) and (c_delta > 0 ns)) then
      c_filtered <= 'X';
      assert false report "C need at least 4ns wait between switching" severity error;
    else
      c_filtered <= c;
    end if;
  end process;

  process(r)
  variable r_delta : time;
  begin
    r_prev_t <= now;

    r_delta := now - r_prev_t;
    if ((r_delta < r_duration) and (r_delta > 0 ns) and (r = '0')) then
      r_filtered <= 'X';
      assert false report "R = 1 need at least 4ns wait between switching" severity error;
    else
      r_filtered <= r;
    end if;
  end process;

  process(d)
  variable d_delta : time;
  begin
    d_prev_t <= now;

    d_delta := now - d_prev_t;
    if ((d_delta < d_duration) and (d_delta > 0 ns)) then
      d_filtered <= 'X';
      assert false report "D need at least 4ns wait between switching" severity error;
    else
      d_filtered <= d;
    end if;
  end process;

  process(c_filtered)
  variable new_d : std_logic;
  variable d_delay_res : time := 0 ns;
  begin
    if (d_filtered = '1') then
      new_d := '1';
    elsif (d_filtered = '0') then
      new_d := '0';
    end if;

    if (c_filtered = '1') then
      if (not d_filtered'stable(3 ns)) then
        -- 0-2 ns
        d_filtered_after_c <= 'X';
        assert false report "D need to be stable at least 3ns before C rise" severity error;
      else
        d_filtered_after_c <= d_filtered;
        if (not d_filtered'stable(4 ns)) then
          -- 3 ns
          d_delay_res := 9 ns;
        elsif (not d_filtered'stable(5 ns)) then
          -- 4 ns
          d_delay_res := 8 ns;
        elsif (not d_filtered'stable(6 ns)) then
          -- 5 ns
          d_delay_res := 7 ns;
        elsif (d_filtered = '0') then
          -- 6 ns & more with d = 0
          d_delay_res := 6 ns;
        else
          -- 6 ns & more with d = 1
          d_delay_res := 7 ns;
        end if;
      end if;

      -- for cacting of c_out_now_for_d rising edge
      d_out_future_1 <= transport new_d after (d_delay_res - 1 ns);
    end if;

    c_out_now_for_d <= transport c_filtered after d_delay_res;
  end process;

  process(r_filtered)
  variable new_r : std_logic;
  begin
    if (r_filtered = '1') then
      new_r := '1';
    else
      new_r := '0';
    end if;

    r_out_now <= transport new_r after 8 ns;
  end process;

  process(r_out_now, d_out_future_1, c_out_now_for_d, d_filtered, d_filtered_after_c, c_filtered, r_filtered)
  variable is_signals_good : boolean;
  begin
    is_signals_good := true;
    is_signals_good := is_signals_good and ((d_filtered = '0') or (d_filtered = '1'));
    is_signals_good := is_signals_good and ((d_filtered_after_c = '0') or (d_filtered_after_c = '1'));
    is_signals_good := is_signals_good and ((c_filtered = '0') or (c_filtered = '1'));
    is_signals_good := is_signals_good and ((r_filtered = '0') or (r_filtered = '1'));

    if (not is_signals_good) then
      if (now > 0 ns) then
        -- don't send error at simulation begin
        assert false report "Some input was wrong. See errors before or check input values" severity error;
      end if;

      val <= 'X';
    else
      -- good input

      if (r_out_now = '1') then
        -- high priority R
        val <= '0';
      elsif (c_out_now_for_d'event and c_out_now_for_d = '1') then
        -- d changing
        val <= d_out_future_1;
      end if;
    end if;
  end process;

  -- outs
  q <= val;
end main_arch ; -- main_arch
