library IEEE;
use IEEE.std_logic_1164.all;

entity schema is
  port (
    x1, x2, x3, x4: in std_logic;
    y1, y2, y3, y4: out std_logic
  ) ;
end schema ;

architecture main_arch of schema is
    component n
        port (
          x: in std_logic;
          y: out std_logic
        ) ;
    end component;
    component no2
        port (
          x1, x2: in std_logic;
          y:      out std_logic
        ) ;
    end component;
    component o3
        port (
          x1, x2, x3: in std_logic;
          y: out std_logic
        ) ;
    end component;
    component noa22
        port (
          x1, x2, x3, x4: in std_logic;
          y: out std_logic
        ) ;
    end component;
    component naoa2
        port (
          x1, x2, x3, x4: in std_logic;
          y: out std_logic
        ) ;
    end component;
    component noa3
        port (
          x1, x2, x3, x4: in std_logic;
          y: out std_logic
        ) ;
    end component;

    signal a1: std_logic;
    signal b1, b2, b3, b4: std_logic;
    signal c1, c2, c3, c4, c5: std_logic;
    signal d1, d2, d3, d4: std_logic;
begin
    aa1: n port map (x1, a1);
    bb1: n port map (d2, b1);
    bb2: no2 port map (x2, a1, b2);
    bb3: no2 port map (x3, x1, b3);
    bb4: n port map (x4, b4);
    cc1: n port map (b1, c1);
    cc2: o3 port map (b1, x1, x2, c2);
    cc3: noa22 port map (x3, b2, x2, b3, c3);
    cc4: n port map (x2, c4);
    cc5: n port map (x3, c5);
    dd1: naoa2 port map (c2, x3, c1, x1, d1);
    dd2: naoa2 port map (c3, x4, c4, x1, d2);
    dd3: noa3 port map (c5, x1, b4, x2, d3);
    dd4: no2 port map (x4, b4, d4);

    -- outs
    y1 <= d1;
    y2 <= d3;
    y3 <= d2;
    y4 <= d4;
end main_arch ; -- main_arch
