LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SPAdder IS
    PORT (
        A : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- 12-bit unsigned input
        B : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- 12-bit unsigned input
        Sum : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- 12-bit unsigned sum
        Overflow : OUT STD_LOGIC -- Overflow flag
    );
END SPAdder;

ARCHITECTURE Behavioral OF SPAdder IS
    SIGNAL A_unsigned, B_unsigned, Sum_unsigned : UNSIGNED(11 DOWNTO 0);
    SIGNAL Carry : STD_LOGIC;
BEGIN
    -- Convert inputs to unsigned
    A_unsigned <= UNSIGNED(A);
    B_unsigned <= UNSIGNED(B);

    -- Perform the addition
    Sum_unsigned <= A_unsigned + B_unsigned;

    -- Convert result back to STD_LOGIC_VECTOR
    Sum <= STD_LOGIC_VECTOR(Sum_unsigned);

    -- Detect unsigned overflow (carry-out)
    Carry <= '1' WHEN (A_unsigned + B_unsigned) > 4095 OR (A_unsigned + B_unsigned) < 0 ELSE
        '0';
    Overflow <= Carry;
END Behavioral;