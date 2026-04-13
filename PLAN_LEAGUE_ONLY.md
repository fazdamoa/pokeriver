# Plan: League-Only Hack

## Concept

Strip the entire Pokemon world. When a new game starts, the player goes through a
"Choose Your Team" screen (6 picks from the OU/UU competitive tier), then spawns in the
Indigo Plateau Pokemon Center with their full team at level 50 with optimised movesets.
Their only goal: beat the Elite 4 and the Champion, reach the Hall of Fame, win.

The rest of the world map, towns, routes, gyms — none of it is deleted, it just becomes
unreachable because the player never starts there.

---

## Implementation Status

| Phase | Status |
|---|---|
| 1. Change starting map | ✅ DONE — `data/maps/special_warps.asm` → INDIGO_PLATEAU_LOBBY x=8,y=9 |
| 2. Replace Oak intro flow | ✅ DONE — `engine/movie/oak_speech/oak_speech.asm` — Indigo music, name pick, team picker, give team |
| 3. Team picker UI | ✅ DONE — `engine/movie/team_picker.asm` — 49-mon scrollable list |
| 4. Level 50 + moveset assignment | ✅ DONE — `engine/pokemon/give_team.asm` — GiveChosenTeam + WriteOptimizedMoveset |
| 5. Optimised moveset table | ⚠️ PENDING — `data/pokemon/optimized_moves.asm` exists but **needs Smogon-scraped competitive sets** |
| 6. Wire into main.asm | ⚠️ PENDING — add 3 INCLUDE lines to bank1 section |
| 7. WRAM comment | ⚠️ MINOR — update wTeamPickerCurrentIndex comment (still says "146-item", should be "49-item") |
| 8. Elite 4 teams + names + dialogue | ⏳ NOT STARTED |
| 9. Champion customisation | ⏳ NOT STARTED |
| 10. Testing + bug fixes | ⏳ NOT STARTED |

---

## Pokemon Available for Selection

**Narrowed to OU/UU competitive tier only: 49 Pokemon**

Source: https://www.smogon.com/dex/rb/formats/ou/ and https://www.smogon.com/dex/rb/formats/uu/

(Includes all Pokemon listed as OU, UU, or "Non-[tier] Pokemon with Strategies" on those pages.
All legendaries excluded regardless of tier: Articuno, Zapdos, Moltres, Mewtwo, Mew.)

| # | Pokemon | Tier | Internal ID |
|---|---|---|---|
| 3 | Venusaur | PU/NU | $9A |
| 6 | Charizard | NU | $B4 |
| 20 | Raticate | NU | $A6 |
| 24 | Arbok | ZU | $2D |
| 26 | Raichu | UU | $55 |
| 28 | Sandslash | ZU | $61 |
| 34 | Nidoking | PU | $07 |
| 36 | Clefable | UU | $8E |
| 38 | Ninetales | UU | $53 |
| 49 | Venomoth | NU | $77 |
| 51 | Dugtrio | UU | $76 |
| 53 | Persian | UU | $90 |
| 62 | Poliwrath | NU | $6F |
| 64 | Kadabra | NU | $26 |
| 65 | Alakazam | OU | $95 |
| 68 | Machamp | ZU | $7E |
| 71 | Victreebel | NU | $BE |
| 73 | Tentacruel | NU | $9B |
| 76 | Golem | NU | $31 |
| 78 | Rapidash | UU | $A4 |
| 80 | Slowbro | UU | $08 |
| 83 | Dodrio | UU | $74 |
| 89 | Cloyster | OU | $8B |
| 91 | Haunter | UU | $93 |
| 92 | Gengar | OU | $0E |
| 95 | Hypno | UU | $81 |
| 97 | Kingler | ZU | $8A |
| 99 | Electrode | NU | $8D |
| 101 | Exeggutor | OU | $0A |
| 106 | Lickitung | ZU | $0B |
| 110 | Rhydon | OU | $01 |
| 111 | Chansey | OU | $28 |
| 112 | Tangela | NU | $1E |
| 113 | Kangaskhan | UU | $02 |
| 119 | Starmie | OU | $98 |
| 122 | Jynx | OU | $48 |
| 123 | Electabuzz | UU | $35 |
| 125 | Pinsir | ZU | $1D |
| 126 | Tauros | OU | $3C |
| 128 | Gyarados | UU | $16 |
| 129 | Lapras | UU | $13 |
| 133 | Jolteon | OU | $68 |
| 134 | Flareon | ZU | $67 |
| 135 | Porygon | PU | $AA |
| 137 | Omastar | NU | $63 |
| 139 | Kabutops | NU | $5B |
| 141 | Snorlax | OU | $84 |
| 146 | Dragonair | ZU | $59 |
| 147 | Dragonite | UU | $42 |

