# Plan: League-Only Hack

## Concept

Strip the entire Pokemon world. When a new game starts, the player goes through a
"Choose Your Team" screen (6 picks from 146 available Pokemon), then spawns in the
Indigo Plateau Pokemon Center with their full team at level 50 with optimised movesets.
Their only goal: beat the Elite 4 and the Champion, reach the Hall of Fame, win.

The rest of the world map, towns, routes, gyms — none of it is deleted, it just becomes
unreachable because the player never starts there.

---

## Pokemon Available for Selection

151 total − Mew − Mewtwo − Articuno − Zapdos − Moltres = **146 Pokemon**

Excluded by species ID:
- `MEW` = 0x15
- `ARTICUNO` = 0xC3
- `ZAPDOS` = 0xC4
- `MOLTRES` = 0xC5
- `MEWTWO` = 0xC9

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
**Difficulty: Very Hard | Estimated: 2–4 days**

This is the most complex piece. The player needs to scroll through 146 Pokemon names,
pick 6 one at a time, and not be able to pick the same species twice.

#### Recommended Approach: Adapt the Pokedex List

The Pokedex (`engine/pokedex/pokedex.asm`) already has a scrollable list of all Pokemon
by number, showing the name and a sprite. Adapting it:

- Strip out Pokedex ownership checks — every entry is always visible
- Replace the "seen/owned" display with a cursor + selection prompt
- Skip the 5 excluded species IDs when building the list
- On A-press: confirm selection, mark species as "chosen" (bitmask in RAM), continue
- On B-press: go back one slot (deselect last pick)
- After 6 picks: exit the picker and proceed to team assembly

#### RAM Needed
- 6 bytes for chosen species IDs (temp storage during picker) — use existing scratch RAM
  e.g. around `wBuffer` area, or define 6 new bytes in `ram/wram.asm`
- 19-byte bitmask (one bit per species 0x00–0xBE) to block re-selecting — can pack into
  existing unused RAM or define in `wram.asm`

#### UI Flow Per Pick
```
Pick 1 of 6:          [scrollable list]
> BULBASAUR           A = Select
  IVYSAUR             B = Cancel last pick
  VENUSAUR            ...
```
After A on e.g. CHARIZARD:
```
You chose CHARIZARD!
  [CHARIZARD sprite]
  Is this OK?
  > YES
    NO
```
If YES: mark chosen, move to Pick 2 of 6.
If NO: return to list.

#### Fallback (if Pokedex adaptation is too complex)
Use a simpler linear name list without sprites — 10 names visible at once, D-pad scrolls,
A selects. Less visual but much faster to implement (~200 lines vs ~500 lines).

---

### Phase 4 — Give Pokemon at Level 50 with Optimised Moves
**Difficulty: Medium | Estimated: 4–8 hours**

After all 6 species are chosen, loop through the 6 stored IDs and for each:

1. **Add to party**: call `_AddPartyMon` (in `engine/pokemon/add_mon.asm`) with the species.
   The mon is added to `wPartyMons` in RAM.

2. **Set level to 50**: write `50` directly to the party mon's level byte in `wPartyMons`
   (offset `+0x21` within each 44-byte mon block).

3. **Recalculate stats**: call the existing `CalcStats` predef with the party index.
   This derives HP/Atk/Def/Spd/Spc from base stats + level + IVs + stat exp.
   IVs will be whatever `_AddPartyMon` generates (random, which is fine).

4. **Apply optimised moveset**: look up the species in the new `optimized_moves.asm` table.
   Write 4 move bytes directly to the party mon's move slots (offsets `+0x08`–`+0x0B`),
   and write the full PP values to slots `+0x1D`–`+0x20`.

#### optimized_moves.asm Format
```asm
; One entry per species (indexed by Pokemon constant value)
; 4 moves per Pokemon
OptimizedMovesTable:
  ; NO_MON (0x00) — placeholder
  db NO_MOVE, NO_MOVE, NO_MOVE, NO_MOVE
  ; RHYDON (0x01)
  db EARTHQUAKE, ROCK_SLIDE, BODY_SLAM, SUBSTITUTE
  ; ...etc for all 151 entries (unused/legendary slots get NO_MOVE)
```

This is a lookup table indexed directly by Pokemon constant. Size: 151 × 4 = 604 bytes.
Fits easily in any ROM bank.

#### Example Optimised Movesets (Gen 1 Level 50 competitive logic)

| Pokemon | Move 1 | Move 2 | Move 3 | Move 4 |
|---|---|---|---|---|
| Charizard | FLAMETHROWER | SLASH | FIRE_SPIN | BODY_SLAM |
| Blastoise | SURF | BLIZZARD | WITHDRAW | BODY_SLAM |
| Venusaur | RAZOR_LEAF | SLEEP_POWDER | BODY_SLAM | LEECH_SEED |
| Rhydon | EARTHQUAKE | ROCK_SLIDE | BODY_SLAM | SUBSTITUTE |
| Gyarados | SURF | BLIZZARD | THUNDERBOLT | BODY_SLAM |
| Dragonite | BLIZZARD | THUNDERBOLT | BODY_SLAM | WRAP |
| Alakazam | PSYCHIC | RECOVER | THUNDER_WAVE | SEISMIC_TOSS |
| Gengar | HYPNOSIS | DREAM_EATER | THUNDERBOLT | PSYCHIC |
| Tauros | BODY_SLAM | HYPER_BEAM | BLIZZARD | EARTHQUAKE |
| Starmie | SURF | BLIZZARD | THUNDERBOLT | RECOVER |
| Exeggutor | PSYCHIC | SLEEP_POWDER | EXPLOSION | STUN_SPORE |
| Snorlax | AMNESIA | BODY_SLAM | REFLECT | SELF_DESTRUCT |
| Jolteon | THUNDERBOLT | DOUBLE_KICK | PIN_MISSILE | BODY_SLAM |
| Vaporeon | SURF | BLIZZARD | ACID_ARMOR | BODY_SLAM |
| Machamp | SUBMISSION | EARTHQUAKE | ROCK_SLIDE | BODY_SLAM |
| Slowbro | AMNESIA | SURF | PSYCHIC | THUNDER_WAVE |
| Lapras | SURF | BLIZZARD | THUNDERBOLT | BODY_SLAM |
| Aerodactyl | HYPER_BEAM | SLASH | FIRE_BLAST | ROCK_SLIDE |
| Golem | EARTHQUAKE | ROCK_SLIDE | EXPLOSION | BODY_SLAM |
| Clefable | MINIMIZE | BODY_SLAM | THUNDER_WAVE | BLIZZARD |

(Full table of 146 Pokemon to be completed during implementation)

**Gen 1 notes that inform moveset choices:**
- Blizzard has 90% accuracy in Gen 1 — goes on almost every mon that can learn it
- Body Slam is the best Normal move (30% paralysis chance)
- Critical hit rate scales with Speed stat — fast mons crit often
- Wrap/Fire Spin pin opponents for full-duration damage each turn
- Amnesia doubles Special in one turn — broken with Surf/Psychic
- No Special split — one stat covers both attack and defence

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
