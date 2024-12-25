LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY HazardDetection IS
    PORT (
        clk : IN STD_LOGIC;
        -- Inputs
        id_ie_mem_read : IN STD_LOGIC; -- IE/MEM memRead  signal
        id_ie_reg_write : IN STD_LOGIC; -- IE/MEM RegWrite signal

        id_ie_reg_adrs : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- ID/IE register address

        if_id_rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- ID/IE rsrc1 address
        if_id_rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- ID/IE rsrc2 address
        if_id_usersrc1 : IN STD_LOGIC; -- ID/IE uses rsrc1
        if_id_usersrc2 : IN STD_LOGIC; -- ID/IE uses rsrc2

        -- Outputs
        pc_stall : OUT STD_LOGIC -- PC stall

    );
END HazardDetection;

ARCHITECTURE RTL OF HazardDetection IS
    SIGNAL pc_stall_internall : STD_LOGIC := '0';
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            -- Forwarded Data from MEM Stage
            IF (id_ie_mem_read = '1' AND id_ie_reg_write = '1' AND
                ((id_ie_reg_adrs = if_id_rsrc1 AND if_id_usersrc1 = '1') OR
                (id_ie_reg_adrs = if_id_rsrc2 AND if_id_usersrc2 = '1'))) THEN
                pc_stall_internall <= '1';
            ELSE
                pc_stall_internall <= '0';
            END IF;
        END IF;
    END PROCESS;
    pc_stall <= pc_stall_internall;
END RTL;