library ieee;
use ieee.std_logic_1164.all;

entity id_ex_register is
    port(
        clk                     : in  STD_LOGIC;
        reset                   : in  STD_LOGIC;

        
        -- Input signals
        id_ex_in_data1          : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_in_data2          : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_in_in_data        : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_in_immediate      : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_in_pc             : in  STD_LOGIC_VECTOR(11 DOWNTO 0);
        id_ex_in_pc_1           : in  STD_LOGIC_VECTOR(11 DOWNTO 0);

        id_ex_in_preserveflags  : in  STD_LOGIC;
        id_ex_in_branch         : in  STD_LOGIC;
        id_ex_in_memwritesrc    : in  STD_LOGIC;
        id_ex_in_RegDst         : in  STD_LOGIC;
        id_ex_in_usersrc1       : in  STD_LOGIC;
        id_ex_in_usersrc2       : in  STD_LOGIC;
        id_ex_in_branchselector : in  STD_LOGIC_VECTOR(1 DOWNTO 0);
        id_ex_in_memaddsrc      : in  STD_LOGIC_VECTOR(1 DOWNTO 0);
        id_ex_in_wb_select      : in  STD_LOGIC_VECTOR(1 DOWNTO 0);
        id_ex_in_ALU_Select     : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_in_reserved_flags : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_in_regWrite       : in  STD_LOGIC;
        id_ex_in_aluSource      : in  STD_LOGIC;
        id_ex_in_HLT            : in  STD_LOGIC;
        id_ex_in_MW             : in  STD_LOGIC;
        id_ex_in_MR             : in  STD_LOGIC;
        id_ex_in_SP_Plus        : in  STD_LOGIC;
        id_ex_in_SP_Negative    : in  STD_LOGIC;
        id_ex_in_OUT_enable     : in  STD_LOGIC;
        id_ex_in_RET            : in  STD_LOGIC;
        id_ex_in_INT            : in  STD_LOGIC;
        id_ex_in_rsrc1          : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_in_rsrc2          : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_in_rdest          : in  STD_LOGIC_VECTOR(2 DOWNTO 0);

        -- Output signals
        id_ex_out_data1          : out  STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_out_data2          : out  STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_out_in_data        : out  STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_out_immediate      : out  STD_LOGIC_VECTOR(15 DOWNTO 0);
        id_ex_out_pc             : out  STD_LOGIC_VECTOR(11 DOWNTO 0);
        id_ex_out_pc_1           : out  STD_LOGIC_VECTOR(11 DOWNTO 0);
        id_ex_out_preserveflags  : out  STD_LOGIC;
        id_ex_out_branch         : out  STD_LOGIC;
        id_ex_out_memwritesrc    : out  STD_LOGIC;
        id_ex_out_RegDst         : out  STD_LOGIC;
        id_ex_out_usersrc1       : out  STD_LOGIC;
        id_ex_out_usersrc2       : out  STD_LOGIC;
        id_ex_out_branchselector : out  STD_LOGIC_VECTOR(1 DOWNTO 0);
        id_ex_out_memaddsrc      : out  STD_LOGIC_VECTOR(1 DOWNTO 0);
        id_ex_out_wb_select      : out  STD_LOGIC_VECTOR(1 DOWNTO 0);
        id_ex_out_ALU_Select     : out  STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_out_reserved_flags : out  STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_out_regWrite       : out  STD_LOGIC;
        id_ex_out_aluSource      : out  STD_LOGIC;
        id_ex_out_HLT            : out  STD_LOGIC;
        id_ex_out_MW             : out  STD_LOGIC;
        id_ex_out_MR             : out  STD_LOGIC;
        id_ex_out_SP_Plus        : out  STD_LOGIC;
        id_ex_out_SP_Negative    : out  STD_LOGIC;
        id_ex_out_OUT_enable     : out  STD_LOGIC;
        id_ex_out_RET            : out  STD_LOGIC;
        id_ex_out_INT            : out  STD_LOGIC;
        id_ex_out_rsrc1          : OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_out_rsrc2          : OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_ex_out_rdest          : OUT  STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
end id_ex_register;

architecture behavior of id_ex_register is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset all outputs to default values
            id_ex_out_data1          <= (others => '0');
            id_ex_out_data2          <= (others => '0');
            id_ex_out_in_data        <= (others => '0');
            id_ex_out_immediate      <= (others => '0');
            id_ex_out_pc             <= (others => '0');
            id_ex_out_pc_1           <= (others => '0');
            id_ex_out_preserveflags  <= '0';
            id_ex_out_branch         <= '0';
            id_ex_out_memwritesrc    <= '0';
            id_ex_out_RegDst         <= '0';
            id_ex_out_usersrc1       <= '0';
            id_ex_out_usersrc2       <= '0';
            id_ex_out_branchselector <= (others => '0');
            id_ex_out_memaddsrc      <= (others => '0');
            id_ex_out_wb_select      <= (others => '0');
            id_ex_out_ALU_Select     <= (others => '0');
            id_ex_out_reserved_flags <= (others => '0');
            id_ex_out_regWrite       <= '0';
            id_ex_out_aluSource      <= '0';
            id_ex_out_HLT            <= '0';
            id_ex_out_MW             <= '0';
            id_ex_out_MR             <= '0';
            id_ex_out_SP_Plus        <= '0';
            id_ex_out_SP_Negative    <= '0';
            id_ex_out_OUT_enable     <= '0';
            id_ex_out_RET            <= '0';
            id_ex_out_INT            <= '0';
            id_ex_out_rsrc1          <= (others => '0');
            id_ex_out_rsrc2          <= (others => '0');
            id_ex_out_rdest          <= (others => '0');
            

        elsif falling_edge(clk) then
            -- Directly assign inputs to outputs
            id_ex_out_data1          <= id_ex_in_data1;
            id_ex_out_data2          <= id_ex_in_data2;
            id_ex_out_in_data        <= id_ex_in_in_data;
            id_ex_out_immediate      <= id_ex_in_immediate;
            id_ex_out_pc             <= id_ex_in_pc;
            id_ex_out_pc_1           <= id_ex_in_pc_1;
            id_ex_out_preserveflags  <= id_ex_in_preserveflags;
            id_ex_out_branch         <= id_ex_in_branch;
            id_ex_out_memwritesrc    <= id_ex_in_memwritesrc;
            id_ex_out_RegDst         <= id_ex_in_RegDst;
            id_ex_out_usersrc1       <= id_ex_in_usersrc1;
            id_ex_out_usersrc2       <= id_ex_in_usersrc2;
            id_ex_out_branchselector <= id_ex_in_branchselector;
            id_ex_out_memaddsrc      <= id_ex_in_memaddsrc;
            id_ex_out_wb_select      <= id_ex_in_wb_select;
            id_ex_out_ALU_Select     <= id_ex_in_ALU_Select;
            id_ex_out_reserved_flags <= id_ex_in_reserved_flags;
            id_ex_out_regWrite       <= id_ex_in_regWrite;
            id_ex_out_aluSource      <= id_ex_in_aluSource;
            id_ex_out_HLT            <= id_ex_in_HLT;
            id_ex_out_MW             <= id_ex_in_MW;
            id_ex_out_MR             <= id_ex_in_MR;
            id_ex_out_SP_Plus        <= id_ex_in_SP_Plus;
            id_ex_out_SP_Negative    <= id_ex_in_SP_Negative;
            id_ex_out_OUT_enable     <= id_ex_in_OUT_enable;
            id_ex_out_RET            <= id_ex_in_RET;
            id_ex_out_INT            <= id_ex_in_INT; 
            id_ex_out_rsrc1          <= id_ex_in_rsrc1;
            id_ex_out_rsrc2          <= id_ex_in_rsrc2;
            id_ex_out_rdest          <= id_ex_in_rdest; 
        end if;
    end process;
end behavior ;