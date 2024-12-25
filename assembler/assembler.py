import sys
from instructions import instructions_map


def read_instruction_file():
        if len(sys.argv) < 2:
            print(f"Error : please provide your program file")
            sys.exit(0)
        instruction_path = sys.argv[1]
        with open(instruction_path, "r") as instruction_file:
            instructions = instruction_file.read().splitlines()
            if len(instructions) == 0:
                print(f"Warning : empty file")
                exit(0)

            return instructions

def encode_registers_numbers(register_name: str):
    if len(register_name) > 2:
        print(
            f"Error : this is not a register reference expected R<number> format\nline of instruction --> {line_number} : {current_instruction}")
        exit(0)
    if register_name[0] != 'R':
        print(
            f"Error : invalid register expected R<number> format\nline of instruction --> {line_number} : {current_instruction}")
        exit(0)
    if 7 < int(register_name[1]) or 0 > int(register_name[1]):
        print(
            f"Error : invalid register range expected  from 0 to 7\nline of instruction --> {line_number} : {current_instruction}")
        exit(0)
    return format(int(register_name[1]), '03b')


def update_opcode_with_registers(instruction: str, register_array: []):
    for register in register_array:
        register_number = encode_registers_numbers(register)
        instruction = instruction + register_number
    return instruction


def encode_assembly_line(instruction: str):
    tokenize_instruction = instruction.split()
    if tokenize_instruction[0] not in instructions_map:
        print(f"sorry we don't support that type of instruction yet\nline of instruction --> {line_number} : {current_instruction}")
        exit(0)

    instruction_coded = instructions_map.get(tokenize_instruction[0])

    if len(tokenize_instruction)-1 != instruction_coded["number_of_operands"]+instruction_coded["is_immediate"]:
        print(f'Error : number of parameters does not match expected {instruction_coded["number_of_operands"]+instruction_coded["is_immediate"]}\nline of instruction --> {line_number} : {current_instruction}')
        exit(0)

    instruction_opcode = instruction_coded["opcode"]

    register_array = tokenize_instruction[1:1 + instruction_coded["number_of_operands"]]
    instruction_opcode_with_regs = update_opcode_with_registers(instruction_opcode, register_array).ljust(16, '0')
    if not instruction_coded["is_immediate"]:
        return instruction_opcode_with_regs
    instruction_opcode_immediate = immediate_to_binary(instruction_opcode_with_regs, tokenize_instruction[-1], (
        instruction_coded["is_immediate"] and (instruction_coded["is_ea"] == 0)), instruction_coded["is_ea"])
    return instruction_opcode_immediate

def get_between_braces(string):
    start = string.find('(')
    end = string.find(')')
    if start != -1 and end != -1:
        return string[start+1:end].strip()
    return ""

def immediate_to_binary(instruction: str, immediate_value: str, is_immediate: int, is_ea: int):
    immediate_int = int(immediate_value.split('(')[0]) # case1: 9(r1) | case2: 9
    instruction = instruction[:15] + '1'

    if immediate_int < 0:
        print(f"Error : Negative numbers are not allowed -> instruction --> {line_number}: {current_instruction}")
        exit(0)
    if is_immediate and not (0 <= immediate_int <= 0xFFFF):
        print(f"Error : immediate exceeds 65535 limit -> instruction --> {line_number}: {current_instruction}")
        exit(0)
    if is_ea:
        if not (0 <= immediate_int <= 0xFFFF):
            print(f"Error : invalid address -> instruction --> {line_number}: {current_instruction}")
            exit(0)
        instruction = instruction[:8] +  encode_registers_numbers(get_between_braces(immediate_value))  + instruction[11:]
    return f'{instruction}\n{format(immediate_int, "016b")}'


def main():
    global line_number, current_instruction
    instruction_lines = read_instruction_file()
    output_filename = sys.argv[2] if len(sys.argv) > 2 else "binary.txt"

    processed_lines_string = ""

    for i, instruction_line in enumerate(instruction_lines):
        line_number = i
        current_instruction = instruction_line
        if len(instruction_line) == 0: 
            continue
        processed_line = encode_assembly_line(instruction_line.replace(',', ' ').upper())
        processed_lines_string += f"{processed_line}\n"

    with open(output_filename, "w") as output_file:
        output_file.write(processed_lines_string)


if __name__ == "__main__":
    main()