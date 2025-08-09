import os
import sys
import shutil

GAME_SCRIPT_PATH = "/home/bazzite/.local/share/Steam/steamapps/common/Baldur's Gate Enhanced Edition/scripts/multi0.bs"
BACKUP_PATH = GAME_SCRIPT_PATH + ".bak"

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

        # Always keep the original line
        modified_lines.append(line)

        # Skip comments and empty lines
        if stripped.startswith("//") or not stripped:
            continue

        # Detect THEN block (case-insensitive)
        if stripped.upper().startswith("THEN"):
            in_then_block = True

        # Insert after first RESPONSE line in this THEN block
        elif in_then_block and stripped.upper().startswith("RESPONSE"):
            indent = " " * (len(line) - len(line.lstrip()))  # preserve indentation
            modified_lines.append(f"{indent}DisplayStringHead(Myself,{display_number})")
            display_number += 1
            in_then_block = False  # only once per block

    return "\n".join(modified_lines), display_number


def apply_debug():
    """
    Back up the original script (if needed) and apply debug changes.
    """
    if not os.path.exists(GAME_SCRIPT_PATH):
        print(f"[ERROR] Could not find {GAME_SCRIPT_PATH}")
        sys.exit(1)

    # Backup original if no backup exists
    if not os.path.exists(BACKUP_PATH):
        shutil.copy2(GAME_SCRIPT_PATH, BACKUP_PATH)
        print(f"[INFO] Backup created: {BACKUP_PATH}")

    # Read, modify, write back
    with open(GAME_SCRIPT_PATH, "r", encoding="utf-8") as f:
        script_data = f.read()

    modified_script, _ = add_display_string_head(script_data, 1)

    with open(GAME_SCRIPT_PATH, "w", encoding="utf-8") as f:
        f.write(modified_script)

    print(f"[OK] Debug version applied to {GAME_SCRIPT_PATH}")


def restore_original():
    """
    Restore the script from backup.
    """
    if not os.path.exists(BACKUP_PATH):
        print(f"[ERROR] No backup found at {BACKUP_PATH}")
        sys.exit(1)

    shutil.copy2(BACKUP_PATH, GAME_SCRIPT_PATH)
    print(f"[OK] Restored original script from backup.")


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--restore":
        restore_original()
    else:
        apply_debug()
