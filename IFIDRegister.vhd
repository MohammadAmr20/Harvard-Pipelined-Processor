library ieee;
use ieee.std_logic_1164.all;

entity if_id_register is
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
end if_id_register;

architecture behavior of if_id_register is
begin
    process(clk) begin
        if reset = '1' then
            opCode <= (others => '0');
            rs <= (others => '0');
            rt <= (others => '0');
            rd <= (others => '0');
            out_in_reg <= (others => '0');
            out_pc <= (others => '0');
            out_immediate <= (others => '0');
            out_reserved_flags <= (others => '0');
        elsif falling_edge(clk) and pause = '0' then
            opCode <= instruction(15 downto 11);
            rs <= instruction(10 downto 8);
            rt <= instruction(7 downto 5);
            rd <= instruction(4 downto 2);
            out_pc <= pc;
            out_immediate <= immediate;
            out_in_reg <= in_reg;
            out_reserved_flags <= reserved_flags;
        end if;
    end process;
end behavior ;