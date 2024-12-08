LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; -- Required for arithmetic operations

ENTITY ALU IS
    PORT (
        clk : IN STD_LOGIC; -- Clock signal
        reset : IN STD_LOGIC; -- Reset signal
        A : IN signed(15 DOWNTO 0); -- Input operand A
        B : IN signed(15 DOWNTO 0); -- Input operand B
        op : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Operation selector
        result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- ALU result
        carry_out : OUT STD_LOGIC; -- Carry flag output
        zero_out : OUT STD_LOGIC; -- Zero flag output
        neg_out : OUT STD_LOGIC -- Negative flag output
    );
END ALU;

ARCHITECTURE Behavioral OF ALU IS
    SIGNAL alu_result : signed(15 DOWNTO 0);

BEGIN
    -- -- ALU computation process
    -- alu_logic : PROCESS (A, B, op)
    -- BEGIN
    --     CASE op IS
    --         WHEN "000" => -- Pass A
    --             alu_result <= A;
    --             carry_out <= '0';

    --         WHEN "001" => -- Pass B
    --             alu_result <= B;
    --             carry_out <= '0';

    --         WHEN "010" => -- ADD
    --             alu_result <= A + B;
    --             IF (A(15) = B(15)) AND (A(15) /= alu_result(15)) THEN
    --                 carry_out <= '1'; -- Overflow detected
    --             ELSE
    --                 carry_out <= '0';
    --             END IF;

    --         WHEN "011" => -- SUB
    --             alu_result <= A - B;
    --             IF (A(15) /= B(15)) AND (A(15) /= alu_result(15)) THEN
    --                 carry_out <= '1'; -- Overflow detected
    --             ELSE
    --                 carry_out <= '0';
    --             END IF;

    --         WHEN "100" => -- AND
    --             alu_result <= A AND B;
    --             carry_out <= '0';

    --         WHEN "101" => -- Pass A again
    --             alu_result <= A;
    --             carry_out <= '0';

    --         WHEN "110" => -- NOT A
    --             alu_result <= NOT A;
    --             carry_out <= '0';

    --         WHEN "111" => -- Increment A
    --             alu_result <= A + 1;
    --             IF (A(15) = '0') AND (alu_result(15) = '1') THEN
    --                 carry_out <= '1'; -- Overflow detected
    --             ELSE
    --                 carry_out <= '0';
    --             END IF;

    --         WHEN OTHERS => -- Default case
    --             alu_result <= (OTHERS => '0');
    --             carry_out <= '0';
    --     END CASE;

    --     -- Update flags
    --     IF (alu_result = 0) THEN
    --         zero_out <= '1';
    --     ELSE
    --         zero_out <= '0';
    --     END IF;
    -- END PROCESS;

    -- flag_update : PROCESS (clk, reset)
    -- BEGIN
    --     IF reset = '1' THEN
    --         carry_out <= '0';
    --         zero_out <= '0';
    --         neg_out <= '0';

    --     ELSIF rising_edge(clk) THEN
    --         carry_out <= carry_flag;
    --         zero_out <= zero_out;
    --         neg_out <= neg_flag;
    --     END IF;
    -- END PROCESS;
    alu_result <= A WHEN op = "000" ELSE
        B WHEN op = "001" ELSE
        A + B WHEN op = "010" ELSE
        A - B WHEN op = "011" ELSE
        A AND B WHEN op = "100" ELSE
        A WHEN op = "101" ELSE
        NOT A WHEN op = "110" ELSE
        A + 1 WHEN op = "111";
    carry_out <= '1' WHEN op = "010" AND (A(15) = B(15)) AND (A(15) /= alu_result(15)) ELSE
        '1' WHEN op = "011" AND (A(15) /= B(15)) AND (A(15) /= alu_result(15)) ELSE
        '1' WHEN op = "111" AND (A(15) = '0') AND (alu_result(15) = '1') ELSE
        '0';
    result <= STD_LOGIC_VECTOR(alu_result);
    neg_out <= alu_result(15);
    zero_out <= '1' WHEN alu_result = 0 ELSE
        '0';
END Behavioral;