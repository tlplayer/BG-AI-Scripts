import json

def extract_spell_type(spell_id):
    """
    Extracts the spell type from the spell_id.
    Assumes the spell_id starts with a prefix like 'CLERIC_' or 'WIZARD_'.
    """
    if spell_id.startswith("CLERIC_"):
        return "CLERIC"
    elif spell_id.startswith("WIZARD_"):
        return "WIZARD"
    elif spell_id.startswith("ROGUE_"):
        return "ROGUE"
    elif spell_id.startswith("PALADIN_"):
        return "PALADIN"
    elif spell_id.startswith("DRUID_"):
        return "DRUID"
    elif spell_id.startswith("BARD_"):
        return "BARD"
    else:
        return "UNKNOWN"  # Default to UNKNOWN if no known prefix is found

def generate_code_blocks(spells):
    template = """
IF
    ActuallyInCombat()
    ActionListEmpty()
    See(NearestEnemyOf(Myself))
    HaveSpell({spell_id})  // {spell_id} ({spell_name})
    Range(NearestEnemyOf(Myself),30)
    !GlobalTimerNotExpired("{spell_type}_CAST","LOCALS")

    THEN
        RESPONSE #100
        Spell(NearestEnemyOf(Myself),{spell_id})  // Cast {spell_name}
        SetGlobalTimer("{spell_type}_CAST","LOCALS",ONE_ROUND)
END
"""
    
    code_blocks = ""
    for spell_id, spell_data in spells.items():
        spell_name = spell_data["name"]
        spell_type = extract_spell_type(spell_id)  # Extract spell type from spell ID
        code_blocks += template.format(spell_name=spell_name, spell_id=spell_id, spell_type=spell_type)
    
    return code_blocks.strip()

def save_code_to_file(code, output_file):
    with open(output_file, 'w') as file:
        file.write(code)

# Load the spells from the JSON file
with open('enhanced_spells.json', 'r') as file:
    spells_data = json.load(file)

# Generate the code blocks for all spells
code_blocks = generate_code_blocks(spells_data)

# Save the code blocks to a file
output_file = 'generated_spell_code.txt'
save_code_to_file(code_blocks, output_file)

print(f"Code blocks have been saved to {output_file}")
