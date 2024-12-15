library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile_tb is
-- Testbench has no ports
end RegisterFile_tb;

architecture Behavioral of RegisterFile_tb is

    -- Component declaration for the Unit Under Test (UUT)
    component RegisterFile
        Port (
            clk         : in  std_logic;
            writeEnable : in  std_logic;
            writeAddr   : in  std_logic_vector(2 downto 0);
            writeData   : in  std_logic_vector(15 downto 0);
            Rsrc1       : in  std_logic_vector(2 downto 0);
            Rsrc2       : in  std_logic_vector(2 downto 0);
            readData1   : out std_logic_vector(15 downto 0);
            readData2   : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Signals for simulating inputs and outputs
    signal clk         : std_logic := '0';
    signal writeEnable : std_logic := '0';
    signal writeAddr   : std_logic_vector(2 downto 0) := (others => '0');
    signal writeData   : std_logic_vector(15 downto 0) := (others => '0');
    signal Rsrc1       : std_logic_vector(2 downto 0) := (others => '0');
    signal Rsrc2       : std_logic_vector(2 downto 0) := (others => '0');
    signal readData1   : std_logic_vector(15 downto 0);
    signal readData2   : std_logic_vector(15 downto 0);

    -- Clock period constant
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: RegisterFile
        Port map (
            clk => clk,
            writeEnable => writeEnable,
            writeAddr => writeAddr,
            writeData => writeData,
            Rsrc1 => Rsrc1,
            Rsrc2 => Rsrc2,
            readData1 => readData1,
            readData2 => readData2
        );

    -- Clock process to generate a clock signal
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Write data to register 0
        writeEnable <= '1';
        writeAddr <= "000"; -- Register 0
        writeData <= X"1234"; -- Data to write
        wait for clk_period;

        -- Write data to register 1
        writeAddr <= "001"; -- Register 1
        writeData <= X"5678"; -- Data to write
        wait for clk_period;

        -- Disable write
        writeEnable <= '0';

        -- Read from register 0 and 1 simultaneously
        Rsrc1 <= "000"; -- Register 0
        Rsrc2 <= "001"; -- Register 1
        wait for clk_period;

        -- Write data to register 2 and read from register 0 and 2 simultaneously
        writeEnable <= '1';
        writeAddr <= "010"; -- Register 2
        writeData <= X"9ABC"; -- Data to write
        wait for clk_period;

        writeEnable <= '0';
        Rsrc1 <= "000"; -- Register 0
        Rsrc2 <= "010"; -- Register 2
        wait for clk_period;

        -- Test complete
        wait;
    end process;

end Behavioral;
