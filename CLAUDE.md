# Pokeriver - Pokemon Red Romhack Notes

## Project Overview
This is a Pokemon Red romhack built on the pokered disassembly. The codebase is Z80 Game Boy assembly.

## Text System
- Text files live in `text/` directory (e.g. `text/OaksLab.asm`, `text/PalletTown.asm`, `text/Route1.asm`)
- Script logic lives in `scripts/` directory (e.g. `scripts/OaksLab.asm`, `scripts/PalletTown.asm`)
- Text box is 18 characters wide. Each `line`/`cont` must fit within this.
- `text` = first line of a new text box, `line` = second line, `cont` = scroll and continue, `para` = new paragraph (clears box)
- `#MON` expands to `POKeMON` (7 chars), `#` alone to `POKe` (4 chars), `#DEX` to `POKeDEX` (7 chars)
- `<PLAYER>` and `<RIVAL>` expand to player/rival names (up to 7 chars each)
- `done` = end text and wait, `prompt` = end and wait (used before menus), `text_end` = end without wait

## Item Renames (Stout/Beer Theme)
The potion line has been renamed to Irish/British stouts:
- FULL_RESTORE ($10) -> "EST. GALICIA" (Estrella Galicia, abbreviated to fit 12-char limit)
- MAX_POTION ($11) -> "CAMDEN STOUT"
- HYPER_POTION ($12) -> "BEAMISH"
- SUPER_POTION ($13) -> "MURPHYS"
- POTION ($14) -> "GUINNESS"

Item names are in `data/items/names.asm`. Max display name length is 12 chars (ITEM_NAME_LENGTH - 1 = 12, defined in `constants/text_constants.asm`). The internal constant names (FULL_RESTORE, POTION, etc.) are unchanged - only display names changed.

## Starter Pokemon Changes
Starters changed from Charmander/Squirtle/Bulbasaur to Clefairy/Seel/Doduo:
- STARTER1 = CLEFAIRY (middle ball, was Charmander)
- STARTER2 = SEEL (right ball, was Squirtle)
- STARTER3 = DODUO (left ball, was Bulbasaur)

Defined in `constants/pokemon_constants.asm`. The assembly labels in `scripts/OaksLab.asm` still say "Charmander"/"Squirtle"/"Bulbasaur" but functionally reference the new starters via STARTER1/2/3 constants.

Evolution mapping for rival teams:
- Clefairy -> Clefable (Moon Stone, used from Silph Co. onwards)
- Seel -> Dewgong (level 34, used from Silph Co. onwards)
- Doduo -> Dodrio (level 31, used from Silph Co. onwards)

Rival trainer data updated across all encounters in `data/trainers/parties.asm`:
- Rival1Data: Oak's Lab, Route 22 early, Cerulean City
- Rival2Data: SS Anne, Pokemon Tower, Silph Co., Route 22 late
- Rival3Data: Champion battle
- ProfOakData: Unused but updated for consistency

## Dialogue Changes Completed

### Oak - Tall Grass Scene (`text/PalletTown.asm`)
- Warns about tall grass, then says "We should really cut this down"
- Comments on player never having left Pallet Town
- Asks "How's your mum doing? What's she wearing today?" (subliminal creep vibe)
- "Ahem. Follow me to the lab!"

### Oak - Choose Mon Speech (`text/OaksLab.asm`)
- Replaced "I was a serious trainer / in my old age" with:
  "Some people raise powerful Pokemon cause they're scared. Others choose humanoid female ones...for some reason. You decide!"

### Starter Selection Text (`text/OaksLab.asm`)
- Clefairy: "Interesting... She's quite the handful at night. Heh heh." (innuendo)
- Seel: Simple "So! You want the water Pokemon, SEEL?"
- Doduo: Simple "So! You want the bird Pokemon, DODUO?"

### Lab NPCs (`text/OaksLab.asm`)
- Girl: Oak yelled at her for 20 minutes for using the wrong mug, she thanked him for the opportunity (pathetic sycophant)
- Scientist: Works 90 hours unpaid, Oak threw a flask at him, calls him "What a legend!" (abusive boss worship)

### Rival Dialogue (`text/OaksLab.asm`)
Full 90s bully overhaul:
- First encounter: "Prob out sniffing around your mum's place again"
- Choose phase: "Go ahead and pick, loser... I'll still destroy you"
- After getting starter: "Yours looks like it'd lose to a wet napkin"
- Battle challenge: "What? Scared? Ha! That's so gay. Just like you!"
- Rival loses: "I can't believe I lost to YOU of all people!"
- Rival wins: "You're trash! Absolute garbage!"
- Farewell: "Tell her MR.MIME misses her too! Hahaha! Smell you later"
- Pokedex farewell: "Good luck being lost AND useless! Hahaha!"
- Various other lines updated with insults ("nonce", "loser", "old man")

### Route 1 NPCs (`text/Route1.asm`)
- Youngster 1 (Guinness giver): On the GUINNESS 0 now, drunk drove home in a ZIPCAR last weekend, nearly killed a PIDGEY. Return dialogue about 0.0% tasting like fizzy water.
- Youngster 2 (Ledge kid): Jumps off ledges every single day, it's the only thing to do, sometimes thinks about what's at the bottom (dark humor)

### Other Pallet Town Text (previously changed)
- Fisher NPC: Talks about goth AI girlfriend telling you off for eating pizza
- Girl NPC: Raises Pokemon that can "protect" her (quotes around protect)

## Key File Locations
- Item names: `data/items/names.asm`
- Item constants: `constants/item_constants.asm`
- Item prices: `data/items/prices.asm`
- Pokemon constants: `constants/pokemon_constants.asm`
- Trainer parties: `data/trainers/parties.asm`
- Text constants: `constants/text_constants.asm`
- Map objects: `data/maps/objects/` (e.g. `OaksLab.asm`, `PalletTown.asm`)
- Map scripts: `scripts/` (e.g. `OaksLab.asm`, `Route1.asm`)
- Dialogue text: `text/` (e.g. `OaksLab.asm`, `PalletTown.asm`, `Route1.asm`)
