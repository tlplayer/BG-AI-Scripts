# Black Pits Arena Loop for EET

Scaffold WeiDU mod for exposing the BGEE Black Pits loop inside an EET-style game.

## What it does

- Adds a Smoky Brass Lamp to a Friendly Arm Inn container; using it in the inn sends the party to `OH9360`.
- Adds a Black Pits Baeloth reply to manage the arena loop.
- Adds a fight picker for fights 1-15 using the shipped Black Pits globals.
- Adds shop menus for the existing Black Pits tiered stores.
- Extends `BPHUB.BCS` with a tiny tier synchronizer based on `LAST_BATTLE`.

## Fight mapping

| Menu fight | Black Pits global | Completion gate |
| --- | --- | --- |
| 1 | `T0_B1` | always |
| 2 | `T0_B2` | `LAST_BATTLE > 0` |
| 3 | `T1_B1` | `LAST_BATTLE > 1` |
| 4 | `T1_B2` | `LAST_BATTLE > 100` |
| 5 | `T1_B3` | `LAST_BATTLE > 101` |
| 6 | `T1_B4` | `LAST_BATTLE > 102` |
| 7 | `T1_B5` | `LAST_BATTLE > 103` |
| 8 | `T2_B1` | `LAST_BATTLE > 104` |
| 9 | `T2_B2` | `LAST_BATTLE > 200` |
| 10 | `T2_B3` | `LAST_BATTLE > 201` |
| 11 | `T2_B4` | `LAST_BATTLE > 202` |
| 12 | `T2_B5` | `LAST_BATTLE > 203` |
| 13 | `T3_B1` | `LAST_BATTLE > 204` |
| 14 | `T3_B2` | `LAST_BATTLE > 300` |
| 15 | `T3_B3` | `LAST_BATTLE > 301` |

Each fight option sets `BLACK_PITS`, clears `BATTLE_COMPLETE`, sets the selected battle flag, sets `START_BATTLE` to `1`, and starts `CUTBP02`.

## Shops

Tier 1 is always available. Tier 2 appears after `LAST_BATTLE > 104`. Tier 3 appears after `LAST_BATTLE > 204`.

The menus open these existing stores:

- `BPBREN01/02/03`
- `BPCONC01/02/03`
- `BPDEVL01/02/03`
- `BPELAN01/02/03`
- `BPGORC01/02/03`
- `BPMAGD01/02/03`
- `BPTHAR01/02/03`
- `BPXITH01/02/03`
- `BPDING01`

## Notes

This is scaffolding, not a tested release. It assumes EET exposes the Black Pits hub as `OH9360` and that the shipped Black Pits scripts still handle victory, reward, and transition logic after `CUTBP02` begins. Arena entry intentionally uses the same simple transition form seen in Baeloth's original dialogue: `LeaveAreaLUA("OH9360","",[742.520],S)`.

Uninstall should be clean because this only appends dialogue and extends a script through WeiDU.
