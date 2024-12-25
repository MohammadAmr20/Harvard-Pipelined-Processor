library ieee;
use ieee.std_logic_1164.all;

entity ACU is
    PORT(
        decodeexecute_pc, executememory_pc : in std_logic_vector(11 downto 0);
        interrupt_address, alu_src, mem_out : in std_logic_vector(15 downto 0);
        decodeexecute_branch_selector : in std_logic_vector(1 downto 0);
        execute_flag_register : in std_logic_vector (2 downto 0);
        decodeexecute_branch_signal, reset, sp_overflow, memadd_overflow, decodeexecute_interrupt_signal, return_signal  : in std_logic;
        out_address, old_pc : out std_logic_vector (11 downto 0);
        out_flag_register : out std_logic_vector (2 downto 0);
        exception_flag, address_change_flag, stage_detector, flag_enable : out std_logic -- stage_detection { 1=>mem, 0=>execute  }
    );
end ACU;

architecture behavior of ACU is
signal mid_out: std_logic_vector(15 downto 0);
begin

    old_pc <=   (others => '0') when reset = '1' else
        executememory_pc when sp_overflow = '1' or return_signal = '1' or memadd_overflow = '1'
        else    decodeexecute_pc;
    address_change_flag <=  '0' when reset = '1' else  
                            '1' when return_signal = '1' or sp_overflow = '1' or memadd_overflow = '1' or mid_out(15) = '1' or mid_out(14) = '1' or mid_out(13) = '1' or mid_out(12) = '1' or decodeexecute_interrupt_signal = '1'
                            or (decodeexecute_branch_signal = '1' and (decodeexecute_branch_selector = "00" or (decodeexecute_branch_selector = "01" and execute_flag_register(0) = '1') or (decodeexecute_branch_selector = "10" and execute_flag_register(1) = '1') or (decodeexecute_branch_selector = "11" and execute_flag_register(2) = '1')))
                            else '0';
    out_flag_register <= (others => '0') when reset = '1' else execute_flag_register;
    stage_detector <= '0' when reset = '1' else  
                '1' when sp_overflow = '1' or return_signal = '1'
                else    '0';
    flag_enable <= '0' when reset = '1' else decodeexecute_interrupt_signal;
    exception_flag <= '0' when reset = '1' else mid_out(15) or mid_out(14) or mid_out(13) or mid_out(12) or sp_overflow;
    mid_out <=  (others => '0') when reset = '1'
        else    x"0000" when reset = '1'
        else    x"0002" when sp_overflow = '1'
        else    mem_out when return_signal = '1'
        else    interrupt_address when decodeexecute_interrupt_signal = '1'
        else    alu_src when decodeexecute_branch_signal = '1'
        else    (others => '0');
    
    out_address <= (others => '0') when reset = '1' else
                        x"004" when mid_out(15) = '1' or mid_out(14) = '1' or mid_out(13) = '1' or mid_out(12) = '1' or memadd_overflow = '1'
                        else mid_out(11 downto 0);
end behavior;