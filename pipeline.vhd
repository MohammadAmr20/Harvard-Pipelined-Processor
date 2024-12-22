library ieee;
use ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;
entity processor is
    port(
        clk, reset: in std_logic;
        in_port: in std_logic_vector(15 downto 0);
        rsrc1, rsrc2, rdest: out std_logic_vector(2 downto 0);
        opCode: out std_logic_vector(4 downto 0);
        immediate_out: out std_logic_vector(15 downto 0);
        out_pc: out std_logic_vector(11 downto 0)
    );
end processor;

architecture behavior of processor is
    signal pc: std_logic_vector(11 downto 0) := (others => '0');
    signal instruction, instruction_reg, in_reg, selected_instruction_ifid, selected_immediate_ifid: std_logic_vector(15 downto 0) := (others => '0');
    signal reserved_flags: std_logic_vector(2 downto 0) := (others => '0');
    signal reset_ifid: std_logic;
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
        opCode => opCode,
        rs => rsrc1,
        rt => rsrc2,
        rd => rdest,
        out_reserved_flags => reserved_flags,
        out_pc => out_pc,
        out_immediate => immediate_out,
        out_in_reg => in_reg
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