import json

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

def parse_existing_spells(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)
        spells = {}
        for spell_id, spell_data in data.items():
            spell = Spell(
                name=spell_data["name"],
                spell_id=spell_id,
                duration=spell_data.get("duration", ""),  # Add empty placeholder
                spell_type=spell_data.get("spell_type", ""),  # Add empty placeholder
                description=spell_data.get("description", "")  # Add empty placeholder
            )
            # Add conditions
            for condition in spell_data["conditions"]:
                spell.conditions.append(Condition(condition["ID"], condition["type"]))
            spells[spell_id] = spell
        return spells

def save_enhanced_spells(spells, output_file):
    result = {spell_id: spell.to_dict() for spell_id, spell in spells.items()}
    
    with open(output_file, 'w') as file:
        json.dump(result, file, indent=4)

def main():
    # Path to the existing spells_with_conditions.json file
    existing_spells_file = 'spells_with_conditions.json'
    
    # Load existing spells
    spells = parse_existing_spells(existing_spells_file)
    
    # Modify/add placeholder fields for duration, spell type, and description
    for spell in spells.values():
        # You can update the values directly here or leave them for manual filling later
        spell.duration = spell.duration or "To be filled"
        spell.spell_type = spell.spell_type or "To be filled"
        spell.description = spell.description or "To be filled"
    
    # Save the enhanced spells to a new file
    save_enhanced_spells(spells, 'enhanced_spells.json')

    print("Enhanced data saved to enhanced_spells.json")

if __name__ == "__main__":
    main()
