library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FlagRegister is
    Port (
        clk      : in std_logic;           -- Clock signal
        reset    : in std_logic;           -- Asynchronous reset
        carry_in : in std_logic;           -- Carry flag input
        zero_in  : in std_logic;           -- Zero flag input
        neg_in   : in std_logic;           -- Negative flag input
        carry_out : out std_logic;         -- Carry flag output
        zero_out  : out std_logic;         -- Zero flag output
        neg_out   : out std_logic          -- Negative flag output
    );
end FlagRegister;

architecture Behavioral of FlagRegister is
    signal carry_flag : std_logic := '0';  -- Internal Carry flag
    signal zero_flag  : std_logic := '0';  -- Internal Zero flag
    signal neg_flag   : std_logic := '0';  -- Internal Negative flag
begin

    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset all flags to 0
            carry_flag <= '0';
            zero_flag  <= '0';
            neg_flag   <= '0';
        elsif rising_edge(clk) then
            -- Update flags on clock edge
            carry_flag <= carry_in;
            zero_flag  <= zero_in;
            neg_flag   <= neg_in;
        end if;
    end process;

    -- Assign internal flags to outputs
    carry_out <= carry_flag;
    zero_out  <= zero_flag;
    neg_out   <= neg_flag;

end Behavioral;