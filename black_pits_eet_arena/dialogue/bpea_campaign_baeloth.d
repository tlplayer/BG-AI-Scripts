// Optional entry point from campaign Baeloth. The real arena controls live on
// BPBAELOT after the party arrives in the Black Pits hub.
EXTEND_BOTTOM ~BAELOTH~ 0
  IF ~~ THEN REPLY ~I want to see your Black Pits arena.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("BPEA_ARENA_UNLOCKED","GLOBAL",1) LeaveAreaLUA("OH9360","",[742.520],0)~ EXIT
END
