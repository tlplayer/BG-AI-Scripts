BGEE/BG2EE/EET console exec files

Copy the .txt files beside chitin.key / the game executable.

Open the console, select or hover the intended character according to your console setup, and run:

C:Exec("add_priest_kit_abilities.txt")
C:Exec("add_thief_kit_abilities.txt")
C:Exec("add_druid_kit_abilities.txt")
C:Exec("add_avenger_kit_abilities.txt")
C:Exec("add_shapeshifter_kit_abilities.txt")
C:Exec("add_totemic_druid_kit_abilities.txt")
C:Exec("add_paladin_kit_abilities.txt")

Each AddSpecialAbility call grants one use. Running a file again adds another use.

These files grant activated abilities only. Run only the file for the character's
actual druid kit. They do not apply passive kit effects, item restrictions,
thief-skill modifiers, spell restrictions, bard-song changes, backstab changes,
or CLAB progression. In particular, they do not grant Use Any Item: that is a
thief high-level ability and does not make a druid a Shapeshifter.
