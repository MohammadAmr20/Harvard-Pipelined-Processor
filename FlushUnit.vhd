LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FlushUnit IS
    PORT (
        -- Inputs
        branch : IN STD_LOGIC; -- branching exist or not
        stage : IN STD_LOGIC; -- branching stage 0=Excute, 1=Memory
        -- Outputs
        flush_if_id : OUT STD_LOGIC; -- Reset FetchDecode Register
        flush_id_ie : OUT STD_LOGIC; -- Reset DecodeExcute Register
        flush_ie_mem : OUT STD_LOGIC -- Reset ExcuteMemory Register
    );
END FlushUnit;

ARCHITECTURE Combinational OF FlushUnit IS
BEGIN
    flush_if_id <= '1' WHEN (branch = '1') ELSE
        '0';
    flush_id_ie <= '1' WHEN (branch = '1') ELSE
        '0';
    flush_ie_mem <= '1' WHEN (branch = '1' AND stage = '1') ELSE
        '0';
END Combinational;