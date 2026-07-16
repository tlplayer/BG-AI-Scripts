# Siege Items in Sundries

A WeiDU mod that adds a curated catalog of Siege of Dragonspear magic items to
Sorcerous Sundries.

The target store is `STO0703.STO`, used by Sorcerous Sundries in BGEE and kept
under the same store resource name by Enhanced Edition Trilogy.

This is intentionally not a full item dump. The catalog is based on the
[Siege of Dragonspear magic-item guide](https://forums.beamdog.com/discussion/53498/a-guide-to-new-magic-items-in-siege-of-dragonspear-spoilers), checked against
the local item resources. It includes named equipment (especially the formerly
missing armor, robes, cloaks, hoods/caps/circlets, shields, and accessories),
signature weapons, unusual ammunition, and a few useful oddities.

The annotated, canonical resource list is in `lib/sundries_items.tpa`. It
deliberately omits plot and crafting objects, companion/class-only items,
cursed items, plain enchanted weapon copies, and generic ammunition. Thus a
low-value item is present only where its unusual effect makes it a real SoD
item rather than filler. The console helper lists are generated from that same
list for store refreshes; `add_bd_weapons_to_sundries.txt` retains its legacy
name but now contains the full curated catalog.

## Install

Copy the `siege_items_in_sundries` folder into the game directory, put a WeiDU
setup executable beside it as `setup-siege_items_in_sundries`, and run it.

On Steam/GOG BGEE with Siege of Dragonspear, install DLC Merger first. On EET,
install this after EET has imported BGEE/SoD resources.

## Run the console helper

The WeiDU installation above is the recommended method: it restores the store
before applying the curated list, so it can remove stock added by an older
version of this mod. Reinstall the component after updating the mod; no helper
is needed for that workflow.

The helper is only for adding the current catalog to an already-running game
with the EEex console. Close Sorcerous Sundries, open the EEex console, then
run:

```
C:Exec("scripts/BG-AI-Scripts/siege_items_in_sundries/refresh_sundries_store.txt")
```

Reopen Sorcerous Sundries afterwards. The helper only adds stock; running it
more than once can create duplicate entries, and it cannot remove items from
an earlier catalog. `add_bd_weapons_to_sundries.txt` is an equivalent helper
kept for compatibility with its old filename.

## Notes

- Existing Sorcerous Sundries stock is preserved.
- Missing item resources are skipped, so the same script can run on BGEE or EET.
- Unique items are added with finite stock. Ammunition is added in small stacks.
