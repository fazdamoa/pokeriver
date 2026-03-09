# Pokeriver - Claude Context

See ROADMAP.md for progress, CHANGELOG.md for detailed changes, IDEAS.md for design direction.

## Text System Quick Reference
- Text box is **18 characters wide**. All `text`/`line`/`cont` content must fit.
- `text` = first line, `line` = second line, `cont` = scroll + continue, `para` = clear box + new paragraph
- `done` = end + wait, `prompt` = end + wait (before menus), `text_end` = end without wait
- `#MON` → `POKéMON` (7 chars), `#` → `POKé` (4 chars), `#DEX` → `POKéDEX` (7 chars)
- `<PLAYER>` / `<RIVAL>` → up to 7 chars each
- Text files: `text/<MapName>.asm`. Script logic: `scripts/<MapName>.asm`.

## Item Name Limit
Max display name = 12 chars (`ITEM_NAME_LENGTH - 1`, defined in `constants/text_constants.asm`).

## Current Starter Mapping
| Ball Position | STARTER | Displayed | Actually Given | Rival Gets |
|---|---|---|---|---|
| Middle | STARTER1 | VAPOREON | **DITTO** (bait & switch) | SEEL |
| Right | STARTER2 | SEEL | SEEL | PONYTA |
| Left | STARTER3 | PONYTA | PONYTA | VAPOREON |

- Vaporeon pick: innuendo text (copypasta ref), player actually receives Ditto
- Seel/Ponyta pick: "Wow, nice choice mate. Solid pick."
- Ditto swap is in `scripts/OaksLab.asm` (before `AddPartyMon`). `wPlayerStarter` stays VAPOREON so rival logic works.
- Rival evolution mapping: Seel→Dewgong (Lv 34), Ponyta→Rapidash (Lv 40), Vaporeon stays Vaporeon
- Assembly labels in `scripts/OaksLab.asm` still say Charmander/Squirtle/Bulbasaur — they're just labels, functionality uses STARTER1/2/3 from `constants/pokemon_constants.asm`.

## Item Renames
| Internal Constant | Display Name | Hex |
|---|---|---|
| FULL_RESTORE | EST. GALICIA | $10 |
| MAX_POTION | CAMDEN STOUT | $11 |
| HYPER_POTION | BEAMISH | $12 |
| SUPER_POTION | MURPHYS | $13 |
| POTION | GUINNESS | $14 |
