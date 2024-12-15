library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataMemory_tb is
-- Testbench has no ports
end DataMemory_tb;

architecture Behavioral of DataMemory_tb is

    -- Component declaration for the Unit Under Test (UUT)
    component DataMemory
        Port (
            clk       : in  std_logic;
            addr      : in  std_logic_vector(11 downto 0);
            data_in   : in  std_logic_vector(15 downto 0);
            we        : in  std_logic;
            re        : in  std_logic;
            data_out  : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Signals for simulating inputs and outputs
    signal clk       : std_logic := '0';
    signal addr      : std_logic_vector(11 downto 0) := (others => '0');
    signal data_in   : std_logic_vector(15 downto 0) := (others => '0');
    signal we        : std_logic := '0';
    signal re        : std_logic := '0';
    signal data_out  : std_logic_vector(15 downto 0);

    -- Clock period constant
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: DataMemory
        Port map (
            clk => clk,
            addr => addr,
            data_in => data_in,
            we => we,
            re => re,
            data_out => data_out
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
        -- Write data to address 0
        addr <= "000000000000";  -- Address 0
        data_in <= X"1234";      -- Data to write
        we <= '1';               -- Enable write
        re <= '0';               -- Disable read
        wait for clk_period;

        -- Write data to address 1
        addr <= "000000000001";  -- Address 1
        data_in <= X"5678";      -- Data to write
        wait for clk_period;

        -- Disable write and enable read for address 0
        addr <= "000000000000";  -- Address 0
        we <= '0';               -- Disable write
        re <= '1';               -- Enable read
        wait for clk_period;

        -- Read from address 1
        addr <= "000000000001";  -- Address 1
        wait for clk_period;

        -- Test complete
        wait;
    end process;

end Behavioral;
