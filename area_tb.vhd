library ieee;
use ieee.std_logic_1164.all;

entity area_tb is
end area_tb;

architecture estructural of area_tb is
    component area
        port(
            clock: in std_logic;
            iniciar: in std_logic;
            x: in std_logic_vector(3 downto 0);
            y: in std_logic_vector(3 downto 0);
            ocupado: out std_logic;
            s: out std_logic_vector(3 downto 0)
        );
        end component;

signal cable_clock, cable_iniciar, cable_ocupado: std_logic;
signal cable_x, cable_y, cable_s: std_logic_vector(3 downto 0);
--Definicion del periodo de reloj
constant clock_period: time := 10 ns;
begin
    moduloPrueba: area
    port map(
        clock => cable_clock,
        iniciar => cable_iniciar,
        x => cable_x,
        y => cable_y,
        ocupado => cable_ocupado,
        s => cable_s
    );
        -- Proceso para simular un reloj
    clock_process: process
    begin
        cable_clock <= '0';
        wait for clock_period/2;
        cable_clock <= '1';
        wait for clock_period/2;
    end process;
    -- Proceso de estimulacion de entradas
    estimulacion: process
    begin
        cable_iniciar <= '1';
        cable_x <= "0100";
        cable_y <= "0010";
        wait for 20*clock_period;
        cable_iniciar <= '1';
        cable_x <= "0101";
        cable_y <= "0011";
        wait for 20*clock_period;
        cable_iniciar <= '1';
        cable_x <= "0100";
        cable_y <= "0011";
        wait for 20*clock_period;
    end process;
end;