---

## Immediate Next Steps (fresh context)

1. **Scrape Smogon OU/UU pages** for competitive movesets for all 49 Pokemon.
   Individual pages: `https://www.smogon.com/dex/rb/pokemon/<name>/` (lowercase, hyphens for spaces).
   Get the recommended moves for each Pokemon.

2. **Write `data/pokemon/optimized_moves.asm`** using those movesets.
   Table format: 190 entries × 8 bytes. Only the 49 Pokemon need non-zero data.
   See Phase 4 section below for full format details.

3. **Edit `main.asm`** — add these 3 lines after `INCLUDE "engine/movie/oak_speech/oak_speech.asm"` (line 21, bank1 section):
   ```
   INCLUDE "engine/movie/team_picker.asm"
   INCLUDE "engine/pokemon/give_team.asm"
   INCLUDE "data/pokemon/optimized_moves.asm"
   ```

4. **Edit `ram/wram.asm` line 941** — update comment: change "146-item list (0-145)" to "49-item list (0-48)".

5. **Build and test** — `make` and run in emulator (mgba or bgb). Start a new game and verify:
   - Indigo Plateau Lobby spawn
   - Team picker shows 49 Pokemon scrollably
   - Selection gives 6 Pokemon at level 50 with the right moves

---

## Key Files Reference

### Must Replace / Heavily Modify
| File | Purpose |
|---|---|
| `engine/movie/oak_speech/oak_speech.asm` | Replace Oak intro with "Choose Your Team" screen |
| `engine/movie/oak_speech/oak_speech2.asm` | Adapt or keep player naming; remove rival naming |
| `engine/menus/main_menu.asm` | Change starting map to `INDIGO_PLATEAU_LOBBY` |
| `scripts/OaksLab.asm` | Rendered unused; starter selection is gone |

### Must Create (New Files)
| File | Purpose |
|---|---|
| `engine/movie/team_picker/team_picker.asm` | New 6-pick team selection engine |
| `data/pokemon/optimized_moves.asm` | Table: 146 Pokemon × 4 moves each |

### Content Customisation (Elite 4 + Champion)
| File | Purpose |
|---|---|
| `data/trainers/parties.asm` | Replace Lorelei/Bruno/Agatha/Lance/Rival3 teams |
| `data/trainers/names.asm` | Rename Elite 4 to friends' names |
| `text/LoreleisRoom.asm` | Friend 1 pre/post-battle dialogue |
| `text/BrunosRoom.asm` | Friend 2 dialogue |
| `text/AgathasRoom.asm` | Friend 3 dialogue |
| `text/LancesRoom.asm` | Friend 4 dialogue |
| `text/ChampionsRoom.asm` | Champion dialogue |
| `scripts/ChampionsRoom.asm` | Champion team variant logic |

### Untouched (Works As-Is)
- `engine/battle/` — entire battle engine
- `engine/movie/hall_of_fame.asm` + `scripts/HallOfFame.asm` — Hall of Fame fires automatically after beating champion
- `engine/events/pokemon_center.asm` — Pokemon Center healing
- All audio/music
- Pokemon base stats, types, move data

---

## Phase Breakdown

---

### Phase 1 — Change Starting Map
**Difficulty: Easy | Estimated: 1–2 hours**

In `engine/menus/main_menu.asm`, when "New Game" is chosen, the game sets `wDefaultMap`
and then hands off to the Oak Speech sequence. The Oak sequence (line 59–61 of
`oak_speech.asm`) eventually calls `PrepareForSpecialWarp` with `wDestinationMap`.

Change: after team selection completes, set `wDestinationMap` = `INDIGO_PLATEAU_LOBBY`
and warp there instead of Pallet Town. The Pokemon Center map ID is `0xAE`.

---

### Phase 2 — Replace Oak Intro with Team Picker Entry
**Difficulty: Medium | Estimated: 3–5 hours**

`engine/movie/oak_speech/oak_speech.asm` currently:
1. Shows Oak sprite + intro text
2. Calls `ChoosePlayerName`
3. Shows Nidorino demo
4. Calls `ChooseRivalName`
5. Warp to Pallet Town

