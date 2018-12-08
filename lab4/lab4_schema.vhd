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
  signal r_is_error : boolean := false;

  signal d_prev_t : time := 0 ns;
  signal d_out_now : std_logic := '0';

  signal c_out_now_for_d : std_logic := '0';

  signal r_prev_t : time := 0 ns;
  signal r_out_now : std_logic := '0';

  --Минимальное время удержания '1' на D
  constant d_1_duration : time := 4 ns;
  --Минимальное время удержания '0' на D
  constant d_0_duration : time := 3 ns;
  --Минимальное время удержания D после фронта C
  constant d_after_c_duration : time := 1 ns;
  --Минимальное время удержания '1' на R
  constant r_duration : time := 4 ns;

  --Минимальное время удержания '1' на D до фронта С
  constant d_1_before_c_duration : time := d_1_duration - d_after_c_duration;
  --Минимальное время удержания '0' на D до фронта С
  constant d_0_before_c_duration : time := d_0_duration - d_after_c_duration;

  --Время реакции триггера на фронт C при D = 1
  constant d_1_res_delay : time := 9 ns;
  --Время реакции триггера на фронт C при D = 0
  constant d_0_res_delay : time := 10 ns;
  --Время реакции триггера на фронт R
  constant r_res_delay : time := 8 ns;

begin
  --Вывод уведомления про происхождении какой-либо ошибки
  assert not r_is_error report "R = 1 need at least 4ns wait between switching" severity error;
  assert not d_is_error report "D need at least 4ns wait between switching" severity error;
  assert not d_preinstall_is_error report "D need to be stable at least 3ns before C rise" severity error;

  --Процесс проверяет:
  --  корректность времени предустановки D
  --Используемые сигналы и переменные:
  --  d_preinstall_is_error - содержит true при ошибке минимального времени предустановки D перед фронтом C, иначе false
  process(c)
  begin
    if (c'event and c = '1') then
      if (d = '1') then
        d_preinstall_is_error <= not d'stable(d_1_before_c_duration) and (now > 0 ns);
      elsif (d = '0') then
        d_preinstall_is_error <= not d'stable(d_0_before_c_duration) and (now > 0 ns);
      end if;
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
    if (d = '1') then
      d_is_error <= ((d_delta < d_0_duration) and (d_delta > 0 ns));
    elsif (d = '0') then
      d_is_error <= ((d_delta < d_1_duration) and (d_delta > 0 ns));
    end if;
  end process;

  --Процесс выполняет:
  --  эмуляция задержки реакции триггера
  --Используемые сигналы и переменные:
  --  delay_time - текущее требуемое время транспортировки результата сигнала
  --  c_out_now_for_d - смещенный на время реакции на фронт C сигнал С (по нему будет защелкиваться новый D)
  --  d_out_now - смещенный на время реакции на фронт C сигнал D (сигнал для защелкивания)
  --  r_out_now - смещенный на время реакции на фронт R сигнал R (приоритетный сигнал сброса)
  process(d, c)
  variable delay_time : time := d_1_res_delay;
  begin
    if (d'event and d = '1') then
      delay_time := d_1_res_delay;
    elsif (d'event and d = '0') then
      delay_time := d_0_res_delay;
    end if;

    d_out_now <= transport d after delay_time;
    c_out_now_for_d <= transport c after delay_time;
  end process;
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
  schema_is_error <= d_is_error or r_is_error or d_preinstall_is_error;
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
