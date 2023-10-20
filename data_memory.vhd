library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity data_memory is
    port (
        clk         : in std_logic;
        write_enable: in std_logic;
        a : in std_logic_vector(31 downto 0);
        WD : in std_logic;
        RD : out std_logic_vector(31 downto 0));
end entity;

