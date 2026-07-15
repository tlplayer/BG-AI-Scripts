// Friendly Arm Inn transition point. Bentley is static and always reachable,
// which keeps the Black Pits hook out of Baeloth's encounter/recruitment logic.
EXTEND_BOTTOM ~BENTLY~ 0
  IF ~~ THEN REPLY ~I heard there are fighting pits beneath the Coast. Can you get us there?~ GOTO BPEA_BENTLY_PITS
END

APPEND ~BENTLY~

IF ~~ THEN BEGIN BPEA_BENTLY_PITS
  SAY ~Aye, there are doors in the Coast that open for the right coin and the wrong curiosity. If you want the pits, I can point you to them.~
  IF ~~ THEN REPLY ~Send us to the Black Pits.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("BPBAELOT_DIALOG","GLOBAL",11) SetGlobal("LAST_BATTLE","GLOBAL",2) SetGlobal("TIER","GLOBAL",1) SetGlobal("BATTLE_COMPLETE","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",0) SetGlobal("T0_B1","GLOBAL",2) SetGlobal("T0_B2","GLOBAL",2) ActionOverride(Player1,LeaveAreaLUA("OH9360","LEAVEA",[742.520],6)) ActionOverride(Player2,LeaveAreaLUA("OH9360","LEAVEA",[760.520],6)) ActionOverride(Player3,LeaveAreaLUA("OH9360","LEAVEA",[724.520],6)) ActionOverride(Player4,LeaveAreaLUA("OH9360","LEAVEA",[742.548],6)) ActionOverride(Player5,LeaveAreaLUA("OH9360","LEAVEA",[760.548],6)) ActionOverride(Player6,LeaveAreaLUA("OH9360","LEAVEA",[724.548],6))~ EXIT
  IF ~~ THEN REPLY ~Not now.~ EXIT
END

END
