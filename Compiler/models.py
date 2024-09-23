# models.py

class Condition:
    def __init__(self, condition_id, condition_type):
        self.condition_id = condition_id
        self.condition_type = condition_type

    def to_dict(self):
        return {"type": self.condition_type, "ID": self.condition_id}

class Spell:
    def __init__(self, name, spell_id):
        self.name = name
        self.spell_id = spell_id
        self.conditions = []

    def to_dict(self):
        return {
            "name": self.name,
            "type": "SPELLID",
            "id": self.spell_id,
            "conditions": [condition.to_dict() for condition in self.conditions]
        }
