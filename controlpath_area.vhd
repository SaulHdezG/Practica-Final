-- Librerias
library ieee;
use ieee.std_logic_1164.all;

-- Declaracion de la entidad
entity controlpath_area is
    port(
        clock: in std_logic;
        iniciar: in std_logic;
        -- g(1) e(0) 
        signal_word: in std_logic_vector(1 downto 0);
        ocupado: out std_logic;
        -- Ex(8) Ey(7) Em(6) Sy(4) Sm(3) Ssum(2) Ssr (1) Sc(0)
        control_word: out std_logic_vector(7 downto 0)
    );
end;

-- Arquitectura comportamental
architecture comportamental of controlpath_area is
    -- Declaramos los estados
    type estados is (s0, s1, s2, s3, s4, s5, s6, s7);
    signal estado: estados;
begin
    --Lógica del estado siguiente
    estado_siguiente: process(clock)
    begin
        if(clock'event and clock='1') then
            case estado is
                when s0 =>
                    if(iniciar = '1') then 
                        estado <= s1; 
                    else 
                        estado <= s0; 
                    end if;
                when s1 => 
                    estado <= s2;
                when s2 =>
                    if(signal_word(0) = '0') then --x > '0'
                        estado <= s3; 
                    elsif(signal_word(0) = '1') then -- x = 0
                        estado <= s7; 
                    end if;
                when s3 =>
                    if(signal_word(0) = '0') then --y > '0'
                        estado <= s4; 
                    elsif(signal_word(0) = '1') then -- y = 0
                        estado <= s7; 
                    end if;
                when s4 =>
                    estado <= s5;    
                when s5 =>
                    estado <= s3;
                when s6 => 
                    estado <= s7;
                when s7 =>
                    estado <= s0;
                when others =>
                    estado <= s0;
            end case;
        end if;
    end process;
    --Lógica de la salida
    salida: process(estado)
    begin
        case estado is
            when s0 =>
                ocupado <= '0';
                -- -- Ex(8) Ey(7) Em(6)  Sy(4) Sm(3) Ssum(2) Ssr (1) Sc(0)
                control_word <= "00000000";
            when s1 =>
                ocupado <= '1';
                -- -- Ex(8) Ey(7) Em(6)  Sy(4) Sm(3) Ssum(2) Ssr (1) Sc(0)
                control_word <= "11100000";
            when s2 =>
                ocupado <= '1';
                -- -- Ex(8) Ey(7) Em(6)  Sy(4) Sm(3) Ssum(2) Ssr (1) Sc(0)
                control_word <= "00000000";
            when s3 => -- x<y
                ocupado <= '1';
                -- -- Ex(8) Ey(7) Em(6)  Sy(4) Sm(3) Ssum(2) Ssr (1) Sc(0)
                control_word <= "00000001";
            when s4 => -- x>y
                ocupado <= '1';
                -- -- Ex(8) Ey(7) Em(6) Sy(4) Sm(3) Ssum(2) Ssr (1) Sc(0)
                control_word <= "00101000";
            when s5 => 
                ocupado <= '1';
                -- -- Ex(8) Ey(7) Em(6)  Sy(4) Sm(3) Ssum(2) Ssr (1) Sc(0)
                control_word <= "01010111";
            when s6 => --
                ocupado <= '1';
                -- -- Ex(8) Ey(7) Em(6)  Sy(4) Sm(3) Ssum(2) Ssr (1) Sc(0)
                control_word <= "00101000";
            when s7 => --
                ocupado <= '0';
                -- -- Ex(8) Ey(7) Em(6)  Sy(4) Sm(3) Ssum(2) Ssr (1) Sc(0)
                control_word <= "00000000";
        end case;
    end process;
end;