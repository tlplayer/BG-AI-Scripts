import os

def add_display_string_head(ai_script, start_number):
    """
    Inserts DisplayStringHead(Myself, N) into each THEN/RESPONSE block.
    """
    lines = ai_script.splitlines()
    modified_lines = []

    in_then_block = False
    display_number = start_number

    for line in lines:
        stripped = line.strip()
        modified_lines.append(line)

        # Detect start of THEN block (not in comments)
        if stripped.startswith("THEN"):
            in_then_block = True

        # Insert DisplayStringHead after the first RESPONSE line in the THEN block
        if in_then_block and stripped.startswith("RESPONSE"):
            modified_lines.append(f"    DisplayStringHead(Myself,{display_number})")
            display_number += 1
            in_then_block = False  # prevent multiple insertions for same block

    return "\n".join(modified_lines), display_number


def process_ai_baf_file(file_path):
    """
    Reads the AI.baf file, processes each block to add DisplayStringHead calls,
    and writes the modified file.
    """
    with open(file_path, "r", encoding="utf-8") as file:
        ai_script = file.read()

    modified_script, _ = add_display_string_head(ai_script, 1)

    modified_file_path = file_path.replace(".baf", "_debug.baf")
    with open(modified_file_path, "w", encoding="utf-8") as file:
        file.write(modified_script)

    print(f"Modified AI script has been saved to {modified_file_path}")


if __name__ == "__main__":
    # Path to your AI.baf file (example: same directory as script)
    file_path = os.path.abspath(sys.argv[1])
    process_ai_baf_file(file_path)
