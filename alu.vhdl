library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
        a,b : in std_logic_vector(31 downto 0);
        ALUControl : in std_logic_vector(2 downto 0);
        ALUResult : buffer std_logic_vector(31 downto 0);
        Zero : out std_logic);
end entity alu;

architecture rtl of alu is

    signal ALU_out : std_logic_vector(31 downto 0);
    signal tmp : std_logic_vector(32 downto 0);
    
begin
    process (a,b,ALUControl)
    begin
    case (ALUControl) is
    
        when "000" =>
            ALU_out <= std_logic_vector(signed(a) + signed(b));
        when "001" =>
            ALU_out <= std_logic_vector(signed(a) - signed(b));
        when "010" =>
            ALU_out <= std_logic_vector(signed(a) and signed(b));

        when "011" =>
            ALU_out <= std_logic_vector(signed(a) or signed(b));
        when others =>
        ALU_out <= "X";
    end case;
    
end process;
    ALUResult <= ALU_out;
    tmp <= std_logic_vector(('0' & unsigned(a)) + ('0' & unsigned(b)));
    Zero <= tmp(32);

end architecture;