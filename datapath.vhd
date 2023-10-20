library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity datapath is
    port (
        clk, reset   : in std_logic;
        ResultSrc : in std_logic_vector(1 downto 0);
        PCSrc, ALUSrc: in std_logic;
        RegWrite : in std_logic;
        ImmSrc : in std_logic_vector(1 downto 0);
        ALUControl : in std_logic_vector(2 downto 0);
        Zero : out std_logic;
        PC: bugger std_logic_vector(31 downto 0);
        Instr : in std_logic_vector(31 downto 0);
        ALUResult, WriteData : buffer (31 downto 0);
        ReadData : in std_logic_vector(31 downto 0);
    );
end entity datapath;

architecture rtl of datapath is
    
    component flopr generic (width: integer);
        port (
            clk, reset : in std_logic;
            d: in (WIDTH-1 downto 0);
            q: out (WIDTH-1 downto 0));
    end component;
        
    component adder
        port(
            a, b: in STD_LOGIC_VECTOR(31 downto 0);
            y:out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component mux2 generic(width: integer);
        port(
            d0, d1: in STD_LOGIC_VECTOR(width-1 downto 0);
            s:in STD_LOGIC;
            y:out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;

    component mux3 generic(width: integer);
        port(
            d0, d1, d2: in STD_LOGIC_VECTOR(width-1 downto 0);
            s: in STD_LOGIC_VECTOR(1 downto 0);
            y:out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
    
    component regfile
        port(
            clk : in std_logic;
            we3 : in std_logic;
            a1,a2,a3 : in std_logic_vector(4 downto 0);
            wd3 : in std_logic_vector(31 downto 0);
            rd1, rd2 : out std_logic_vector(31 downto 0));
    end component;
    
    component extend
        port(
            instr: in STD_LOGIC_VECTOR(31 downto 7);
            immsrc: in STD_LOGIC_VECTOR(1 downto 0);
            immext: out STD_LOGIC_VECTOR(31 downto 0));
        end component;

        component alu 
            port(
                a, b:in STD_LOGIC_VECTOR(31 downto 0);
               ALUControl: in STD_LOGIC_VECTOR(2 downto 0);
               ALUResult: buffer STD_LOGIC_VECTOR(31 downto 0);
               Zero: out STD_LOGIC);
            end component;             
            
        signal PCNext, PCPlus4, PCTarget: STD_LOGIC_VECTOR(31 downto 0);
        signal ImmExt: STD_LOGIC_VECTOR(31 downto 0);
        signal SrcA, SrcB: STD_LOGIC_VECTOR(31 downto 0);
        signal Result: STD_LOGIC_VECTOR(31 downto 0);
begin
    pcreg: flopr generic map(32) port map(clk, reset, PCNext, PC);
    pcadd4: adder port map(PC, X"00000004", PCPlus4);
    pcaddbranch: adder port map(PC, ImmExt, PCTarget);
    pcmux: mux2 generic map(32) port map(PCPlus4, PCTarget, PCSrc,PCNext);
    -- register file logic
    rf: regfile port map(clk, RegWrite, Instr(19 downto 15),
                        Instr(24 downto 20), Instr(11 downto 7),
                        Result, SrcA, WriteData);
    ext: extend port map(Instr(31 downto 7), ImmSrc, ImmExt);
    -- ALU logic
    srcbmux: mux2 generic map(32) port map(WriteData, ImmExt, ALUSrc, SrcB);
    mainalu: alu port map(SrcA, SrcB, ALUControl, ALUResult, Zero);
    resultmux: mux3 generic map(32) port map(ALUResult, ReadData, PCPlus4, ResultSrc, Result);
    
    

end architecture;