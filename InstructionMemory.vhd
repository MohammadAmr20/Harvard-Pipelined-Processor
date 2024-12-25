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
        0 => "1000000100000001", -- STD 3(R2), R1
        1 => "0000000000000011", -- Example instruction 1 IMM
        2 => "0111100000100001", -- Example instruction 2 LDD 5(R1), R2
        3 => "0000000000000101", -- Example instruction 3 IMM
        4 => "0010100100000000", -- Example instruction 4 OUT R2 
        5 => "0000100000000000", -- Example instruction 5 HLT 
        6 => "0011100100000000", -- Example instruction 6 MOV R2 R1
        7 => "0110000000000000", -- Example instruction 7 PUSH R1
        8 => "0110100001000000", -- Example instruction 8 POP R3
        OTHERS => (OTHERS => '0') -- Initialize remaining locations to 0
    );
BEGIN
    data_out <= memory(to_integer(unsigned(addr)));
END Behavioral;