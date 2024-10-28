# Function to interpret BliGk code and produce output
def interpret_blik_code(blik_code):
    # Define initial memory state
    tape = [0] * 30000  # Memory tape similar to Brainfuck
    pointer = 0         # Pointer to track memory cell position
    output = []         # Store the output characters
    loop_stack = []     # Track positions for loops
    
    # Split BliGk code by spaces to process each command separately
    commands = blik_code.split()
    
    # Interpreter for BliGk commands
    i = 0
    while i < len(commands):
        command = commands[i].strip()  # Trim any accidental whitespace
        
        # Debugging print statements
        print(f"Executing command: {command} at position {i}")
        print(f"Pointer: {pointer}, Cell Value: {tape[pointer]}")
        
        # Interpret each BliGk command directly
        if command == "Ϟ":
            tape[pointer] = (tape[pointer] + 1) % 256  # Increment
            print(f"Incremented Cell[{pointer}] to {tape[pointer]}")
        elif command == "ϞϞ":
            tape[pointer] = (tape[pointer] - 1) % 256  # Decrement
            print(f"Decremented Cell[{pointer}] to {tape[pointer]}")
        elif command == "◊":
            pointer = (pointer - 1) % len(tape)        # Move pointer left
            print(f"Moved pointer left to {pointer}")
        elif command == "◊◊":
            pointer = (pointer + 1) % len(tape)        # Move pointer right
            print(f"Moved pointer right to {pointer}")
        elif command == "⧈":
            # Start a loop: if current cell is 0, skip to matching '⧈⧈'
            if tape[pointer] == 0:
                open_loops = 1
                while open_loops:
                    i += 1
                    if i >= len(commands):
                        raise SyntaxError("Unmatched loop start '[' in BliGk code.")
                    if commands[i].strip() == "⧈":
                        open_loops += 1
                    elif commands[i].strip() == "⧈⧈":
                        open_loops -= 1
                print(f"Skipped loop starting at position {i} due to zero value at pointer {pointer}")
            else:
                loop_stack.append(i)
                print(f"Entering loop at position {i}, pointer value: {tape[pointer]}")
        elif command == "⧈⧈":
            # End a loop: if current cell is not 0, jump back to loop start
            if tape[pointer] != 0:
                if not loop_stack:
                    raise SyntaxError("Unmatched loop end ']' in BliGk code.")
                i = loop_stack[-1]  # Jump back to the start of the loop
                print(f"Looping back to position {i} as pointer value is non-zero: {tape[pointer]}")
            else:
                loop_stack.pop()
                print(f"Exiting loop at position {i} as pointer value is zero: {tape[pointer]}")
        elif command == "‽":
            # Output the character at the current memory cell
            output.append(chr(tape[pointer]))
            print(f"Output character: {chr(tape[pointer])}")
        else:
            # Raise an error for any unrecognized command
            raise ValueError(f"Unrecognized BliGk command: '{command}'")
        
        i += 1  # Move to the next command
    
    # Return the final output as a single string
    return ''.join(output)

# New BliGk code with spaces as separators for "Hello p"
blik_code = "Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ ⧈ ◊◊ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ ◊◊ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ ◊◊ Ϟ Ϟ Ϟ ◊◊ Ϟ ◊ ◊ ◊ ◊ ϞϞ ⧈⧈ ◊◊ Ϟ Ϟ ‽ ◊◊ Ϟ ‽ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ Ϟ ‽ ‽ Ϟ Ϟ Ϟ ‽ Ϟ ‽"

# Run the BliGk interpreter and print the output
output = interpret_blik_code(blik_code)
print("Output:", output)
