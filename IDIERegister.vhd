LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY id_ex_register IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        -- Input signals
        id_ex_in_data1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_in_data2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_in_in_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_in_immediate : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_in_pc : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        id_ex_in_pc_1 : IN STD_LOGIC_VECTOR(11 DOWNTO 0);

        id_ex_in_preserveflags : IN STD_LOGIC;
        id_ex_in_branch : IN STD_LOGIC;
        id_ex_in_memwritesrc : IN STD_LOGIC;
        id_ex_in_RegDst : IN STD_LOGIC;
        id_ex_in_usersrc1 : IN STD_LOGIC;
        id_ex_in_usersrc2 : IN STD_LOGIC;
        id_ex_in_branchselector : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        id_ex_in_memaddsrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        id_ex_in_wb_select : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        id_ex_in_ALU_Select : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_in_reserved_flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_in_regWrite : IN STD_LOGIC;
        id_ex_in_aluSource : IN STD_LOGIC;
        id_ex_in_MW : IN STD_LOGIC;
        id_ex_in_MR : IN STD_LOGIC;
        id_ex_in_SP_Plus : IN STD_LOGIC;
        id_ex_in_SP_Negative : IN STD_LOGIC;
        id_ex_in_OUT_enable : IN STD_LOGIC;
        id_ex_in_RET : IN STD_LOGIC;
        id_ex_in_INT : IN STD_LOGIC;
        id_ex_in_rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_in_rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_in_rdest : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        -- Output signals
        id_ex_out_data1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_out_data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_out_in_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_out_immediate : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_out_pc : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        id_ex_out_pc_1 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        id_ex_out_preserveflags : OUT STD_LOGIC;
        id_ex_out_branch : OUT STD_LOGIC;
        id_ex_out_memwritesrc : OUT STD_LOGIC;
        id_ex_out_RegDst : OUT STD_LOGIC;
        id_ex_out_usersrc1 : OUT STD_LOGIC;
        id_ex_out_usersrc2 : OUT STD_LOGIC;
        id_ex_out_branchselector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        id_ex_out_memaddsrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        id_ex_out_wb_select : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        id_ex_out_ALU_Select : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_out_reserved_flags : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_out_regWrite : OUT STD_LOGIC;
        id_ex_out_aluSource : OUT STD_LOGIC;
        id_ex_out_MW : OUT STD_LOGIC;
        id_ex_out_MR : OUT STD_LOGIC;
        id_ex_out_SP_Plus : OUT STD_LOGIC;
        id_ex_out_SP_Negative : OUT STD_LOGIC;
        id_ex_out_OUT_enable : OUT STD_LOGIC;
        id_ex_out_RET : OUT STD_LOGIC;
        id_ex_out_INT : OUT STD_LOGIC;
        id_ex_out_rsrc1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_out_rsrc2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_out_rdest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END id_ex_register;

ARCHITECTURE behavior OF id_ex_register IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF falling_edge(clk) THEN
            IF reset = '1' THEN
                -- Reset all outputs to default values
                id_ex_out_data1 <= (OTHERS => '0');
                id_ex_out_data2 <= (OTHERS => '0');
                id_ex_out_in_data <= (OTHERS => '0');
                id_ex_out_immediate <= (OTHERS => '0');
                id_ex_out_pc <= (OTHERS => '0');
                id_ex_out_pc_1 <= (OTHERS => '0');
                id_ex_out_preserveflags <= '0';
                id_ex_out_branch <= '0';
                id_ex_out_memwritesrc <= '0';
                id_ex_out_RegDst <= '0';
                id_ex_out_usersrc1 <= '0';
                id_ex_out_usersrc2 <= '0';
                id_ex_out_branchselector <= (OTHERS => '0');
                id_ex_out_memaddsrc <= (OTHERS => '0');
                id_ex_out_wb_select <= (OTHERS => '0');
                id_ex_out_ALU_Select <= (OTHERS => '0');
                id_ex_out_reserved_flags <= (OTHERS => '0');
                id_ex_out_regWrite <= '0';
                id_ex_out_aluSource <= '0';
                id_ex_out_MW <= '0';
                id_ex_out_MR <= '0';
                id_ex_out_SP_Plus <= '0';
                id_ex_out_SP_Negative <= '0';
                id_ex_out_OUT_enable <= '0';
                id_ex_out_RET <= '0';
                id_ex_out_INT <= '0';
                id_ex_out_rsrc1 <= (OTHERS => '0');
                id_ex_out_rsrc2 <= (OTHERS => '0');
                id_ex_out_rdest <= (OTHERS => '0');
            ELSE
                -- Directly assign inputs to outputs
                id_ex_out_data1 <= id_ex_in_data1;
                id_ex_out_data2 <= id_ex_in_data2;
                id_ex_out_in_data <= id_ex_in_in_data;
                id_ex_out_immediate <= id_ex_in_immediate;
                id_ex_out_pc <= id_ex_in_pc;
                id_ex_out_pc_1 <= id_ex_in_pc_1;
                id_ex_out_preserveflags <= id_ex_in_preserveflags;
                id_ex_out_branch <= id_ex_in_branch;
                id_ex_out_memwritesrc <= id_ex_in_memwritesrc;
                id_ex_out_RegDst <= id_ex_in_RegDst;
                id_ex_out_usersrc1 <= id_ex_in_usersrc1;
                id_ex_out_usersrc2 <= id_ex_in_usersrc2;
                id_ex_out_branchselector <= id_ex_in_branchselector;
                id_ex_out_memaddsrc <= id_ex_in_memaddsrc;
                id_ex_out_wb_select <= id_ex_in_wb_select;
                id_ex_out_ALU_Select <= id_ex_in_ALU_Select;
                id_ex_out_reserved_flags <= id_ex_in_reserved_flags;
                id_ex_out_regWrite <= id_ex_in_regWrite;
                id_ex_out_aluSource <= id_ex_in_aluSource;
                id_ex_out_MW <= id_ex_in_MW;
                id_ex_out_MR <= id_ex_in_MR;
                id_ex_out_SP_Plus <= id_ex_in_SP_Plus;
                id_ex_out_SP_Negative <= id_ex_in_SP_Negative;
                id_ex_out_OUT_enable <= id_ex_in_OUT_enable;
                id_ex_out_RET <= id_ex_in_RET;
                id_ex_out_INT <= id_ex_in_INT;
                id_ex_out_rsrc1 <= id_ex_in_rsrc1;
                id_ex_out_rsrc2 <= id_ex_in_rsrc2;
                id_ex_out_rdest <= id_ex_in_rdest;
            END IF;
        END IF;
    END PROCESS;
END behavior;