LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ControlUnit IS
    PORT (
        opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Reset : IN STD_LOGIC;
        preserveflags, branch, memwritesrc, RegDst, usersrc1, usersrc2 : OUT STD_LOGIC;
        branchselector, memaddsrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        regWrite : OUT STD_LOGIC;
        aluSource : OUT STD_LOGIC;
        HLT : OUT STD_LOGIC := '0';
        MW : OUT STD_LOGIC;
        MR : OUT STD_LOGIC;
        WB_Select : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        SP_Plus : OUT STD_LOGIC;
        SP_Negative : OUT STD_LOGIC;
        Alu_Select : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        OUT_enable : OUT STD_LOGIC;
        RET : OUT STD_LOGIC;
        INT : OUT STD_LOGIC
    );
END ControlUnit;

ARCHITECTURE Behavioral OF ControlUnit IS
BEGIN
    preserveflags <= '1' WHEN opCode = "00000" ELSE --NOP
        '1' WHEN opCode = "00001" ELSE --HLT
        '1' WHEN opCode = "00101" ELSE --OUT
        '1' WHEN opCode = "00110" ELSE --IN
        '1' WHEN opCode = "00111" ELSE --MOV
        '1' WHEN opCode = "01100" ELSE --PUSH
        '1' WHEN opCode = "01101" ELSE --POP
        '1' WHEN opCode = "01110" ELSE --LDM
        '1' WHEN opCode = "01111" ELSE --LDD
        '1' WHEN opCode = "10000" ELSE --STD
        '1' WHEN opCode = "10001" ELSE --JZ
        '1' WHEN opCode = "10010" ELSE --JN
        '1' WHEN opCode = "10011" ELSE --JC
        '1' WHEN opCode = "10100" ELSE --JMP
        '1' WHEN opCode = "10101" ELSE --CALL
        '1' WHEN opCode = "10110" ELSE --RET
        '1' WHEN opCode = "10111" ELSE --INT
        '0';
    HLT <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "00001" ELSE --HLT
        '0';
    INT <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "10111" ELSE --INT
        '1' WHEN opCode = "10111" ELSE --INT
        '0';
    branch <= '0' WHEN reset = '1' ELSE
        '1' WHEN opCode = "10001" ELSE --JZ
        '1' WHEN opCode = "10010" ELSE --JN
        '1' WHEN opCode = "10011" ELSE --JC
        '1' WHEN opCode = "10100" ELSE --JMP
        '1' WHEN opCode = "10101" ELSE --CALL
        '0';
    branchselector <= "00" WHEN reset = '1' ELSE
        "01" WHEN opCode = "10001" ELSE --JZ
        "10" WHEN opCode = "10010" ELSE --JN
        "11" WHEN opCode = "10011" ELSE --JC
        "00";
    RET <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "10110" ELSE --JMP
        '0';
    Alu_Select <= "000" WHEN Reset = '1' ELSE -- ALU_OP: 000: A, 001: B, 010: ADD, 011: SUB, 100: AND, 101: SETC, 110: NOT, 111:INC
        "001" WHEN opCode = "01110" ELSE --LDM 
        "001" WHEN opCode = "10111" ELSE --INT
        "010" WHEN opCode = "01000" ELSE --ADD
        "010" WHEN opCode = "01011" ELSE --IADD
        "010" WHEN opCode = "01111" ELSE --LDD
        "010" WHEN opCode = "10000" ELSE --STD
        "011" WHEN opCode = "01001" ELSE --SUB
        "100" WHEN opCode = "01010" ELSE --AND
        "101" WHEN opCode = "00010" ELSE --SETC
        "110" WHEN opCode = "00011" ELSE --NOT
        "111" WHEN opCode = "00100" ELSE --INC	
        "000";
    usersrc1 <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "00011" ELSE --NOT
        '1' WHEN opCode = "00100" ELSE --INC
        '1' WHEN opCode = "00101" ELSE --OUT
        '1' WHEN opCode = "00111" ELSE --MOV
        '1' WHEN opCode = "01000" ELSE --ADD
        '1' WHEN opCode = "01001" ELSE --SUB
        '1' WHEN opCode = "01010" ELSE --AND
        '1' WHEN opCode = "01011" ELSE --IADD
        '1' WHEN opCode = "10000" ELSE --STD
        '1' WHEN opCode = "01111" ELSE --LDD
        '1' WHEN opCode = "01111" ELSE --LDD
        '0';
    usersrc2 <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "01000" ELSE --ADD
        '1' WHEN opCode = "01001" ELSE --SUB
        '1' WHEN opCode = "01010" ELSE --AND
        '1' WHEN opCode = "10000" ELSE --STD
        '1' WHEN opCode = "01100" ELSE --PUSH
        '0';
    MR <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "01101" ELSE --POP
        '1' WHEN opCode = "01111" ELSE --LDD
        '1' WHEN opCode = "10110" ELSE --RET
        '1' WHEN opCode = "11000" ELSE --RTI
        '0';
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
        '1' WHEN opCode = "10111" ELSE --INT
        '0';
    memwritesrc <= '0' WHEN reset = '1' ELSE -- 0 for Rsrc2, 1 for PC+1
        '1' WHEN opCode = "10101" ELSE --CALL
        '1' WHEN opCode = "10111" ELSE --INT
        '0';
    memaddsrc <= "00" WHEN reset = '1' ELSE -- 0 for AlUout, 1 for old SP, 2 for new SP
        "01" WHEN opCode = "01100" ELSE --PUSH
        "01" WHEN opCode = "10101" ELSE --CALL
        "01" WHEN opCode = "10111" ELSE --INT
        "10" WHEN opCode = "01101" ELSE --POP
        "10" WHEN opCode = "10110" ELSE --RET
        "10" WHEN opCode = "11000" ELSE --RTI
        "00";
    MW <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "01100" ELSE --PUSH
        '1' WHEN opCode = "10000" ELSE --STD
        '1' WHEN opCode = "10101" ELSE --CALL
        '1' WHEN opCode = "10111" ELSE --INT
        '0';
    WB_Select <= "00" WHEN Reset = '1' ELSE -- 00 for ALU, 01 for Memory, 10 In port
        "00" WHEN opCode = "00011" ELSE --NOT
        "00" WHEN opCode = "00100" ELSE --INC
        "00" WHEN opCode = "00111" ELSE --MOV
        "00" WHEN opCode = "01000" ELSE --ADD
        "00" WHEN opCode = "01001" ELSE --SUB
        "00" WHEN opCode = "01010" ELSE --AND
        "00" WHEN opCode = "01011" ELSE --IADD
        "00" WHEN opCode = "01110" ELSE --LDM
        "01" WHEN opCode = "01111" ELSE --LDD
        "01" WHEN opCode = "01101" ELSE --POP
        "10" WHEN opCode = "00110" ELSE --IN	
        "00";
    SP_Plus <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "01101" ELSE --POP
        '1' WHEN opCode = "10110" ELSE --RET
        '1' WHEN opCode = "11000" ELSE --RTI
        '0';
    SP_Negative <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "01100" ELSE --PUSH
        '1' WHEN opCode = "01100" ELSE --PUSH
        '1' WHEN opCode = "10101" ELSE --CALL
        '1' WHEN opCode = "10111" ELSE --INT
        '0';
    SP_Plus <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "01101" ELSE --POP
        '1' WHEN opCode = "10110" ELSE --RET
        '1' WHEN opCode = "11000" ELSE --RTI
        '0';
    OUT_enable <= '0' WHEN Reset = '1' ELSE
        '1' WHEN opCode = "00101" ELSE --OUT
        '0';
    RegDst <= '0' WHEN Reset = '1' ELSE -- 0 for rsrc2, 1 for rdst
        '1' WHEN opCode = "01000" ELSE --ADD
        '1' WHEN opCode = "01001" ELSE --SUB
        '1' WHEN opCode = "01010" ELSE --AND
        '0';
END Behavioral;