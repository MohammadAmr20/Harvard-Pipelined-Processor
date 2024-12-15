LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DataMemory IS
    PORT (
        clk : IN STD_LOGIC; -- Clock signal
        addr : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- 12-bit address input (4K = 2^12)
        data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- 16-bit data input
        we : IN STD_LOGIC; -- Write enable signal
        re : IN STD_LOGIC; -- Read enable signal
        data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- 16-bit data output
    );
END DataMemory;

ARCHITECTURE Behavioral OF DataMemory IS

    -- Memory declaration: 4K locations of 16 bits each
    TYPE memory_array IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory : memory_array := (OTHERS => (OTHERS => '0')); -- Initialize all locations to 0

BEGIN

    data_out <= memory(to_integer(unsigned(addr))) WHEN re = '1'
        ELSE (OTHERS => '0');
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF we = '1' THEN
                -- Write data to the specified address
                memory(to_integer(unsigned(addr))) <= data_in;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;