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
        0 => "0101100000100001", -- Example instruction 1 IADD R1, R2, 0101110111101110
        1 => "0101110111101110", -- Example instruction 2
        2 => "0100000000000100", -- Example instruction 3 ADD R1, R1,R2
        3 => "0011100100000000", -- Example instruction 4 MOV R2, R1
        4 => "0000000000000000", -- Example instruction 5
        5 => "0000000000000000", -- Example instruction 6
        OTHERS => (OTHERS => '0') -- Initialize remaining locations to 0
    );
BEGIN
    data_out <= memory(to_integer(unsigned(addr)));
END Behavioral;