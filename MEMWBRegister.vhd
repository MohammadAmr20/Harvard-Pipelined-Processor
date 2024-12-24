library ieee;
use ieee.std_logic_1164.all;

entity mem_wb_register is
    port(
        clk                     : in  STD_LOGIC;
        
        -- Input signals
        mem_wb_in_mem_data        : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
        mem_wb_in_alu_result     : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
        mem_wb_in_in_data        : in  STD_LOGIC_VECTOR(15 DOWNTO 0);

        mem_wb_in_wb_select      : in  STD_LOGIC_VECTOR(1 DOWNTO 0);
        mem_wb_in_regWrite       : in  STD_LOGIC;
        mem_wb_in_OUT_enable     : in  STD_LOGIC;
        mem_wb_in_rdest          : in  STD_LOGIC_VECTOR(2 DOWNTO 0);

        -- Output signals
        mem_wb_out_mem_data      : out STD_LOGIC_VECTOR(15 DOWNTO 0);
        mem_wb_out_alu_result    : out STD_LOGIC_VECTOR(15 DOWNTO 0);
        mem_wb_out_in_data       : out STD_LOGIC_VECTOR(15 DOWNTO 0);

        mem_wb_out_wb_select     : out STD_LOGIC_VECTOR(1 DOWNTO 0);
        mem_wb_out_regWrite      : out STD_LOGIC;
        mem_wb_out_OUT_enable    : out STD_LOGIC;
        mem_wb_out_rdest         : out STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
end entity mem_wb_register;

architecture behavior of mem_wb_register is
begin
    process(clk)
    begin
       if falling_edge(clk) then
            -- Directly assign inputs to outputs
            mem_wb_out_mem_data          <= mem_wb_in_mem_data;
            mem_wb_out_alu_result     <= mem_wb_in_alu_result;
            mem_wb_out_in_data        <= mem_wb_in_in_data;

            mem_wb_out_wb_select      <= mem_wb_in_wb_select;
            mem_wb_out_regWrite       <= mem_wb_in_regWrite;
            mem_wb_out_OUT_enable     <= mem_wb_in_OUT_enable;
            mem_wb_out_rdest          <= mem_wb_in_rdest;
        end if;
    end process;
end behavior;
