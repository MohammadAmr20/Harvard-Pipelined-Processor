library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
    Port (
        clk         : in  std_logic;                -- Clock signal
        writeEnable : in  std_logic;                -- Write enable signal
        writeAddr   : in  std_logic_vector(2 downto 0); -- Write address (3 bits for 8 registers)
        writeData   : in  std_logic_vector(15 downto 0); -- Data to write
        Rsrc1       : in  std_logic_vector(2 downto 0); -- Read source 1 address
        Rsrc2       : in  std_logic_vector(2 downto 0); -- Read source 2 address
        readData1   : out std_logic_vector(15 downto 0); -- Data read from source 1
        readData2   : out std_logic_vector(15 downto 0)  -- Data read from source 2
    );
end RegisterFile;

architecture Behavioral of RegisterFile is

    -- Register array: 8 registers of 16 bits each
    type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
    signal registers : reg_array := (others => (others => '0')); -- Initialize all registers to 0

begin

    process(clk)
    begin
        if rising_edge(clk) then
            -- Write to the register file if writeEnable is active
            if writeEnable = '1' then
                registers(to_integer(unsigned(writeAddr))) <= writeData;
            end if;
        end if;
    end process;

    -- Read data from the selected registers
    readData1 <= registers(to_integer(unsigned(Rsrc1)));
    readData2 <= registers(to_integer(unsigned(Rsrc2)));

end Behavioral;
