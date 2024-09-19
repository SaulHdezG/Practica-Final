library ieee;
use ieee.std_logic_1164.all;

-- Declaracion de la entidad
entity area is
    port(
        clock: in std_logic;
        iniciar: in std_logic;
        x: in std_logic_vector(3 downto 0);
        y: in std_logic_vector(3 downto 0);
        ocupado: out std_logic;
        s: out std_logic_vector(3 downto 0)
    );
end area;

architecture estructural of area is
    component datapath_area
        port (
            clock: in std_logic;
            x: in std_logic_vector (3 downto 0);
            y: in std_logic_vector (3 downto 0);
            -- Ex(7) Ey(6) Em(5) Sy(4) Sm(3) Ssum(2) Ssr (1) Sc(0)
            control_word : in std_logic_vector(7 downto 0);
            --g(1) e(0)
            signal_word: out std_logic_vector(1 downto 0);
            --Salidas
            s: out std_logic_vector(3 downto 0)
          );
    end component;
    component controlpath_area
        port(
            clock: in std_logic;
            iniciar: in std_logic;
            -- g(1) e(0) 
            signal_word: in std_logic_vector(1 downto 0);
            ocupado: out std_logic;
            -- Ex(7) Ey(6) Em(5) Sy(4) Sm(3) Ssum(2) Ssr (1) Sc(0)
            control_word: out std_logic_vector(7 downto 0)
        );
    end component;

    signal cable_cw: std_logic_vector(7 downto 0);
    signal cable_sw: std_logic_vector(1 downto 0);
begin
    dp: datapath_area
    port map(
        clock => clock,
        x => x,
        y => y,
        control_word => cable_cw,
        signal_word => cable_sw,
        s => s
    );
    
    cp: controlpath_area
    port map(
        clock => clock,
        iniciar => iniciar, 
        signal_word => cable_sw,
        ocupado => ocupado,
        control_word => cable_cw
    );
end;