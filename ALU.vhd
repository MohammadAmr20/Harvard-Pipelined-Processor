LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; -- Required for arithmetic operations

ENTITY ALU IS
    PORT (
        A : IN signed(15 DOWNTO 0); -- Input operand A
        B : IN signed(15 DOWNTO 0); -- Input operand B
        op, reserved_flags: IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Operation selector
        clk, RET, preserve_flags, Reset : IN STD_LOGIC; -- Clock input
        result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- ALU result
        flag_reg : OUT STD_LOGIC_VECTOR(2 DOWNTO 0):= (others => '0') -- Flag output
    );
END ALU;

ARCHITECTURE Behavioral OF ALU IS
    SIGNAL alu_result : signed(15 DOWNTO 0);
    SIGNAL flag : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
    alu_result <= A WHEN op = "000" ELSE
        B WHEN op = "001" ELSE
        A + B WHEN op = "010" ELSE
        A - B WHEN op = "011" ELSE
        A AND B WHEN op = "100" ELSE
        A WHEN op = "101" ELSE
        NOT A WHEN op = "110" ELSE
        A + 1 WHEN op = "111";
    flag(2) <= '1' WHEN op = "010" AND ((A(15) /= alu_result(15)) OR (B(15) /= alu_result(15))) ELSE
        '1' WHEN op = "011" AND (A(15) /= alu_result(15)) ELSE
        '1' WHEN op = "111" AND (A(15) = '0') AND (alu_result(15) = '1') ELSE
        '1' WHEN op = "101" ELSE
        '0';
    result <=  STD_LOGIC_VECTOR(alu_result) when Reset = '0' else
        (OTHERS => '0');
    flag(1) <= alu_result(15);
    flag(0) <= '1' WHEN alu_result = 0 ELSE
        '0';
    process(clk) begin
        if rising_edge(clk) then
            if Reset = '1' then
                flag_reg <= "000";
            else
                if RET = '1' then
                    if preserve_flags = '0' then
                        flag_reg <= reserved_flags;
                    end if;
                elsif preserve_flags = '0' then
                    flag_reg <= flag;
                end if;
            end if;
        end if;
    end process;
END Behavioral;