LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ControlUnit IS
    PORT (
        opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Reset : IN STD_LOGIC;
        regWrite : OUT STD_LOGIC;
        aluSource : OUT STD_LOGIC;
        HLT : OUT STD_LOGIC;
        MW : OUT STD_LOGIC;
        MR : OUT STD_LOGIC;
        WB_Select : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        SP_Plus : OUT STD_LOGIC;
        SP_Negative : OUT STD_LOGIC;
        Alu_Select : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        OUT_enable : OUT STD_LOGIC;
        JMP : OUT STD_LOGIC;
        JZ : OUT STD_LOGIC;
        JN : OUT STD_LOGIC;
        JC : OUT STD_LOGIC;
        CALL : OUT STD_LOGIC;
        RET : OUT STD_LOGIC;
        INT : OUT STD_LOGIC;
        RTI : OUT STD_LOGIC
    );
END ControlUnit;

ARCHITECTURE Behavioral OF ControlUnit IS
BEGIN
    regWrite <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "00011" ELSE --NOT
        '1' WHEN opCode = "00100" ELSE --INC 	
        '1' WHEN opCode = "00110" ELSE --IN	
        '1' WHEN opCode = "00111" ELSE --MOV	
        '1' WHEN opCode = "01000" ELSE --ADD	
        '1' WHEN opCode = "01001" ELSE --SUB
        '1' WHEN opCode = "01010" ELSE --AND
        '1' WHEN opCode = "01011" ELSE --IADD	
        '1' WHEN opCode = "01101" ELSE --POP	
        '1' WHEN opCode = "01110" ELSE --LDM	
        '1' WHEN opCode = "01111" ELSE --LDD	
        '0';
    aluSource <= '0' WHEN Reset = '1' ELSE -- 1 for IMM and 0 for Rt
        '1' WHEN opCode = "01011" ELSE --IADD	
        '1' WHEN opCode = "01110" ELSE --LDM
        '1' WHEN opCode = "01111" ELSE --LDD	
        '1' WHEN opCode = "10000" ELSE --STD	
        '0';
    MW <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "01100" ELSE --PUSH
        '1' WHEN opCode = "10000" ELSE --STD
        '1' WHEN opCode = "10101" ELSE --CALL
        '1' WHEN opCode = "10111" ELSE --INT
        '0';
    MR <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "01101" ELSE --POP
        '1' WHEN opCode = "01111" ELSE --LDD
        '1' WHEN opCode = "10110" ELSE --RET
        '1' WHEN opCode = "11000" ELSE --RTI
        '0';
    WB_Select <= "00" WHEN Reset = '1' ELSE -- 00 for ALU, 01 for Memory, 10 In port
        "00" WHEN opCode = "00011" ELSE --NOT
        "00" WHEN opCode = "00100" ELSE --INC
        "00" WHEN opCode = "00111" ELSE --MOV
        "00" WHEN opCode = "01000" ELSE --ADD
        "00" WHEN opCode = "01001" ELSE --SUB
        "00" WHEN opCode = "01010" ELSE --AND
        "00" WHEN opCode = "01011" ELSE --IADD
        "01" WHEN opCode = "01111" ELSE --LDD
        "01" WHEN opCode = "01110" ELSE --LDM
        "10" WHEN opCode = "00110" ELSE --IN	
        "00";
    SP_Plus <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "01100" ELSE  --POP
        '0';
    SP_Negative <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "01101" ELSE --PUSH
        '0';
    HLT <= '0' WHEN Reset = '1' else
        '1' WHEN opCode "00001" ELSE  --HLT
        '0';
    Alu_Select <= "000" WHEN Reset = '1' ELSE -- ALU_OP: 000: A, 001: B, 010: ADD, 011: SUB, 100: AND, 110: NOT, 111:INC
        "000" WHEN opCode = "00111" ELSE --MOV
        "000" WHEN opCode = "00101" ELSE --OUT
        "001" WHEN opCode = "01110" ELSE --LDM 
        "010" WHEN opCode = "01000" ELSE --ADD
        "011" WHEN opCode = "01001" ELSE --SUB
        "100" WHEN opCode = "01010" ELSE --AND
        "110" WHEN opCode = "00011" ELSE --NOT
        "111" WHEN opCode = "00100" ELSE --INC	
        "000";
    OUT_enable <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "00101" ELSE --OUT
        '0';
    JMP <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "10100" ELSE --JMP
        '0';
    JZ <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "10001" ELSE --JZ
        '0';
    JN <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "10010" ELSE --JN
        '0';
    JC <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "10011" ELSE --JMP
        '0';
    CALL <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "10101" ELSE --JMP
        '0';
    RET <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "10110" ELSE --JMP
        '0';
    INT <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "10111" ELSE --JMP
        '0';
    RTI <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "11000" ELSE --JMP
        '0';
END Behavioral;