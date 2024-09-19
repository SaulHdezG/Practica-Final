library ieee;
use ieee.std_logic_1164.all;

-- Declaración de la entidad
entity datapath_area is
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
end entity;

architecture estructural of datapath_area is
  -- Componentes a utilizar 
  component mux_8_4
    port (
      x: in std_logic_vector(3 downto 0);
      y: in std_logic_vector(3 downto 0);
      s: in std_logic;
      z: out std_logic_vector(3 downto 0)
    );
  end component;

  component registro_4bits
    port (
      clock, load: in std_logic;
      x: in std_logic_vector(3 downto 0);
      y: out std_logic_vector(3 downto 0)
    );
  end component;

  component sumador_restador_4bits
    port (
      x: in std_logic_vector (3 downto 0);
      y: in std_logic_vector (3 downto 0);
      selector: in std_logic;
      s: out std_logic_vector (4 downto 0)
    );
  end component;

  component desplazador_4bits
    port (
      S: in std_logic_vector(1 downto 0);
      X: in std_logic_vector(3 downto 0);
      Y: out std_logic_vector(3 downto 0)
    );
  end component;

  component comparador_4bits
    port (
      x: in std_logic_vector(3 downto 0);
      y: in std_logic_vector(3 downto 0);
      e: out std_logic;
      g: out std_logic
    );
  end component;

  -- Señales internas
  --Cables de los mux
  signal cable_mux_y, cable_mux_m, cable_mux_ssum1, cable_mux_ssum2:  std_logic_vector(3 downto 0);
  signal cable_mux_ssr, cable_mux_sc, cable_reg_x, cable_reg_y, cable_reg_m:  std_logic_vector(3 downto 0);
  signal cable_sumador: std_logic_vector(4 downto 0); 

begin
  -- Multiplexor para la señal y
    mux_y: mux_8_4
    Port map(
      x => y,
      y => cable_sumador(3 downto 0),  -- Ajuste a 4 bits
      s => control_word(4),
      z => cable_mux_y
    );
    mux_m: mux_8_4
    Port map(
      x => "0000",
      y => cable_sumador(3 downto 0),  -- Ajuste a 4 bits
      s => control_word(3),
      z => cable_mux_m
    );
    mux_ssum1: mux_8_4
    Port map(
      x => cable_reg_m,
      y => cable_reg_y,  -- Ajuste a 4 bits
      s => control_word(2),
      z => cable_mux_ssum1
    );
    mux_ssum2: mux_8_4
    Port map(
      x => cable_reg_x, 
      y => "0001",  -- Ajuste a 4 bits
      s => control_word(2),
      z => cable_mux_ssum2
    );
    mux_ssr: mux_8_4
    Port map(
      x => "0000",
      y => "0001",  -- Ajuste a 4 bits
      s => control_word(1),
      z => cable_mux_ssr
    );
    mux_sc: mux_8_4
    Port map(
      x => cable_reg_x,
      y => cable_reg_y,  -- Ajuste a 4 bits
      s => control_word(0),
      z => cable_mux_sc
    );
  -- Registro para x
  registro_x: registro_4bits
    Port map(
      clock => clock,
      load => control_word(7),
      x => x,
      y => cable_reg_x
    );
  -- Registro para y
  registro_y: registro_4bits
    Port map(
      clock => clock,
      load => control_word(6),
      x => cable_mux_y,
      y => cable_reg_y
    );
    registro_m: registro_4bits
    Port map(
      clock => clock,
      load => control_word(5),
      x => cable_mux_m,
      y => cable_reg_m
    );
  -- Comparador
  comparador_0: comparador_4bits
    Port map(
      x => cable_mux_sc,
      y => "0000",  -- Comparación con 0
      e => signal_word(0),
      g => signal_word(1)
    );
  -- Sumador/restador (resta en este caso)
  sumador_restador_4bits_0: sumador_restador_4bits
    Port map(
      x => cable_mux_ssum1,
      y => cable_mux_ssum2,  
      selector => cable_mux_ssr(0), 
      s => cable_sumador
    );
  -- Desplazador
  desplazador_4bits_0: desplazador_4bits
    Port map(
      S => "10",  -- Desplazamiento hacia la derecha con 0
      X => cable_reg_m,
      Y => s  -- Salida conectada a la salida 's'
    );

end architecture;