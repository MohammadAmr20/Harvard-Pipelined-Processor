instructions_map = {
    # 0 operand
    'NOP': {'opcode': "00000", 'number_of_operands': 0, 'is_immediate': 0, 'is_ea': 0},
    'HLT': {'opcode': "00001", 'number_of_operands': 0, 'is_immediate': 0, 'is_ea': 0},
    'SETC': {'opcode': "00010", 'number_of_operands': 0, 'is_immediate': 0, 'is_ea': 0},
    'RET': {'opcode': "10110", 'number_of_operands': 0, 'is_immediate': 0, 'is_ea': 0},
    'RTI': {'opcode': "11000", 'number_of_operands': 0, 'is_immediate': 0, 'is_ea': 0},
    'INT': {'opcode': "10111", 'number_of_operands': 0, 'is_immediate': 1, 'is_ea': 0},
    # 1 operand
    'IN': {'opcode': "00110", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'OUT': {'opcode': "00101", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'PUSH': {'opcode': "01100", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'POP': {'opcode': "01101", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'LDD': {'opcode': "01111", 'number_of_operands': 1, 'is_immediate': 1, 'is_ea': 1},
    'LDM': {'opcode': "01110", 'number_of_operands': 1, 'is_immediate': 1, 'is_ea': 0},
    'STD': {'opcode': "10000", 'number_of_operands': 1, 'is_immediate': 1, 'is_ea': 1},
    'JZ': {'opcode': "10001", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'JC': {'opcode': "10011", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'JN': {'opcode': "10010", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'JMP': {'opcode': "10100", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    'CALL': {'opcode': "10101", 'number_of_operands': 1, 'is_immediate': 0, 'is_ea': 0},
    # 2 operand
    'NOT': {'opcode': "00011", 'number_of_operands': 2, 'is_immediate': 0, 'is_ea': 0},
    'INC': {'opcode': "00100", 'number_of_operands': 2, 'is_immediate': 0, 'is_ea': 0},
    'IADD': {'opcode': "01011", 'number_of_operands': 2, 'is_immediate': 1, 'is_ea': 0},
    'MOV': {'opcode': "00111", 'number_of_operands': 2, 'is_immediate': 0, 'is_ea': 0},
    # 3 operand
    'ADD': {'opcode': "01000", 'number_of_operands': 3, 'is_immediate': 0, 'is_ea': 0},
    'SUB': {'opcode': "01001", 'number_of_operands': 3, 'is_immediate': 0, 'is_ea': 0},
    'AND': {'opcode': "01010", 'number_of_operands': 3, 'is_immediate': 0, 'is_ea': 0},
}