library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ForwardingUnit is
    Port (
        -- Inputs
        mem_wb_reg_write : in STD_LOGIC;               -- MEM/WB RegWrite signal
        ie_mem_reg_write : in STD_LOGIC;               -- IE/MEM RegWrite signal
        ie_mem_to_reg    : in STD_LOGIC;               -- IE/MEM MemtoReg signal
        ie_mem_in_sig    : in STD_LOGIC;               -- IE/MEM input signal
        
        mem_wb_data_out  : in STD_LOGIC_VECTOR(15 downto 0); -- MEM/WB data output
        ie_mem_alu_out   : in STD_LOGIC_VECTOR(15 downto 0); -- IE/MEM ALU result
        ie_mem_in_data   : in STD_LOGIC_VECTOR(15 downto 0); -- IE/MEM IN DATA
        ie_mem_mem_data  : in STD_LOGIC_VECTOR(15 downto 0); -- IE/MEM MEM DATA

        mem_wb_reg_adrs  : in STD_LOGIC_VECTOR(2 downto 0);  -- MEM/WB register address
        ie_mem_reg_adrs  : in STD_LOGIC_VECTOR(2 downto 0);  -- IE/MEM register address

        id_ie_rsrc1      : in STD_LOGIC_VECTOR(2 downto 0);  -- ID/IE rsrc1 address
        id_ie_rsrc2      : in STD_LOGIC_VECTOR(2 downto 0);  -- ID/IE rsrc2 address
        id_ie_usersrc1   : in STD_LOGIC;               -- ID/IE uses rsrc1
        id_ie_usersrc2   : in STD_LOGIC;               -- ID/IE uses rsrc2

        -- Outputs
        alu_src1         : out STD_LOGIC_VECTOR(1 downto 0); -- ALU source 1 mux signal
        alu_src2         : out STD_LOGIC_VECTOR(1 downto 0); -- ALU source 2 mux signal
        mem_forward_data : out STD_LOGIC_VECTOR(15 downto 0); -- Forwarded data from MEM
        wb_forward_data  : out STD_LOGIC_VECTOR(15 downto 0)  -- Forwarded data from WB
    );
end ForwardingUnit;

architecture Combinational of ForwardingUnit is
begin
    -- Forwarded Data from MEM Stage
    mem_forward_data <= ie_mem_mem_data when (ie_mem_to_reg = '1') else
                        ie_mem_in_data when (ie_mem_in_sig = '1') else
                        ie_mem_alu_out;

    -- Forwarded Data from WB Stage
    wb_forward_data <= mem_wb_data_out;

    -- ALU Source 1 (rsrc1 forwarding logic)
    alu_src1 <= "01" when (id_ie_usersrc1 = '1' and ie_mem_reg_write = '1' and ie_mem_reg_adrs = id_ie_rsrc1) else --Forwarded Data from MEM
                "10" when (id_ie_usersrc1 = '1' and mem_wb_reg_write = '1' and mem_wb_reg_adrs = id_ie_rsrc1) else --Forwarded Data from WB
                "00";

     -- ALU Source 1 (rsrc1 forwarding logic)
    alu_src2 <= "01" when (id_ie_usersrc2 = '1' and ie_mem_reg_write = '1' and ie_mem_reg_adrs = id_ie_rsrc2) else --Forwarded Data from MEM
                "10" when (id_ie_usersrc2 = '1' and mem_wb_reg_write = '1' and mem_wb_reg_adrs = id_ie_rsrc2) else --Forwarded Data from WB
                "00";
end Combinational;
