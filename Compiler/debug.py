import os

def add_display_string_head(ai_script, display_number):
    """
    Inserts the DisplayStringHead call into each code block in the AI script.
    """
    lines = ai_script.splitlines()
    modified_lines = []
    
    in_then_block = False
    
    for line in lines:
        modified_lines.append(line)

        # Detect start of THEN block
        if 'THEN' in line:
            in_then_block = True

        # Insert DisplayStringHead after SetGlobalTimer in the THEN block
        if in_then_block and 'RESPONSE' in line:
            modified_lines.append(f"        DisplayStringHead(Myself,{display_number})")
            display_number += 1  # Increment the display number for the next block
        
        # Detect end of a block (END statement)
        if 'END' in line:
            in_then_block = False

    return '\n'.join(modified_lines), display_number

def process_ai_baf_file(file_path):
    """
    Reads the AI.baf file, processes each block to add DisplayStringHead calls, and writes the modified file.
    """
    # Read the existing AI.baf file
    with open(file_path, 'r') as file:
        ai_script = file.read()

    # Start the display number counter
    display_number = 1

    # Process the AI script and insert DisplayStringHead into each block
    modified_script, _ = add_display_string_head(ai_script, display_number)

    # Save the modified script to a new file
    modified_file_path = file_path.replace('.baf', '_debug.baf')
    with open(modified_file_path, 'w') as file:
        file.write(modified_script)

    print(f"Modified AI script has been saved to {modified_file_path}")

if __name__ == "__main__":
    # Path to your AI.baf file
    file_path = r'C:\Users\timot\Documents\customScripts\AI\AI.baf'
    process_ai_baf_file(file_path)
