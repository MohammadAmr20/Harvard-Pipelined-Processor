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
        0 => "0111000000000001", -- Example instruction 1 LDM R1, 0000000011101110
        1 => "0000000011101110", -- Example instruction 2 IMM
        2 => "1000000100000000", -- Example instruction 3 STD 0(R2), R1
        3 => "0011100000100000", -- Example instruction 4 PUSH R1
        4 => "0000000000000000", -- Example instruction 5 
        5 => "0000000000000000", -- Example instruction 6
        OTHERS => (OTHERS => '0') -- Initialize remaining locations to 0
    );
BEGIN
    data_out <= memory(to_integer(unsigned(addr)));
END Behavioral;