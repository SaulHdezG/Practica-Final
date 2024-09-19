----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2024 21:53:08
-- Design Name: 
-- Module Name: top_mcd - estructural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Declaración de la entidad
entity top_area is
    Port ( CLK100MHZ : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (7 downto 0);
           LED : out STD_LOGIC_VECTOR(4 downto 0)
    );
end top_area;
architecture estructural of top_area is
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
begin
    fsmd: area
    port map(
        clock => CLK100MHZ,
        iniciar => BTNC,
        x => SW(3 downto 0),
        y => SW(7 downto 4),
        ocupado => LED(0),
        s => LED(4 downto 1)
    );

end estructural;