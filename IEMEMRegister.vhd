library ieee;
use ieee.std_logic_1164.all;

entity ex_mem_register is
    port(
        clk                     : in  STD_LOGIC;
        reset                   : in  STD_LOGIC;

        
        -- Input signals
        ex_mem_in_rsrc2          : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
        ex_mem_in_alu_result     : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
        ex_mem_in_in_data        : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
        ex_mem_in_immediate      : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
        ex_mem_in_pc             : in  STD_LOGIC_VECTOR(11 DOWNTO 0);
        ex_mem_in_pc_1           : in  STD_LOGIC_VECTOR(11 DOWNTO 0);

        ex_mem_in_memwritesrc    : in  STD_LOGIC;
        ex_mem_in_memaddsrc      : in  STD_LOGIC_VECTOR(1 DOWNTO 0);
        ex_mem_in_wb_select      : in  STD_LOGIC_VECTOR(1 DOWNTO 0);
        ex_mem_in_regWrite       : in  STD_LOGIC;
        ex_mem_in_MW             : in  STD_LOGIC;
        ex_mem_in_MR             : in  STD_LOGIC;
        ex_mem_in_SP_Plus        : in  STD_LOGIC;
        ex_mem_in_SP_Negative    : in  STD_LOGIC;
        ex_mem_in_OUT_enable     : in  STD_LOGIC;
        ex_mem_in_RET            : in  STD_LOGIC;
        ex_mem_in_INT            : in  STD_LOGIC;
        ex_mem_in_rdest          : in  STD_LOGIC_VECTOR(2 DOWNTO 0);

        -- Output signals
        ex_mem_out_rsrc2         : out STD_LOGIC_VECTOR(15 DOWNTO 0);
        ex_mem_out_alu_result    : out STD_LOGIC_VECTOR(15 DOWNTO 0);
        ex_mem_out_in_data       : out STD_LOGIC_VECTOR(15 DOWNTO 0);
        ex_mem_out_immediate     : out STD_LOGIC_VECTOR(15 DOWNTO 0);
        ex_mem_out_pc            : out STD_LOGIC_VECTOR(11 DOWNTO 0);
        ex_mem_out_pc_1          : out STD_LOGIC_VECTOR(11 DOWNTO 0);

        ex_mem_out_memwritesrc   : out STD_LOGIC;
        ex_mem_out_memaddsrc     : out STD_LOGIC_VECTOR(1 DOWNTO 0);
        ex_mem_out_wb_select     : out STD_LOGIC_VECTOR(1 DOWNTO 0);
        ex_mem_out_regWrite      : out STD_LOGIC;
        ex_mem_out_MW            : out STD_LOGIC;
        ex_mem_out_MR            : out STD_LOGIC;
        ex_mem_out_SP_Plus       : out STD_LOGIC;
        ex_mem_out_SP_Negative   : out STD_LOGIC;
        ex_mem_out_OUT_enable    : out STD_LOGIC;
        ex_mem_out_RET           : out STD_LOGIC;
        ex_mem_out_INT           : out STD_LOGIC;
        ex_mem_out_rdest         : out STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
end entity ex_mem_register;

architecture behavior of ex_mem_register is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset all outputs to default values
            ex_mem_out_rsrc2          <= (others => '0');
            ex_mem_out_alu_result     <= (others => '0');
            ex_mem_out_in_data        <= (others => '0');
            ex_mem_out_immediate      <= (others => '0');
            ex_mem_out_pc             <= (others => '0');
            ex_mem_out_pc_1           <= (others => '0');
            ex_mem_out_memwritesrc    <= '0';
            ex_mem_out_memaddsrc      <= (others => '0');
            ex_mem_out_wb_select      <= (others => '0');
            ex_mem_out_regWrite       <= '0';
            ex_mem_out_MW             <= '0';
            ex_mem_out_MR             <= '0';
            ex_mem_out_SP_Plus        <= '0';
            ex_mem_out_SP_Negative    <= '0';
            ex_mem_out_OUT_enable     <= '0';
            ex_mem_out_RET            <= '0';
            ex_mem_out_INT            <= '0';
            ex_mem_out_rdest          <= (others => '0');
            
        elsif falling_edge(clk) then
            -- Directly assign inputs to outputs
            ex_mem_out_rsrc2          <= ex_mem_in_rsrc2;
            ex_mem_out_alu_result     <= ex_mem_in_alu_result;
            ex_mem_out_in_data        <= ex_mem_in_in_data;
            ex_mem_out_immediate      <= ex_mem_in_immediate;
            ex_mem_out_pc             <= ex_mem_in_pc;
            ex_mem_out_pc_1           <= ex_mem_in_pc_1;
            ex_mem_out_memwritesrc    <= ex_mem_in_memwritesrc;
            ex_mem_out_memaddsrc      <= ex_mem_in_memaddsrc;
            ex_mem_out_wb_select      <= ex_mem_in_wb_select;
            ex_mem_out_regWrite       <= ex_mem_in_regWrite;
            ex_mem_out_MW             <= ex_mem_in_MW;
            ex_mem_out_MR             <= ex_mem_in_MR;
            ex_mem_out_SP_Plus        <= ex_mem_in_SP_Plus;
            ex_mem_out_SP_Negative    <= ex_mem_in_SP_Negative;
            ex_mem_out_OUT_enable     <= ex_mem_in_OUT_enable;
            ex_mem_out_RET            <= ex_mem_in_RET;
            ex_mem_out_INT            <= ex_mem_in_INT; 
            ex_mem_out_rdest          <= ex_mem_in_rdest;
        end if;
    end process;
end behavior;
