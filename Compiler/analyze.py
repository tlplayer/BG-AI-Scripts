import json
import csv

# models.py

class Condition:
    def __init__(self, condition_id, condition_type):
        self.condition_id = condition_id
        self.condition_type = condition_type

    def to_dict(self):
        return {"type": self.condition_type, "ID": self.condition_id}

class Spell:
    def __init__(self, name, spell_id, duration='', spell_type='', description=''):
        self.name = name
        self.spell_id = spell_id
        self.duration = duration
        self.spell_type = spell_type
        self.description = description
        self.conditions = []

    def to_dict(self):
        return {
            "name": self.name,
            "type": "SPELLID",
            "id": self.spell_id,
            "duration": self.duration,
            "spell_type": self.spell_type,
            "description": self.description,
            "conditions": [condition.to_dict() for condition in self.conditions]
        }

def parse_spell_ids(file_path):
    spells = {}
    with open(file_path, 'r') as file:
        reader = csv.DictReader(file, delimiter='\t')  # Adjust delimiter as needed
        for row in reader:
            spell_id = row['ID']
            spell_name = row['Name']
            duration = row.get('Duration', '')
            spell_type = row.get('Type', '')
            description = row.get('Description', '')
            spells[spell_id] = Spell(
                name=spell_name,
                spell_id=spell_id,
                duration=duration,
                spell_type=spell_type,
                description=description
            )
    return spells

def parse_existing_spells(file_path):
    with open(file_path, 'r') as file:
        return json.load(file)

def extract_core_name(spell_id):
    # Define prefixes to remove
    prefixes = ['CLERIC_', 'WIZARD_', 'ROGUE_', 'PALADIN_', 'DRUID_', 'BARD_']
    
    for prefix in prefixes:
        if spell_id.startswith(prefix):
            return spell_id[len(prefix):].strip()
    return spell_id.strip()

def find_closest_conditions(core_name, conditions):
    matches = []
    for condition in conditions:
        # Compare core names directly
        if core_name in condition.condition_id:
            matches.append(condition)
    return matches

def main():
    # File paths
    existing_spells_file = r'spells_with_conditions.json'
    enhanced_spells_file = r'C:/Users/timot/Documents/customScripts/IDS/enhanced_spell_data.txt'
    
    # Load existing spells with conditions
    existing_spells = parse_existing_spells(existing_spells_file)
    
    # Parse enhanced spell data
    enhanced_spells = parse_spell_ids(enhanced_spells_file)
    
    # Update existing spells with enhanced data
    for spell_id, spell_data in existing_spells.items():
        if spell_id in enhanced_spells:
            enhanced_spell = enhanced_spells[spell_id]
            existing_spells[spell_id]['duration'] = enhanced_spell.duration
            existing_spells[spell_id]['spell_type'] = enhanced_spell.spell_type
            existing_spells[spell_id]['description'] = enhanced_spell.description
    
    # Save updated spells to a new file
    with open('updated_spells_with_conditions.json', 'w') as file:
        json.dump(existing_spells, file, indent=4)
    
    print("Updated data has been saved to updated_spells_with_conditions.json")

if __name__ == "__main__":
    main()
