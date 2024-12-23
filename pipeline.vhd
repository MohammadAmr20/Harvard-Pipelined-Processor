LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY processor IS
    PORT (
        clk, reset : IN STD_LOGIC;
        in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END processor;

ARCHITECTURE behavior OF processor IS
    SIGNAL pc : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL instruction, instruction_reg, in_reg, selected_instruction_ifid, selected_immediate_ifid : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reserved_flags : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL if_id_out_rsrc1, if_id_out_rsrc2, if_id_out_rdest : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL if_id_out_opCode : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL if_id_out_pc : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL if_id_out_reserved_flags : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL if_id_out_in_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL if_id_out_immediate : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL id_ex_in_data1, id_ex_in_data2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL id_ie_out_rsrc1, id_ie_out_rsrc2, id_ie_out_rdest : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL id_ex_in_preserveflags, id_ex_in_branch, id_ex_in_memwritesrc, id_ex_in_RegDst, id_ex_in_usersrc1, id_ex_in_usersrc2 : STD_LOGIC;
    SIGNAL id_ex_in_branchselector, id_ex_in_memaddsrc, id_ex_in_wb_select : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL id_ex_in_ALU_Select : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL id_ex_in_regWrite, id_ex_in_aluSource, id_ex_in_HLT, id_ex_in_MW, id_ex_in_MR, id_ex_in_SP_Plus, id_ex_in_SP_Negative, id_ex_in_OUT_enable, id_ex_in_RET, id_ex_in_INT : STD_LOGIC;

    SIGNAL ie_mem_alu_out, ie_mem_in_data, ie_mem_mem_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0'); --IE/MEM outputs
    SIGNAL ie_mem_reg_write, ie_mem_to_reg, ie_mem_in_sig : STD_LOGIC := '0'; -- IE/MEM RegWrite signal
    SIGNAL ie_mem_reg_adrs : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0'); -- IE/MEM RegAddress 

    SIGNAL id_ex_alu_oper1, id_ex_alu_oper2, id_ex_alu_oper2_pre : STD_LOGIC_VECTOR(15 DOWNTO 0); --ALU operand
    SIGNAL mem_forward_data, wb_forward_data : STD_LOGIC_VECTOR(15 DOWNTO 0); --OUTPUT OF Forwarding Unit
    SIGNAL alu_src1, alu_src2 : STD_LOGIC_VECTOR(1 DOWNTO 0); -- ALU Source Selector

    SIGNAL pc_stall : STD_LOGIC;

    SIGNAL reset_ifid : STD_LOGIC;
    SIGNAL mem_wb_out_regwrite : STD_LOGIC := '0';
    SIGNAL mem_wb_out_regdst : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mem_wb_out_dataout : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    COMPONENT InstructionMemory IS
        PORT (
            addr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT if_id_Register IS
        PORT (
            clk, reset, pause : IN STD_LOGIC;
            pc : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            reserved_flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            instruction, immediate, in_reg : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            opCode : OUT STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
            rs, rt, rd, out_reserved_flags : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
            out_pc : OUT STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
            out_immediate, out_in_reg : OUT STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0')
        );
    END COMPONENT;
    COMPONENT RegisterFile IS
        PORT (
            clk, writeEnable : IN STD_LOGIC;
            writeAddr, Rsrc1, Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            writeData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            readData1, readData2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT ControlUnit IS
        PORT (
            opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Reset : IN STD_LOGIC;
            preserveflags, branch, memwritesrc, RegDst, usersrc1, usersrc2 : OUT STD_LOGIC;
            branchselector, memaddsrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            regWrite, aluSource, HLT, MW, MR : OUT STD_LOGIC;
            WB_Select : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            ALU_Select : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            SP_Plus, SP_Negative, OUT_enable, RET, INT : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT ALU IS
        PORT (
            A : IN signed(15 DOWNTO 0); -- Input operand A
            B : IN signed(15 DOWNTO 0); -- Input operand B
            op, reserved_flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Operation selector
            clk, RET, preserve_flags, Reset : IN STD_LOGIC; -- Clock input
            result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- ALU result
            flag_reg : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0') -- Flag output
        );
    END COMPONENT;

    COMPONENT ForwardingUnit IS
        PORT (
            -- Inputs
            mem_wb_reg_write : IN STD_LOGIC; -- MEM/WB RegWrite signal
            ie_mem_reg_write : IN STD_LOGIC; -- IE/MEM RegWrite signal
            ie_mem_to_reg : IN STD_LOGIC; -- IE/MEM MemtoReg signal
            ie_mem_in_sig : IN STD_LOGIC; -- IE/MEM input signal

            mem_wb_data_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- MEM/WB data output
            ie_mem_alu_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- IE/MEM ALU result
            ie_mem_in_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- IE/MEM IN DATA
            ie_mem_mem_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- IE/MEM MEM DATA

            mem_wb_reg_adrs : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- MEM/WB register address
            ie_mem_reg_adrs : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- IE/MEM register address

            id_ie_rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- ID/IE rsrc1 address
            id_ie_rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- ID/IE rsrc2 address
            id_ie_usersrc1 : IN STD_LOGIC; -- ID/IE uses rsrc1
            id_ie_usersrc2 : IN STD_LOGIC; -- ID/IE uses rsrc2

            -- Outputs
            alu_src1 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- ALU source 1 mux signal
            alu_src2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- ALU source 2 mux signal
            mem_forward_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- Forwarded data from MEM
            wb_forward_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- Forwarded data from WB
        );
    END COMPONENT;

    COMPONENT HazardDetection IS
    PORT (
        -- Inputs
        id_ie_mem_read : IN STD_LOGIC; -- IE/MEM memRead  signal
        id_ie_reg_write : IN STD_LOGIC; -- IE/MEM RegWrite signal

        id_ie_reg_adrs : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- ID/IE register address

        if_id_rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- ID/IE rsrc1 address
        if_id_rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- ID/IE rsrc2 address
        if_id_usersrc1 : IN STD_LOGIC; -- ID/IE uses rsrc1
        if_id_usersrc2 : IN STD_LOGIC; -- ID/IE uses rsrc2

        -- Outputs
        pc_stall : OUT STD_LOGIC -- PC stall

    );
    END COMPONENT;
BEGIN
    reset_ifid <= reset OR ((NOT instruction_reg(0)) AND instruction(0));
    selected_instruction_ifid <= instruction_reg WHEN instruction_reg(0) = '1' ELSE
        instruction;
    selected_immediate_ifid <= instruction AND (0 TO 15 => instruction_reg(0));
    InstructionMemory1 : InstructionMemory PORT MAP(
        addr => pc,
        data_out => instruction
    );

    id_ex_alu_oper2_pre <= if_id_out_immediate WHEN id_ex_in_aluSource = '1' ELSE
        id_ex_in_data2;

    id_ex_alu_oper2 <= mem_forward_data WHEN (alu_src2 = "01") ELSE
        wb_forward_data WHEN (alu_src2 = "10") ELSE
        id_ex_alu_oper2_pre;

    id_ex_alu_oper1 <= mem_forward_data WHEN (alu_src1 = "01") ELSE
        wb_forward_data WHEN (alu_src1 = "10") ELSE
        id_ex_in_data1;

    IFIDRegister1 : if_id_register PORT MAP(
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
    RegisterFile1 : RegisterFile PORT MAP(
        clk => clk,
        writeEnable => mem_wb_out_regwrite,
        writeAddr => mem_wb_out_regdst,
        Rsrc1 => if_id_out_rsrc1,
        Rsrc2 => if_id_out_rsrc2,
        writeData => mem_wb_out_dataout,
        readData1 => id_ex_in_data1,
        readData2 => id_ex_in_data2
    );
    ControlUnit1 : ControlUnit PORT MAP(
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

    ForwardingUnit1 : ForwardingUnit PORT MAP(
        mem_wb_reg_write => mem_wb_out_regwrite, -- MEM/WB RegWrite signal
        ie_mem_reg_write => ie_mem_reg_write, -- IE/MEM RegWrite signal
        ie_mem_to_reg => ie_mem_to_reg, -- IE/MEM MemtoReg signal
        ie_mem_in_sig => ie_mem_in_sig, -- IE/MEM input signal

        mem_wb_data_out => mem_wb_out_dataout, -- MEM/WB data output
        ie_mem_alu_out => ie_mem_alu_out, -- IE/MEM ALU result
        ie_mem_in_data => ie_mem_in_data, -- IE/MEM IN DATA
        ie_mem_mem_data => ie_mem_mem_data, -- IE/MEM MEM DATA

        mem_wb_reg_adrs => mem_wb_out_regdst, -- MEM/WB register address
        ie_mem_reg_adrs => ie_mem_reg_adrs, -- IE/MEM register address

        id_ie_rsrc1 => id_ie_out_rsrc1, -- ID/IE rsrc1 address
        id_ie_rsrc2 => id_ie_out_rsrc2, -- ID/IE rsrc2 address
        id_ie_usersrc1 => id_ex_in_usersrc1,  -- ID/IE uses rsrc1
        id_ie_usersrc2 => id_ex_in_usersrc2, -- ID/IE uses rsrc2

        -- Outputs
        alu_src1 => alu_src1, -- ALU source 1 mux signal
        alu_src2 => alu_src2, -- ALU source 2 mux signal
        mem_forward_data => mem_forward_data, -- Forwarded data from MEM
        wb_forward_data => wb_forward_data  -- Forwarded data from WB
    );

    HazardDetection1 : HazardDetection PORT MAP (
        -- Inputs
        id_ie_mem_read => id_ex_in_MR, -- IE/MEM memRead  signal
        id_ie_reg_write => id_ex_in_regWrite,-- IE/MEM RegWrite signal

        id_ie_reg_adrs => id_ie_out_rdest, -- ID/IE register address

        if_id_rsrc1 => if_id_out_rsrc1, -- ID/IE rsrc1 address
        if_id_rsrc2 => if_id_out_rsrc2, -- ID/IE rsrc2 address
        if_id_usersrc1 => id_ex_in_usersrc1, -- ID/IE uses rsrc1
        if_id_usersrc2 => id_ex_in_usersrc2, -- ID/IE uses rsrc2

        -- Outputs
        pc_stall => pc_stall -- PC stall

    );

    PROCESS (clk) BEGIN
        IF reset = '1' THEN
            pc <= (OTHERS => '0');
            reserved_flags <= (OTHERS => '0');
            instruction_reg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            pc <= STD_LOGIC_VECTOR(unsigned(pc) + 1);
            IF instruction_reg(0) = '1' THEN
                instruction_reg <= (OTHERS => '0');
            ELSE
                instruction_reg <= instruction;
            END IF;
        END IF;
    END PROCESS;
END behavior;