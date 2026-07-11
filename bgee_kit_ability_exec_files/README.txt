BGEE/BG2EE/EET console exec files

Copy the .txt files beside chitin.key / the game executable.

Open the console, select or hover the intended character according to your console setup, and run:

C:Exec("add_priest_kit_abilities.txt")
C:Exec("add_thief_kit_abilities.txt")
C:Exec("add_druid_kit_abilities.txt")

Each AddSpecialAbility call grants one use. Running a file again adds another use.

These files grant activated abilities only. They do not apply passive kit effects,
item restrictions, thief-skill modifiers, spell restrictions, bard-song changes,
backstab changes, or CLAB progression.
