library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    port (
        a, b : in std_logic_vector (N-1 downto 0);
        y : out std_logic_vector(31 downto 0));
end entity adder;
    
architecture rtl of adder is
    signal result : std_logic_vector(N downto 0);
begin
    result <= ("0" & n1) + ("0" & n2);
end architecture;