Replace with:
1. Black screen → text: "Welcome to the  POKéMON LEAGUE!  Choose your team."
2. Optionally keep `ChoosePlayerName` (nice to have, 2 lines of code to keep)
3. Skip `ChooseRivalName` — the Champion can have a fixed name (e.g. "GARY" or a friend's name hardcoded)
4. Call the new `TeamPicker` engine 6 times
5. Warp to `INDIGO_PLATEAU_LOBBY`

The intro music can stay or be swapped for the Pokemon League music track.

---

### Phase 3 — Team Picker UI
**Status: ✅ DONE**

`engine/movie/team_picker.asm` — scrollable 49-Pokemon list, 8 visible at a time.

- `TeamPickerPokemonList`: 49 species IDs in Pokedex order
- `TeamPicker`: outer loop (6 slots), resets cursor, calls `DrawTeamPickerScreen` + `RunPickerForSlot`
- `RunPickerForSlot`: joypad loop — UP/DOWN scroll, A selects; stores species in `wTeamPickerMons[slot]`
- `DrawTeamPickerScreen`: full redraw — header "CHOOSE MON N OF 6", divider, 8 names with ▷ cursor, instructions
- Uses `JoypadLowSensitivity` with auto-repeat (hJoy6=1, hJoy7=1)
- Uses `GetMonName` + `PlaceString` for name rendering
- `wBuffer+9` used as scratch for firstVisible (safe: within 30-byte wBuffer, not aliased)

**Duplicates allowed** — simplifies code; player can pick the same species twice if they want.

---

### Phase 4 — Give Pokemon at Level 50 with Optimised Moves
**Status: ✅ DONE (code), ⚠️ PENDING (moveset data)**

`engine/pokemon/give_team.asm`:
- `GiveChosenTeam`: loops 6 times over `wTeamPickerMons`, calls `AddPartyMon` (level 50, `wMonDataLocation=$10`), then `WriteOptimizedMoveset`
- `WriteOptimizedMoveset`: indexes `OptimizedMovesTable` by `(species-1)*8`, copies 8 bytes to `wBuffer`, writes 4 moves to `mon_base+MON_MOVES` and 4 PP to `mon_base+MON_PP`

`data/pokemon/optimized_moves.asm` — **file exists but movesets need replacing with proper Smogon competitive sets**.

#### How to write optimized_moves.asm for the next session

The file is a 190-entry table (slots 0–189, one per species $01–$BE), 8 bytes each:
`db move1, move2, move3, move4, pp1, pp2, pp3, pp4`

Only the 49 OU/UU Pokemon need real data. All other slots: `empty_mon` macro = `db NO_MOVE,NO_MOVE,NO_MOVE,NO_MOVE, 0,0,0,0`.

**Source movesets from Smogon** — the pages below list analysis pages with competitive sets for each Pokemon. Fetch each Pokemon's individual page (e.g. `https://www.smogon.com/dex/rb/pokemon/tauros/`) to get the actual recommended moves:
- OU: https://www.smogon.com/dex/rb/formats/ou/
- UU: https://www.smogon.com/dex/rb/formats/uu/

Move constants are in `constants/move_constants.asm`. PP values are the base PP for each move (e.g. Body Slam=15, Surf=15, Blizzard=5, Thunderbolt=15, Psychic=10, Recover=20, Thunder Wave=20, Earthquake=10, Rock Slide=10, Softboiled=10, Seismic Toss=20, Explosion=5, Amnesia=20, Hyper Beam=5, Sleep Powder=15, Stun Spore=30, Slash=20, Swords Dance=30, Agility=30, Reflect=20, Hypnosis=20, Dream Eater=15, Lovely Kiss=10, Substitute=10, Razor Leaf=25, Clamp=10, Wrap=20, Glare=30, Screech=40, Crabhammer=10, Drill Peck=20, Bubblebeam=20, Flamethrower=15, Fire Blast=5, Confuse Ray=10, Pin Missile=20, Submission=25, Super Fang=10, Night Shade=15, Minimize=20).

**Gen 1 competitive notes:**
- Blizzard = 90% accuracy in Gen 1, goes on almost everything that can learn it
- Body Slam = best Normal move (30% paralysis chance)
- Amnesia doubles Special in one turn — broken with Surf/Psychic/Blizzard
- Critical hit rate scales with Speed — fast mons crit constantly
- No Special split — one stat covers both Sp.Atk and Sp.Def

---

### Phase 5 — Elite 4 Customisation
**Difficulty: Easy | Estimated: 3–5 hours**

#### Teams (`data/trainers/parties.asm`)

Replace the existing data blocks. Format with variable levels:
```asm
; db $FF, level, species, level, species, ..., 0
Friend1Data:
  db $FF, 52, STARMIE, 54, ALAKAZAM, 55, TAUROS, 56, GENGAR, 58, DRAGONITE, 0
```

Set levels in the 52–62 range for appropriate difficulty at the end-game.

#### Names (`data/trainers/names.asm`)

Replace `LORELEI`, `BRUNO`, `AGATHA`, `LANCE` with friends' names.
Max 13 characters each. Format: `db "NAME@"`.

#### Dialogue (`text/LoreleisRoom.asm` etc.)

Each room has pre-battle and post-battle text. Replace with funny/personalised lines.
Text box is 18 chars wide. Use `#MON` for "POKéMON" (saves chars).

Example structure:
```asm
_LoreleisRoomTrainerText::
  text "Oi! You think"
  line "you can beat"
  cont "my ice squad?"
  done
```

Rooms to edit:
1. `text/LoreleisRoom.asm` + `scripts/LoreleisRoom.asm` — Friend 1
2. `text/BrunosRoom.asm` + `scripts/BrunosRoom.asm` — Friend 2
3. `text/AgathasRoom.asm` + `scripts/AgathasRoom.asm` — Friend 3
4. `text/LancesRoom.asm` + `scripts/LancesRoom.asm` — Friend 4

---

### Phase 6 — Champion Customisation
**Difficulty: Easy–Medium | Estimated: 1–2 hours**

The Champion is internally the "Rival" — team defined in `data/trainers/parties.asm`
as `Rival3Data`. Currently has three variants based on which starter the player chose.

Since there's no starter selection in this hack, simplify to a single team variant
(or keep three variants — one triggered based on which Pokemon the player chose first,
which is a fun touch but optional).

Champion's name can be hardcoded in the script or set to the rival name if player
naming is kept. Text is in `text/ChampionsRoom.asm`.

The Hall of Fame sequence fires automatically after the Champion is beaten —
**no changes needed there**. It shows the player's party, plays the music, saves the
Hall of Fame record, then gives an ending screen. This is the win condition.

---

## Trainer Sprites

The Elite 4 and Champion will keep their existing sprites unless GFX replacement is
also done. Sprite work is a separate, optional phase and not required for the hack to
be functional. If desired, the 4 Elite 4 sprites and the Champion sprite can each be
replaced with a custom 56×56 pixel image (2bpp format, matching existing sprite sheets).

---

## Technical Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Team picker is too hard to build | Medium | Fall back to simpler flat name list (no sprites) |
| Bank overflow (new code won't fit in target bank) | Low | Allocate a new ROM bank in `main.asm` |
| Stat calc not running correctly after manual level set | Medium | Call `CalcStats` predef explicitly; verify in emulator |
| PP not set correctly for custom moves | Low | Write PP bytes alongside move bytes using existing PP table |
| Duplicate pick prevention bitmask bugs | Low | Test all edge cases in emulator |
| Hall of Fame shows wrong data | Low | No changes to HoF code; should work fine |

---

## Estimated Effort

| Phase | Est. Time | Difficulty |
|---|---|---|
| 1. Change starting map | 1–2 hrs | Easy |
| 2. Replace Oak intro flow | 3–5 hrs | Medium |
| 3. Team picker UI | 2–4 days | Very Hard |
| 4. Level 50 + moveset assignment | 4–8 hrs | Medium |
| 5. Optimised moveset table (146 Pokemon) | 1–2 days | Low (just data) |
| 6. Elite 4 teams + names + dialogue | 3–5 hrs | Easy |
| 7. Champion customisation | 1–2 hrs | Easy |
| 8. Testing + bug fixes | 1–2 days | Medium |

**Total: approximately 1–2 weeks of focused work**

The team picker UI is the highest-risk item and the bottleneck. Everything else
is straightforward data editing or small code changes.

---

## Order of Implementation (Recommended)

1. Elite 4 + Champion teams and dialogue first — lowest risk, instant visible results
2. Change starting map — verify player spawns in Pokemon Center
3. Team picker (simplest version: flat name list) — get it working, then polish
4. Level 50 + moveset assignment — wire up after picker works
5. Optimised moveset table — fill out all 146 entries
6. Polish the picker UI (add sprites if going with Pokedex approach)
7. Replace Oak intro text with "Choose Your Team" screen
8. Full end-to-end playtest in emulator
