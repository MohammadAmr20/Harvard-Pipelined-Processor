library ieee;
use ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;
entity processor is
    port(
        clk, reset: in std_logic;
        in_port: in std_logic_vector(15 downto 0)
    );
end processor;

architecture behavior of processor is
    signal pc: std_logic_vector(11 downto 0) := (others => '0');
    signal instruction, instruction_reg, in_reg, selected_instruction_ifid, selected_immediate_ifid: std_logic_vector(15 downto 0) := (others => '0');
    signal reserved_flags: std_logic_vector(2 downto 0);
    signal if_id_out_rsrc1, if_id_out_rsrc2, if_id_out_rdest: std_logic_vector(2 downto 0);
    signal if_id_out_opCode: std_logic_vector(4 downto 0);
    signal if_id_out_pc: std_logic_vector(11 downto 0);
    signal if_id_out_reserved_flags: std_logic_vector(2 downto 0);
    signal if_id_out_in_reg: std_logic_vector(15 downto 0);
    signal if_id_out_immediate: std_logic_vector(15 downto 0);
    signal id_ex_in_data1, id_ex_in_data2: STD_LOGIC_VECTOR(15 downto 0);
    signal id_ex_in_preserveflags, id_ex_in_branch, id_ex_in_memwritesrc, id_ex_in_RegDst, id_ex_in_usersrc1, id_ex_in_usersrc2: std_logic;
    signal id_ex_in_branchselector, id_ex_in_memaddsrc, id_ex_in_wb_select: std_logic_vector(1 downto 0);
    signal id_ex_in_ALU_Select: std_logic_vector(2 downto 0);
    signal id_ex_in_regWrite, id_ex_in_aluSource, id_ex_in_HLT, id_ex_in_MW, id_ex_in_MR, id_ex_in_SP_Plus, id_ex_in_SP_Negative, id_ex_in_OUT_enable, id_ex_in_RET, id_ex_in_INT: std_logic;
    signal reset_ifid: std_logic;
    signal mem_wb_out_regwrite: std_logic := '0';
    signal mem_wb_out_regdst: std_logic_vector(2 downto 0) := (others => '0');
    signal mem_wb_out_dataout: std_logic_vector(15 downto 0) := (others => '0');
component InstructionMemory is
    port(
        addr : in std_logic_vector(11 downto 0);
        data_out : out std_logic_vector(15 downto 0)
    );
end component;
component if_id_Register is
    port(
        clk, reset, pause : in std_logic;
        pc : in std_logic_vector(11 downto 0);
        reserved_flags: in std_logic_vector(2 downto 0);
        instruction, immediate, in_reg : in std_logic_vector(15 downto 0);        
        opCode: out std_logic_vector(4 downto 0) := (others => '0');
        rs, rt, rd, out_reserved_flags : out std_logic_vector(2 downto 0) := (others => '0');
        out_pc: out std_logic_vector(11 downto 0) := (others => '0');
        out_immediate, out_in_reg: out std_logic_vector (15 downto 0):= (others => '0')
    );
end component;
component RegisterFile is
    port(
        clk, writeEnable: in std_logic;
        writeAddr, Rsrc1, Rsrc2: in std_logic_vector(2 downto 0);
        writeData: in std_logic_vector(15 downto 0);
        readData1, readData2: out std_logic_vector(15 downto 0)
    );
end component;
component ControlUnit is
    port(
        opCode: in std_logic_vector(4 downto 0);
        Reset: in std_logic;
        preserveflags, branch, memwritesrc, RegDst, usersrc1, usersrc2: out std_logic;
        branchselector, memaddsrc: out std_logic_vector(1 downto 0);
        regWrite, aluSource, HLT, MW, MR: out std_logic;
        WB_Select: out std_logic_vector(1 downto 0);
        ALU_Select: out std_logic_vector(2 downto 0);
        SP_Plus, SP_Negative, OUT_enable, RET, INT: out std_logic
    );
end component;
begin
    reset_ifid <= reset or ((not instruction_reg(0)) and instruction(0));
    selected_instruction_ifid <= instruction_reg when instruction_reg(0) = '1' else instruction;
    selected_immediate_ifid <= instruction and (0 to 15 => instruction_reg(0));
    InstructionMemory1: InstructionMemory port map(
        addr => pc,
        data_out => instruction
    );
    IFIDRegister1: if_id_register port map(
        clk => clk,
        reset => reset_ifid,
        pause => '0',
        pc => pc,
        reserved_flags => reserved_flags,
        instruction => selected_instruction_ifid,
        immediate => selected_immediate_ifid,
        in_reg => in_port,
        opCode => if_id_out_opCode,
        rs => if_id_out_rsrc1,
        rt => if_id_out_rsrc2,
        rd => if_id_out_rdest,
        out_reserved_flags => if_id_out_reserved_flags,
        out_pc => if_id_out_pc,
        out_immediate => if_id_out_immediate,
        out_in_reg => if_id_out_in_reg
    );
    RegisterFile1: RegisterFile port map(
        clk => clk,
        writeEnable => mem_wb_out_regwrite,
        writeAddr => mem_wb_out_regdst,
        Rsrc1 => if_id_out_rsrc1,
        Rsrc2 => if_id_out_rsrc2,
        writeData => mem_wb_out_dataout,
        readData1 => id_ex_in_data1,
        readData2 => id_ex_in_data2
    );
    ControlUnit1: ControlUnit port map(
        opCode => if_id_out_opCode,
        Reset => reset,
        preserveflags => id_ex_in_preserveflags,
        branch => id_ex_in_branch,
        memwritesrc => id_ex_in_memwritesrc,
        regDst => id_ex_in_RegDst,
        usersrc1 => id_ex_in_usersrc1,
        usersrc2 => id_ex_in_usersrc2,
        branchselector => id_ex_in_branchselector,
        memaddsrc => id_ex_in_memaddsrc,
        regWrite => id_ex_in_regWrite,
        aluSource => id_ex_in_aluSource,
        HLT => id_ex_in_HLT,
        MW => id_ex_in_MW,
        MR => id_ex_in_MR,
        WB_Select => id_ex_in_wb_select,
        SP_Plus => id_ex_in_SP_Plus,
        SP_Negative => id_ex_in_SP_Negative,
        ALU_Select => id_ex_in_ALU_Select,
        OUT_enable => id_ex_in_OUT_enable,
        RET => id_ex_in_RET,
        INT => id_ex_in_INT
    );
    process(clk) begin
        if reset = '1' then
            pc <= (others => '0');
            reserved_flags <= (others => '0');
            instruction_reg <= (others => '0');
        elsif rising_edge(clk) then
            pc <= std_logic_vector(unsigned(pc) + 1);
            if instruction_reg(0) = '1' then
                instruction_reg <= (others => '0');
            else
                instruction_reg <= instruction;
            end if;
        end if;
    end process;
end behavior;