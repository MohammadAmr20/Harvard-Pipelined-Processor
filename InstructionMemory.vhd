LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY InstructionMemory IS
    PORT (
        addr : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- 12-bit address input (4K = 2^12)
        data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- 16-bit data output
    );
END InstructionMemory;

ARCHITECTURE Behavioral OF InstructionMemory IS

    -- Memory declaration: 4K locations of 16 bits each
    TYPE memory_array IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory : memory_array := (
        0 => X"1234", -- Example instruction 1
        1 => X"5678", -- Example instruction 2
        2 => X"9ABC", -- Example instruction 3
        3 => X"DEF0", -- Example instruction 4
        4 => X"1111", -- Example instruction 5
        5 => X"2222", -- Example instruction 6
        OTHERS => (OTHERS => '0') -- Initialize remaining locations to 0
    );
BEGIN
    data_out <= memory(to_integer(unsigned(addr)));
END Behavioral;