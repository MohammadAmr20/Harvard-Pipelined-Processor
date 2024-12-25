LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY interrupt_table IS
    PORT (
        index : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END interrupt_table;

ARCHITECTURE Behavioral OF interrupt_table IS

    -- Memory declaration: 16 locations of 12 bits each
    TYPE memory_array IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory : memory_array := (
        0 => "0000000000000110",
        1 => "1111111111111111",
        2 => "0000000000001000",
        OTHERS => (OTHERS => '1')
    ); 
BEGIN
    data_out <= memory(to_integer(unsigned(index)));
END Behavioral;