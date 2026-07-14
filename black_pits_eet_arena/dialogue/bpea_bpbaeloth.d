// Add the arena loop to Black Pits Baeloth. These states are intentionally
// appended so WeiDU can uninstall them cleanly.
EXTEND_BOTTOM ~BPBAELOT~ 0
  IF ~~ THEN REPLY ~I want to manage the EET arena loop.~ GOTO BPEA_MENU
END

APPEND ~BPBAELOT~

IF ~~ THEN BEGIN BPEA_MENU
  SAY ~Choose, then. Blood, commerce, or the nearest exit from magnificence?~
  IF ~~ THEN REPLY ~Pick an arena fight.~ GOTO BPEA_FIGHTS
  IF ~~ THEN REPLY ~Open the Black Pits shops.~ GOTO BPEA_STORES
  IF ~~ THEN REPLY ~Return me to the Sword Coast.~ DO ~LeaveAreaLUA("AR0700","",[3350.2850],0)~ EXIT
  IF ~~ THEN REPLY ~Never mind.~ EXIT
END

IF ~~ THEN BEGIN BPEA_FIGHTS
  SAY ~I can arrange any sanctioned bout you have earned. Win one, then the next becomes available.~
  IF ~~ THEN REPLY ~Fight 1: Opening bout.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T0_B1","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",0)~ THEN REPLY ~Fight 2: Second opening bout.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T0_B2","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",1)~ THEN REPLY ~Fight 3: Tier 1, bout 1.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",1) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T1_B1","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",100)~ THEN REPLY ~Fight 4: Tier 1, bout 2.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",1) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T1_B2","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",101)~ THEN REPLY ~Fight 5: Tier 1, bout 3.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",1) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T1_B3","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",102)~ THEN REPLY ~Fight 6: Tier 1, bout 4.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",1) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T1_B4","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",103)~ THEN REPLY ~Fight 7: Tier 1, bout 5.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",1) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T1_B5","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",104)~ THEN REPLY ~Fight 8: Tier 2, bout 1.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",2) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T2_B1","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",200)~ THEN REPLY ~Fight 9: Tier 2, bout 2.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",2) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T2_B2","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",201)~ THEN REPLY ~Fight 10: Tier 2, bout 3.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",2) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T2_B3","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",202)~ THEN REPLY ~Fight 11: Tier 2, bout 4.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",2) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T2_B4","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",203)~ THEN REPLY ~Fight 12: Tier 2, bout 5.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",2) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T2_B5","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",204)~ THEN REPLY ~Fight 13: Tier 3, bout 1.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",3) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T3_B1","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",300)~ THEN REPLY ~Fight 14: Tier 3, bout 2.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",3) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T3_B2","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",301)~ THEN REPLY ~Fight 15: Tier 3, bout 3.~ DO ~SetGlobal("BLACK_PITS","GLOBAL",1) SetGlobal("TIER","GLOBAL",3) SetGlobal("BATTLE_COMPLETE","GLOBAL",0) SetGlobal("T3_B3","GLOBAL",1) SetGlobal("START_BATTLE","GLOBAL",1) StartCutScene("CUTBP02")~ EXIT
  IF ~~ THEN REPLY ~Back.~ GOTO BPEA_MENU
END

IF ~~ THEN BEGIN BPEA_STORES
  SAY ~The inventory improves as the arena grows uglier. Pick a supplier.~
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",204)~ THEN REPLY ~Open tier 3 shops.~ GOTO BPEA_STORE_T3
  IF ~GlobalGT("LAST_BATTLE","GLOBAL",104)~ THEN REPLY ~Open tier 2 shops.~ GOTO BPEA_STORE_T2
  IF ~~ THEN REPLY ~Open tier 1 shops.~ GOTO BPEA_STORE_T1
  IF ~~ THEN REPLY ~Back.~ GOTO BPEA_MENU
END

IF ~~ THEN BEGIN BPEA_STORE_T1
  SAY ~Tier 1 stock.~
  IF ~~ THEN REPLY ~Brenda's arms and armor.~ DO ~StartStore("BPBREN01",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~The Concotioneer's supplies.~ DO ~StartStore("BPCONC01",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Devlah's divine wares.~ DO ~StartStore("BPDEVL01",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Elan's ranged gear.~ DO ~StartStore("BPELAN01",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Gorch's general goods.~ DO ~StartStore("BPGORC01",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Magda's arcane stock.~ DO ~StartStore("BPMAGD01",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Thardek's equipment.~ DO ~StartStore("BPTHAR01",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Xithiss's curiosities.~ DO ~StartStore("BPXITH01",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Dinguer's special stock.~ DO ~StartStore("BPDING01",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Back.~ GOTO BPEA_STORES
END

IF ~~ THEN BEGIN BPEA_STORE_T2
  SAY ~Tier 2 stock.~
  IF ~~ THEN REPLY ~Brenda's arms and armor.~ DO ~StartStore("BPBREN02",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~The Concotioneer's supplies.~ DO ~StartStore("BPCONC02",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Devlah's divine wares.~ DO ~StartStore("BPDEVL02",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Elan's ranged gear.~ DO ~StartStore("BPELAN02",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Gorch's general goods.~ DO ~StartStore("BPGORC02",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Magda's arcane stock.~ DO ~StartStore("BPMAGD02",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Thardek's equipment.~ DO ~StartStore("BPTHAR02",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Xithiss's curiosities.~ DO ~StartStore("BPXITH02",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Dinguer's special stock.~ DO ~StartStore("BPDING01",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Back.~ GOTO BPEA_STORES
END

IF ~~ THEN BEGIN BPEA_STORE_T3
  SAY ~Tier 3 stock.~
  IF ~~ THEN REPLY ~Brenda's arms and armor.~ DO ~StartStore("BPBREN03",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~The Concotioneer's supplies.~ DO ~StartStore("BPCONC03",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Devlah's divine wares.~ DO ~StartStore("BPDEVL03",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Elan's ranged gear.~ DO ~StartStore("BPELAN03",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Gorch's general goods.~ DO ~StartStore("BPGORC03",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Magda's arcane stock.~ DO ~StartStore("BPMAGD03",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Thardek's equipment.~ DO ~StartStore("BPTHAR03",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Xithiss's curiosities.~ DO ~StartStore("BPXITH03",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Dinguer's special stock.~ DO ~StartStore("BPDING01",LastTalkedToBy)~ EXIT
  IF ~~ THEN REPLY ~Back.~ GOTO BPEA_STORES
END

END
