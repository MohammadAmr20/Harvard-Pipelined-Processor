LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY processor IS
    PORT (
        clk, reset : IN STD_LOGIC;
        in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END processor;

ARCHITECTURE behavior OF processor IS
    SIGNAL out_port_internal : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sp, sp_new : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '1');
    SIGNAL instruction, instruction_reg, in_reg, selected_instruction_ifid, selected_immediate_ifid : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reserved_flags, acu_out_flag_register : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL if_id_out_rsrc1, if_id_out_rsrc2, if_id_out_rdest : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL if_id_out_opCode : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL if_id_out_pc, if_id_out_pc_1 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL if_id_out_reserved_flags : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL if_id_out_in_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL if_id_out_immediate : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL acu_in_interrupt_address : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL acu_old_pc, exception_pc, acu_out_address : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL acu_exception_flag, acu_address_change_flag, acu_stage_detector, acu_flag_enable : STD_LOGIC;
    --------------------------------------------------------------------------------------------------------  

    SIGNAL id_ex_in_data1, id_ex_in_data2, id_ex_in_in_data, id_ex_in_immediate : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL id_ex_in_preserveflags, id_ex_in_branch, id_ex_in_memwritesrc, id_ex_in_RegDst, id_ex_in_usersrc1, id_ex_in_usersrc2 : STD_LOGIC;
    SIGNAL id_ex_in_branchselector, id_ex_in_memaddsrc, id_ex_in_wb_select : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL id_ex_in_ALU_Select, id_ex_in_reserved_flags : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL id_ex_in_regWrite, id_ex_in_aluSource, id_ex_in_HLT, id_ex_in_MW, id_ex_in_MR, id_ex_in_SP_Plus, id_ex_in_SP_Negative, id_ex_in_OUT_enable, id_ex_in_RET, id_ex_in_INT : STD_LOGIC;
    SIGNAL id_ex_in_rsrc1, id_ex_in_rsrc2, id_ex_in_rdest : STD_LOGIC_VECTOR(2 DOWNTO 0);

    SIGNAL id_ex_out_pc, id_ex_out_pc_1 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL id_ex_out_data1, id_ex_out_data2, id_ex_out_in_data, id_ex_out_immediate : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL id_ex_out_preserveflags, id_ex_out_branch, id_ex_out_memwritesrc, id_ex_out_RegDst, id_ex_out_usersrc1, id_ex_out_usersrc2 : STD_LOGIC;
    SIGNAL id_ex_out_branchselector, id_ex_out_memaddsrc, id_ex_out_wb_select : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL id_ex_out_ALU_Select, id_ex_out_reserved_flags : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL id_ex_out_regWrite, id_ex_out_aluSource, id_ex_out_HLT, id_ex_out_MW, id_ex_out_MR, id_ex_out_SP_Plus, id_ex_out_SP_Negative, id_ex_out_OUT_enable, id_ex_out_RET, id_ex_out_INT : STD_LOGIC;
    SIGNAL id_ex_out_rsrc1, id_ex_out_rsrc2, id_ex_out_rdest : STD_LOGIC_VECTOR(2 DOWNTO 0);

    SIGNAL id_ex_alu_oper1, id_ex_alu_oper2, id_ex_alu_oper2_pre : STD_LOGIC_VECTOR(15 DOWNTO 0); --ALU operand
    SIGNAL alu_result : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL flag_register : STD_LOGIC_VECTOR(2 DOWNTO 0);

    --------------------------------------------------------------------------------------------------------  

    SIGNAL ex_mem_out_rsrc2, ex_mem_out_alu_result, ex_mem_out_in_data, ex_mem_out_mem_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0'); --IE/MEM outputs
    SIGNAL ex_mem_out_pc, ex_mem_out_pc_1 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL ex_mem_out_memwritesrc, ex_mem_out_regWrite, ex_mem_out_MW, ex_mem_out_MR, ex_mem_out_SP_Plus, ex_mem_out_SP_Negative, ex_mem_out_OUT_enable, ex_mem_out_RET, ex_mem_out_INT : STD_LOGIC := '0'; -- IE/MEM RegWrite signal
    SIGNAL ex_mem_out_rdest : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0'); -- IE/MEM RegAddress 
    SIGNAL ex_mem_out_memaddsrc, ex_mem_out_wb_select : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0'); -- IE/MEM RegAddress 

    SIGNAL ex_mem_in_rsrc2, ex_mem_in_alu_result, ex_mem_in_in_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0'); --IE/MEM inputs
    SIGNAL ex_mem_in_pc, ex_mem_in_pc_1 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL ex_mem_in_memwritesrc, ex_mem_in_regWrite, ex_mem_in_MW, ex_mem_in_MR, ex_mem_in_SP_Plus, ex_mem_in_SP_Negative, ex_mem_in_OUT_enable, ex_mem_in_RET, ex_mem_in_INT : STD_LOGIC := '0'; -- IE/MEM RegWrite signal
    SIGNAL ex_mem_in_rdest : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0'); -- IE/MEM RegAddress 
    SIGNAL ex_mem_in_memaddsrc, ex_mem_in_wb_select : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0'); -- IE/MEM RegAddress 

    --------------------------------------------------------------------------------------------------------  

    SIGNAL sp_adder : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL sp_overflow : STD_LOGIC;
    CONSTANT ZERO : STD_LOGIC_VECTOR(11 DOWNTO 0) := STD_LOGIC_VECTOR(to_signed(0, 12));
    CONSTANT POS_TWO : STD_LOGIC_VECTOR(11 DOWNTO 0) := STD_LOGIC_VECTOR(to_signed(2, 12));
    CONSTANT NEG_TWO : STD_LOGIC_VECTOR(11 DOWNTO 0) := STD_LOGIC_VECTOR(to_signed(-2, 12));
    SIGNAL memory_address : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL memory_address_overflow : STD_LOGIC;
    SIGNAL memory_data_in, memory_data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory_we, memory_re : STD_LOGIC;

    SIGNAL mem_forward_data, wb_forward_data : STD_LOGIC_VECTOR(15 DOWNTO 0); --OUTPUT OF Forwarding Unit
    SIGNAL alu_src1, alu_src2 : STD_LOGIC_VECTOR(1 DOWNTO 0); -- ALU Source Selector

    SIGNAL pc_stall : STD_LOGIC;

    --------------------------------------------------------------------------------------------------------  

    SIGNAL mem_wb_in_regwrite, mem_wb_in_OUT_enable : STD_LOGIC := '0';
    SIGNAL mem_wb_in_wb_select : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL mem_wb_in_regdst : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mem_wb_in_mem_data, mem_wb_in_alu_result, mem_wb_in_in_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    SIGNAL mem_wb_out_regwrite, mem_wb_out_OUT_enable : STD_LOGIC := '0';
    SIGNAL mem_wb_out_wb_select : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL mem_wb_out_regdst : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mem_wb_out_dataout : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mem_wb_out_mem_data, mem_wb_out_alu_result, mem_wb_out_in_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    --------------------------------------------------------------------------------------------------------  

    SIGNAL reset_ifid, reset_idie : STD_LOGIC;
    COMPONENT mem_wb_register IS
        PORT (
            clk : IN STD_LOGIC;

            -- Input signals
            mem_wb_in_mem_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            mem_wb_in_alu_result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            mem_wb_in_in_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

            mem_wb_in_wb_select : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            mem_wb_in_regWrite : IN STD_LOGIC;
            mem_wb_in_OUT_enable : IN STD_LOGIC;
            mem_wb_in_rdest : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            -- Output signals
            mem_wb_out_mem_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            mem_wb_out_alu_result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            mem_wb_out_in_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

            mem_wb_out_wb_select : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            mem_wb_out_regWrite : OUT STD_LOGIC;
            mem_wb_out_OUT_enable : OUT STD_LOGIC;
            mem_wb_out_rdest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT InstructionMemory IS
        PORT (
            addr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT DataMemory IS
        PORT (
            clk : IN STD_LOGIC; -- Clock signal
            addr : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- 12-bit address input (4K = 2^12)
            data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- 16-bit data input
            we : IN STD_LOGIC; -- Write enable signal
            re : IN STD_LOGIC; -- Read enable signal
            data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- 16-bit data output
        );
    END COMPONENT;
    COMPONENT SPAdder IS
        PORT (
            A : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- 12-bit unsigned input
            B : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- 12-bit unsigned input
            Sum : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- 12-bit unsigned sum
            Overflow : OUT STD_LOGIC -- Overflow flag
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

    COMPONENT id_ex_register IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            -- Input signals
            id_ex_in_data1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            id_ex_in_data2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            id_ex_in_in_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            id_ex_in_immediate : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            id_ex_in_pc : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            id_ex_in_pc_1 : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            id_ex_in_preserveflags : IN STD_LOGIC;
            id_ex_in_branch : IN STD_LOGIC;
            id_ex_in_memwritesrc : IN STD_LOGIC;
            id_ex_in_RegDst : IN STD_LOGIC;
            id_ex_in_usersrc1 : IN STD_LOGIC;
            id_ex_in_usersrc2 : IN STD_LOGIC;
            id_ex_in_branchselector : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            id_ex_in_memaddsrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            id_ex_in_wb_select : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            id_ex_in_ALU_Select : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            id_ex_in_reserved_flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            id_ex_in_regWrite : IN STD_LOGIC;
            id_ex_in_aluSource : IN STD_LOGIC;
            id_ex_in_HLT : IN STD_LOGIC;
            id_ex_in_MW : IN STD_LOGIC;
            id_ex_in_MR : IN STD_LOGIC;
            id_ex_in_SP_Plus : IN STD_LOGIC;
            id_ex_in_SP_Negative : IN STD_LOGIC;
            id_ex_in_OUT_enable : IN STD_LOGIC;
            id_ex_in_RET : IN STD_LOGIC;
            id_ex_in_INT : IN STD_LOGIC;
            id_ex_in_rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            id_ex_in_rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            id_ex_in_rdest : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            -- Output signals
            id_ex_out_data1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            id_ex_out_data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            id_ex_out_in_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            id_ex_out_immediate : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            id_ex_out_pc : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            id_ex_out_pc_1 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            id_ex_out_preserveflags : OUT STD_LOGIC;
            id_ex_out_branch : OUT STD_LOGIC;
            id_ex_out_memwritesrc : OUT STD_LOGIC;
            id_ex_out_RegDst : OUT STD_LOGIC;
            id_ex_out_usersrc1 : OUT STD_LOGIC;
            id_ex_out_usersrc2 : OUT STD_LOGIC;
            id_ex_out_branchselector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            id_ex_out_memaddsrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            id_ex_out_wb_select : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            id_ex_out_ALU_Select : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            id_ex_out_reserved_flags : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            id_ex_out_regWrite : OUT STD_LOGIC;
            id_ex_out_aluSource : OUT STD_LOGIC;
            id_ex_out_HLT : OUT STD_LOGIC;
            id_ex_out_MW : OUT STD_LOGIC;
            id_ex_out_MR : OUT STD_LOGIC;
            id_ex_out_SP_Plus : OUT STD_LOGIC;
            id_ex_out_SP_Negative : OUT STD_LOGIC;
            id_ex_out_OUT_enable : OUT STD_LOGIC;
            id_ex_out_RET : OUT STD_LOGIC;
            id_ex_out_INT : OUT STD_LOGIC;
            id_ex_out_rsrc1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            id_ex_out_rsrc2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            id_ex_out_rdest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT ex_mem_register IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            -- Input signals
            ex_mem_in_rsrc2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            ex_mem_in_alu_result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            ex_mem_in_in_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            ex_mem_in_pc : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            ex_mem_in_pc_1 : IN STD_LOGIC_VECTOR(11 DOWNTO 0);

            ex_mem_in_memwritesrc : IN STD_LOGIC;
            ex_mem_in_memaddsrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            ex_mem_in_wb_select : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            ex_mem_in_regWrite : IN STD_LOGIC;
            ex_mem_in_MW : IN STD_LOGIC;
            ex_mem_in_MR : IN STD_LOGIC;
            ex_mem_in_SP_Plus : IN STD_LOGIC;
            ex_mem_in_SP_Negative : IN STD_LOGIC;
            ex_mem_in_OUT_enable : IN STD_LOGIC;
            ex_mem_in_RET : IN STD_LOGIC;
            ex_mem_in_INT : IN STD_LOGIC;
            ex_mem_in_rdest : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            -- Output signals
            ex_mem_out_rsrc2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            ex_mem_out_alu_result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            ex_mem_out_in_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            ex_mem_out_pc : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            ex_mem_out_pc_1 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);

            ex_mem_out_memwritesrc : OUT STD_LOGIC;
            ex_mem_out_memaddsrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            ex_mem_out_wb_select : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            ex_mem_out_regWrite : OUT STD_LOGIC;
            ex_mem_out_MW : OUT STD_LOGIC;
            ex_mem_out_MR : OUT STD_LOGIC;
            ex_mem_out_SP_Plus : OUT STD_LOGIC;
            ex_mem_out_SP_Negative : OUT STD_LOGIC;
            ex_mem_out_OUT_enable : OUT STD_LOGIC;
            ex_mem_out_RET : OUT STD_LOGIC;
            ex_mem_out_INT : OUT STD_LOGIC;
            ex_mem_out_rdest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
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
            clk : IN STD_LOGIC;
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
    COMPONENT interrupt_table is
        port(
            index : in std_logic_vector(3 downto 0);
            data_out : out std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    COMPONENT ACU is
        port(
            decodeexecute_pc, executememory_pc : in std_logic_vector(11 downto 0);
            interrupt_address, alu_src, mem_out : in std_logic_vector(15 downto 0);
            decodeexecute_branch_selector : in std_logic_vector(1 downto 0);
            execute_flag_register : in std_logic_vector (2 downto 0);
            decodeexecute_branch_signal, reset, sp_overflow, memadd_overflow, decodeexecute_interrupt_signal, return_signal  : in std_logic;
            out_address, old_pc : out std_logic_vector (11 downto 0);
            out_flag_register : out std_logic_vector (2 downto 0);
            exception_flag, address_change_flag, stage_detector, flag_enable : out std_logic -- stage_detection { 1=>mem, 0=>execute  }
        );
    END COMPONENT;
    COMPONENT FlushUnit is
        PORT(
            -- Inputs
            branch : IN STD_LOGIC; -- branching exist or not
            stage : IN STD_LOGIC; -- branching stage 0=Excute, 1=Memory
            -- Outputs
            flush_if_id : OUT STD_LOGIC; -- Reset FetchDecode Register
            flush_id_ie : OUT STD_LOGIC; -- Reset DecodeExcute Register
            flush_ie_mem : OUT STD_LOGIC -- Reset ExcuteMemory Register
        );
    END COMPONENT;
BEGIN
    reset_ifid <= reset OR ((NOT instruction_reg(0)) AND instruction(0));
    reset_idie <= pc_stall;
    selected_instruction_ifid <= instruction_reg WHEN instruction_reg(0) = '1' ELSE
        instruction;
    selected_immediate_ifid <= instruction AND (0 TO 15 => instruction_reg(0));

    id_ex_alu_oper2 <= id_ex_out_immediate WHEN id_ex_out_aluSource = '1' ELSE
        id_ex_alu_oper2_pre;

    id_ex_alu_oper2_pre <= mem_forward_data WHEN (alu_src2 = "01") ELSE
        wb_forward_data WHEN (alu_src2 = "10") ELSE
        id_ex_out_data2;

    id_ex_alu_oper1 <= mem_forward_data WHEN (alu_src1 = "01") ELSE
        wb_forward_data WHEN (alu_src1 = "10") ELSE
        id_ex_out_data1;

    id_ex_in_rsrc1 <= if_id_out_rsrc1;
    id_ex_in_rsrc2 <= if_id_out_rsrc2;
    id_ex_in_rdest <= if_id_out_rdest;
    id_ex_in_in_data <= if_id_out_in_reg;
    id_ex_in_immediate <= if_id_out_immediate;
    id_ex_in_reserved_flags <= if_id_out_reserved_flags;
    if_id_out_pc_1 <= STD_LOGIC_VECTOR(unsigned(if_id_out_pc) + 1);

    ex_mem_in_rsrc2 <= id_ex_alu_oper2_pre;
    ex_mem_in_alu_result <= alu_result;
    ex_mem_in_in_data <= id_ex_in_in_data;
    ex_mem_in_pc <= id_ex_out_pc;
    ex_mem_in_pc_1 <= id_ex_out_pc_1;
    ex_mem_in_memwritesrc <= id_ex_out_memwritesrc;
    ex_mem_in_regWrite <= id_ex_out_regWrite;
    ex_mem_in_MW <= id_ex_out_MW;
    ex_mem_in_MR <= id_ex_out_MR;
    ex_mem_in_SP_Plus <= id_ex_out_SP_Plus;
    ex_mem_in_SP_Negative <= id_ex_out_SP_Negative;
    ex_mem_in_OUT_enable <= id_ex_out_OUT_enable;
    ex_mem_in_RET <= id_ex_out_RET;
    ex_mem_in_INT <= id_ex_out_INT;
    ex_mem_in_memaddsrc <= id_ex_out_memaddsrc;
    ex_mem_in_wb_select <= id_ex_out_wb_select;

    ex_mem_in_rdest <= id_ex_out_rdest WHEN id_ex_out_RegDst = '1'
        ELSE
        id_ex_out_rsrc2;

    sp_adder <= ZERO WHEN (ex_mem_out_SP_Plus = '0' AND ex_mem_out_SP_Negative = '0') ELSE
        POS_TWO WHEN (ex_mem_out_SP_Plus = '1' AND ex_mem_out_SP_Negative = '0') ELSE
        NEG_TWO WHEN (ex_mem_out_SP_Plus = '0' AND ex_mem_out_SP_Negative = '1') ELSE
        ZERO;
    memory_re <= ex_mem_out_MR;
    memory_we <= (ex_mem_out_MW AND NOT sp_overflow);

    memory_address <= sp_new WHEN ex_mem_out_memaddsrc = "10" ELSE
        sp WHEN ex_mem_out_memaddsrc = "01" ELSE
        ex_mem_out_alu_result(11 DOWNTO 0);
    
    memory_address_overflow <= '1' when (ex_mem_out_MR = '1') and (ex_mem_out_memaddsrc = "11" or ex_mem_out_memaddsrc = "00") and ( ex_mem_out_alu_result(12) = '1' or ex_mem_out_alu_result(15) = '1' or ex_mem_out_alu_result(14) = '1' or ex_mem_out_alu_result(13) = '1' ) 
        else '0';

    memory_data_in <= "0000" & ex_mem_out_pc_1 WHEN ex_mem_out_memwritesrc = '1' ELSE
        ex_mem_out_rsrc2;
    mem_wb_in_regwrite <= ex_mem_out_regWrite;
    mem_wb_in_wb_select <= ex_mem_out_wb_select;
    mem_wb_in_regdst <= ex_mem_out_rdest;
    mem_wb_in_mem_data <= memory_data_out;
    mem_wb_in_alu_result <= ex_mem_out_alu_result;
    mem_wb_in_in_data <= ex_mem_out_in_data;
    mem_wb_in_OUT_enable <= ex_mem_out_OUT_enable;
    SPAdder1 : SPAdder PORT MAP(
        A => sp, -- 12-bit unsigned input
        B => sp_adder, -- 12-bit unsigned input
        Sum => sp_new, -- 12-bit unsigned sum
        Overflow => sp_overflow -- Overflow flag
    );
    InstructionMemory1 : InstructionMemory PORT MAP(
        addr => pc,
        data_out => instruction
    );
    DataMemory1 : DataMemory PORT MAP(
        clk => clk, -- Clock signal
        addr => memory_address, -- 12-bit address input (4K = 2^12)
        data_in => memory_data_in, -- 16-bit data input
        we => memory_we, -- Write enable signal
        re => memory_re, -- Read enable signal
        data_out => memory_data_out -- 16-bit data output
    );

    ALU1 : ALU PORT MAP(
        clk => clk,
        Reset => reset,
        A => SIGNED(id_ex_alu_oper1), -- Input operand A
        B => SIGNED(id_ex_alu_oper2), -- Input operand B
        op => id_ex_out_ALU_Select,
        reserved_flags => id_ex_out_reserved_flags, -- Operation selector
        preserve_flags => id_ex_out_preserveflags,
        RET => id_ex_out_RET, -- Clock input
        result => alu_result, -- ALU result
        flag_reg => flag_register -- Flag output
    );
    IFIDRegister1 : if_id_register PORT MAP(
        clk => clk,
        reset => reset_ifid,
        pause => pc_stall,
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

    IDIERegister1 : id_ex_register PORT MAP(
        clk => clk,
        reset => reset_idie,

        -- Input signals
        id_ex_in_data1 => id_ex_in_data1,
        id_ex_in_data2 => id_ex_in_data2,
        id_ex_in_in_data => id_ex_in_in_data,
        id_ex_in_immediate => id_ex_in_immediate,

        id_ex_in_pc => if_id_out_pc,
        id_ex_in_pc_1 => if_id_out_pc_1,
        id_ex_in_preserveflags => id_ex_in_preserveflags,
        id_ex_in_branch => id_ex_in_branch,
        id_ex_in_memwritesrc => id_ex_in_memwritesrc,
        id_ex_in_RegDst => id_ex_in_RegDst,
        id_ex_in_usersrc1 => id_ex_in_usersrc1,
        id_ex_in_usersrc2 => id_ex_in_usersrc2,
        id_ex_in_branchselector => id_ex_in_branchselector,
        id_ex_in_memaddsrc => id_ex_in_memaddsrc,
        id_ex_in_wb_select => id_ex_in_wb_select,
        id_ex_in_ALU_Select => id_ex_in_ALU_Select,
        id_ex_in_reserved_flags => id_ex_in_reserved_flags,
        id_ex_in_regWrite => id_ex_in_regWrite,
        id_ex_in_aluSource => id_ex_in_aluSource,
        id_ex_in_HLT => id_ex_in_HLT,
        id_ex_in_MW => id_ex_in_MW,
        id_ex_in_MR => id_ex_in_MR,
        id_ex_in_SP_Plus => id_ex_in_SP_Plus,
        id_ex_in_SP_Negative => id_ex_in_SP_Negative,
        id_ex_in_OUT_enable => id_ex_in_OUT_enable,
        id_ex_in_RET => id_ex_in_RET,
        id_ex_in_INT => id_ex_in_INT,
        id_ex_in_rsrc1 => id_ex_in_rsrc1,
        id_ex_in_rsrc2 => id_ex_in_rsrc2,
        id_ex_in_rdest => id_ex_in_rdest,

        -- Output signals
        id_ex_out_data1 => id_ex_out_data1,
        id_ex_out_data2 => id_ex_out_data2,
        id_ex_out_in_data => id_ex_out_in_data,
        id_ex_out_immediate => id_ex_out_immediate,
        id_ex_out_pc => id_ex_out_pc,
        id_ex_out_pc_1 => id_ex_out_pc_1,
        id_ex_out_preserveflags => id_ex_out_preserveflags,
        id_ex_out_branch => id_ex_out_branch,
        id_ex_out_memwritesrc => id_ex_out_memwritesrc,
        id_ex_out_RegDst => id_ex_out_RegDst,
        id_ex_out_usersrc1 => id_ex_out_usersrc1,
        id_ex_out_usersrc2 => id_ex_out_usersrc2,
        id_ex_out_branchselector => id_ex_out_branchselector,
        id_ex_out_memaddsrc => id_ex_out_memaddsrc,
        id_ex_out_wb_select => id_ex_out_wb_select,
        id_ex_out_ALU_Select => id_ex_out_ALU_Select,
        id_ex_out_reserved_flags => id_ex_out_reserved_flags,
        id_ex_out_regWrite => id_ex_out_regWrite,
        id_ex_out_aluSource => id_ex_out_aluSource,
        id_ex_out_HLT => id_ex_out_HLT,
        id_ex_out_MW => id_ex_out_MW,
        id_ex_out_MR => id_ex_out_MR,
        id_ex_out_SP_Plus => id_ex_out_SP_Plus,
        id_ex_out_SP_Negative => id_ex_out_SP_Negative,
        id_ex_out_OUT_enable => id_ex_out_OUT_enable,
        id_ex_out_RET => id_ex_out_RET,
        id_ex_out_INT => id_ex_out_INT,
        id_ex_out_rsrc1 => id_ex_out_rsrc1,
        id_ex_out_rsrc2 => id_ex_out_rsrc2,
        id_ex_out_rdest => id_ex_out_rdest
    );
    EX_MEM_Register1 : ex_mem_register PORT MAP(
        -- Clock and reset
        clk => clk,
        reset => reset,

        -- Input signals
        ex_mem_in_rsrc2 => ex_mem_in_rsrc2,
        ex_mem_in_alu_result => ex_mem_in_alu_result,
        ex_mem_in_in_data => ex_mem_in_in_data,
        ex_mem_in_pc => ex_mem_in_pc,
        ex_mem_in_pc_1 => ex_mem_in_pc_1,
        ex_mem_in_memwritesrc => ex_mem_in_memwritesrc,
        ex_mem_in_memaddsrc => ex_mem_in_memaddsrc,
        ex_mem_in_wb_select => ex_mem_in_wb_select,
        ex_mem_in_regWrite => ex_mem_in_regWrite,
        ex_mem_in_MW => ex_mem_in_MW,
        ex_mem_in_MR => ex_mem_in_MR,
        ex_mem_in_SP_Plus => ex_mem_in_SP_Plus,
        ex_mem_in_SP_Negative => ex_mem_in_SP_Negative,
        ex_mem_in_OUT_enable => ex_mem_in_OUT_enable,
        ex_mem_in_RET => ex_mem_in_RET,
        ex_mem_in_INT => ex_mem_in_INT,
        ex_mem_in_rdest => ex_mem_in_rdest,

        -- Output signals
        ex_mem_out_rsrc2 => ex_mem_out_rsrc2,
        ex_mem_out_alu_result => ex_mem_out_alu_result,
        ex_mem_out_in_data => ex_mem_out_in_data,
        ex_mem_out_pc => ex_mem_out_pc,
        ex_mem_out_pc_1 => ex_mem_out_pc_1,
        ex_mem_out_memwritesrc => ex_mem_out_memwritesrc,
        ex_mem_out_memaddsrc => ex_mem_out_memaddsrc,
        ex_mem_out_wb_select => ex_mem_out_wb_select,
        ex_mem_out_regWrite => ex_mem_out_regWrite,
        ex_mem_out_MW => ex_mem_out_MW,
        ex_mem_out_MR => ex_mem_out_MR,
        ex_mem_out_SP_Plus => ex_mem_out_SP_Plus,
        ex_mem_out_SP_Negative => ex_mem_out_SP_Negative,
        ex_mem_out_OUT_enable => ex_mem_out_OUT_enable,
        ex_mem_out_RET => ex_mem_out_RET,
        ex_mem_out_INT => ex_mem_out_INT,
        ex_mem_out_rdest => ex_mem_out_rdest
    );

    mem_wb_out_dataout <= mem_wb_out_mem_data WHEN mem_wb_out_wb_select = "01" ELSE
        mem_wb_out_in_data WHEN mem_wb_out_wb_select = "10" ELSE
        mem_wb_out_alu_result;

    MEM_WB_Register1 : mem_wb_register PORT MAP(
        clk => clk,

        -- Input signals
        mem_wb_in_mem_data => mem_wb_in_mem_data,
        mem_wb_in_alu_result => mem_wb_in_alu_result,
        mem_wb_in_in_data => mem_wb_in_in_data,

        mem_wb_in_wb_select => mem_wb_in_wb_select,
        mem_wb_in_regWrite => mem_wb_in_regwrite,
        mem_wb_in_OUT_enable => mem_wb_in_OUT_enable,
        mem_wb_in_rdest => mem_wb_in_regdst,

        -- Output signals
        mem_wb_out_mem_data => mem_wb_out_mem_data,
        mem_wb_out_alu_result => mem_wb_out_alu_result,
        mem_wb_out_in_data => mem_wb_out_in_data,

        mem_wb_out_wb_select => mem_wb_out_wb_select,
        mem_wb_out_regWrite => mem_wb_out_regwrite,
        mem_wb_out_OUT_enable => mem_wb_out_OUT_enable,
        mem_wb_out_rdest => mem_wb_out_regdst
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
        ie_mem_reg_write => ex_mem_out_regWrite, -- IE/MEM RegWrite signal
        ie_mem_to_reg => ex_mem_out_wb_select(0), -- IE/MEM MemtoReg signal
        ie_mem_in_sig => ex_mem_out_wb_select(1), -- IE/MEM input signal

        mem_wb_data_out => mem_wb_out_dataout, -- MEM/WB data output
        ie_mem_alu_out => ex_mem_out_alu_result, -- IE/MEM ALU result
        ie_mem_in_data => ex_mem_out_in_data, -- IE/MEM IN DATA
        ie_mem_mem_data => ex_mem_out_mem_data, -- IE/MEM MEM DATA

        mem_wb_reg_adrs => mem_wb_out_regdst, -- MEM/WB register address
        ie_mem_reg_adrs => ex_mem_out_rdest, -- IE/MEM register address

        id_ie_rsrc1 => id_ex_out_rsrc1, -- ID/IE rsrc1 address
        id_ie_rsrc2 => id_ex_out_rsrc2, -- ID/IE rsrc2 address
        id_ie_usersrc1 => id_ex_out_usersrc1, -- ID/IE uses rsrc1
        id_ie_usersrc2 => id_ex_out_usersrc2, -- ID/IE uses rsrc2

        -- Outputs
        alu_src1 => alu_src1, -- ALU source 1 mux signal
        alu_src2 => alu_src2, -- ALU source 2 mux signal
        mem_forward_data => mem_forward_data, -- Forwarded data from MEM
        wb_forward_data => wb_forward_data -- Forwarded data from WB
    );

    HazardDetection1 : HazardDetection PORT MAP(
        -- CLOCK
        clk => clk,
        
        -- Inputs
        id_ie_mem_read => id_ex_out_MR, -- IE/MEM memRead  signal
        id_ie_reg_write => id_ex_out_regWrite, -- IE/MEM RegWrite signal

        id_ie_reg_adrs => id_ex_out_rsrc2, -- ID/IE register address

        if_id_rsrc1 => if_id_out_rsrc1, -- ID/IE rsrc1 address
        if_id_rsrc2 => if_id_out_rsrc2, -- ID/IE rsrc2 address
        if_id_usersrc1 => id_ex_in_usersrc1, -- ID/IE uses rsrc1
        if_id_usersrc2 => id_ex_in_usersrc2, -- ID/IE uses rsrc2

        -- Outputs
        pc_stall => pc_stall -- PC stall

    );
    INTERRUPT_TABLE1 : interrupt_table PORT MAP(
        index => alu_result(3 DOWNTO 0),
        data_out => acu_in_interrupt_address
    );
    ACU1 : ACU PORT MAP(
        decodeexecute_pc => id_ex_out_pc,
        executememory_pc => ex_mem_out_pc,
        interrupt_address => acu_in_interrupt_address,
        alu_src => alu_result,
        mem_out => memory_data_out,
        decodeexecute_branch_selector => id_ex_out_branchselector,
        execute_flag_register => flag_register,
        decodeexecute_branch_signal => id_ex_out_branch,
        reset => reset,
        sp_overflow => sp_overflow,
        memadd_overflow => memory_address_overflow,
        decodeexecute_interrupt_signal => id_ex_out_INT,
        return_signal => ex_mem_in_RET,
        out_address => acu_out_address,
        old_pc => acu_old_pc,
        out_flag_register => acu_out_flag_register,
        exception_flag => acu_exception_flag,
        address_change_flag => acu_address_change_flag,
        stage_detector => acu_stage_detector,
        flag_enable => acu_flag_enable
    );
    out_port <= out_port_internal;
    PROCESS (clk) BEGIN
        IF reset = '1' THEN
            pc <= (OTHERS => '0');
            reserved_flags <= (OTHERS => '0');
            instruction_reg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF (pc_stall = '0') THEN
                pc <= STD_LOGIC_VECTOR(unsigned(pc) + 1);
            END IF;
            IF instruction_reg(0) = '1' THEN
            instruction_reg <= (OTHERS => '0');
            ELSE
            instruction_reg <= instruction;
            END IF;
            IF mem_wb_out_OUT_enable = '1' THEN
            out_port_internal <= mem_wb_out_dataout;
            END IF;
            IF acu_exception_flag = '1' THEN
                exception_pc <= acu_old_pc;
            END IF;
            IF acu_flag_enable = '1' THEN
                reserved_flags <= acu_out_flag_register;
            END IF;
        ELSIF falling_edge(clk) THEN
            sp <= sp_new;
        END IF;
    END PROCESS;
END behavior;