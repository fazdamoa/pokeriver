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
| Ball Position | STARTER | Pokemon | Evolves To |
|---|---|---|---|
| Middle | STARTER1 | CLEFAIRY | CLEFABLE (Moon Stone) |
| Right | STARTER2 | SEEL | DEWGONG (Lv 34) |
| Left | STARTER3 | DODUO | DODRIO (Lv 31) |

Assembly labels in `scripts/OaksLab.asm` still say Charmander/Squirtle/Bulbasaur — they're just labels, functionality uses STARTER1/2/3 from `constants/pokemon_constants.asm`.

## Item Renames
| Internal Constant | Display Name | Hex |
|---|---|---|
| FULL_RESTORE | EST. GALICIA | $10 |
| MAX_POTION | CAMDEN STOUT | $11 |
| HYPER_POTION | BEAMISH | $12 |
| SUPER_POTION | MURPHYS | $13 |
| POTION | GUINNESS | $14 |
