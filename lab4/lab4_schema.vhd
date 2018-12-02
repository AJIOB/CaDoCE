library IEEE;
use IEEE.std_logic_1164.all;

entity lab4_schema is
  port (
    d, c, r: in std_logic;
    q: out std_logic
  ) ;
end lab4_schema ;

architecture main_arch of lab4_schema is
  signal signal_q : std_logic bus := 'Z';
  signal ideal_q : std_logic;

  signal schema_is_error : boolean := false;
  signal d_is_error : boolean := false;
  signal d_preinstall_is_error : boolean := false;
  signal c_is_error : boolean := false;
  signal r_is_error : boolean := false;

  signal d_prev_t : time := 0 ns;
  signal d_out_now : std_logic := '0';

  signal clk_prev_t : time := 0 ns;
  signal c_out_now_for_d : std_logic := '0';

  signal r_prev_t : time := 0 ns;
  signal r_out_now : std_logic := '0';

  --Минимальное время переключения D
  constant d_duration : time := 4 ns;
  --Минимальное время переключения C
  constant c_duration : time := 4 ns;
  --Минимальное время удержания '1' на R
  constant r_duration : time := 4 ns;

  --Время реакции триггера на фронт C
  constant d_res_delay : time := 9 ns;
  --Время реакции триггера на фронт R
  constant r_res_delay : time := 8 ns;

begin
  --Вывод уведомления про происхождении какой-либо ошибки
  assert not c_is_error report "C need at least 4ns wait between switching" severity error;
  assert not r_is_error report "R = 1 need at least 4ns wait between switching" severity error;
  assert not d_is_error report "D need at least 4ns wait between switching" severity error;
  assert not d_preinstall_is_error report "D need to be stable at least 3ns before C rise" severity error;

  --Процесс проверяет:
  --  время неизменности сигнала C
  --  корректность времени предустановки D
  --Используемые сигналы и переменные:
  --  c_delta - хранит время неизменности сигнала C
  --  clk_prev_t - хранит время предыдущего изменения сигнала C
  --  c_is_error - содержит true при ошибке минимальной длительности C, иначе false
  --  d_preinstall_is_error - содержит true при ошибке минимального времени предустановки D перед фронтом C, иначе false
  process(c)
  variable c_delta : time;
  begin
    clk_prev_t <= now;
    c_delta := now - clk_prev_t;
    c_is_error <= (c_delta < c_duration) and (c_delta > 0 ns);

    if (c'event and c = '1') then
      d_preinstall_is_error <= not d'stable(3 ns) and (c_delta > 0 ns);
    end if;
  end process;

  --Процесс проверяет:
  --  время неизменности сигнала R
  --Используемые сигналы и переменные:
  --  r_delta - хранит время неизменности сигнала R
  --  r_prev_t - хранит время предыдущего изменения сигнала R
  --  r_is_error - содержит true при ошибке минимальной длительности удержания '1' на R, иначе false
  process(r)
  variable r_delta : time;
  begin
    r_prev_t <= now;
    r_delta := now - r_prev_t;
    r_is_error <= ((r_delta < r_duration) and (r_delta > 0 ns) and (r = '0'));
  end process;

  --Процесс проверяет:
  --  время неизменности сигнала D
  --Используемые сигналы и переменные:
  --  d_delta - хранит время неизменности сигнала D
  --  d_prev_t - хранит время предыдущего изменения сигнала D
  --  d_is_error - содержит true при ошибке минимальной длительности изменения D, иначе false
  process(d)
  variable d_delta : time;
  begin
    d_prev_t <= now;
    d_delta := now - d_prev_t;
    d_is_error <= ((d_delta < d_duration) and (d_delta > 0 ns));
  end process;

  --Эмуляция задержки реакции триггера:
  --  c_out_now_for_d - смещенный на время реакции на фронт C сигнал С (по нему будет защелкиваться новый D)
  --  d_out_now - смещенный на время реакции на фронт C сигнал D (сигнал для защелкивания)
  --  r_out_now - смещенный на время реакции на фронт R сигнал R (приоритетный сигнал сброса)
  d_out_now <= transport d after d_res_delay;
  c_out_now_for_d <= transport c after d_res_delay;
  r_out_now <= transport r after r_res_delay;

  --Процесс эмуляции работы идеального триггера без задержек
  --Используемые сигналы и переменные:
  --  ideal_q - хранит выход идеального триггера (с учетом задержек)
  ideal_trigger: process(r_out_now, c_out_now_for_d)
  begin
    if (r_out_now = '1') then
      -- high priority R
      ideal_q <= '0';
    elsif (c_out_now_for_d'event and c_out_now_for_d = '1') then
      -- d changing
      ideal_q <= d_out_now;
    end if;
  end process;

  --Проверка генерации какой-либо ошибки и вывод соответствующего уведомления
  --Используемые сигналы и переменные:
  --  schema_is_error - сигнал проверки наличия какой-либо ошибки в схеме (true при наличии ошибки)
  schema_is_error <= d_is_error or c_is_error or r_is_error or d_preinstall_is_error;
  assert not schema_is_error report "Some input was wrong. See errors before or check input values" severity error;

  --Выводит на выход схемы результат работы идеального триггера (когда ошибок нет)
  trigger_body_select: block (not schema_is_error)
  begin
    signal_q <= guarded ideal_q;
  end block trigger_body_select;

  --Выводит на выход схемы 'X' (при наличии ошибок)
  error_select: block (schema_is_error)
  begin
    signal_q <= guarded 'X';
  end block error_select;

  --Вывод защищенного сигнала на выход схемы
  q <= signal_q;
end main_arch ; -- main_arch
