# PokeRiver - Dialogue & Script Change Plan

This file tracks planned and completed dialogue changes.
Each entry links to the relevant `text/<File>.asm` for editing.

**Format:**
- `[x]` = done
- `[ ]` = planned / not yet done
- `[~]` = partially done

---

## How to use this file with Claude

Tell Claude: "Implement the next undone change in CHANGES.md" or
"Implement [Section] > [NPC]" and it will read the relevant .asm, make
the edit, and mark it done here.

Text rules (see CLAUDE.md):
- 18 chars max per line
- `text` = first line, `line` = 2nd, `cont` = scroll, `para` = new box
- `done` = end+wait, `prompt` = end+wait before menu, `text_end` = no wait

---

## Pallet Town — `text/PalletTown.asm`

- [x] **Oak — stop player leaving town**: Mum reference ("How's your mum doing?")
- [x] **Girl (protection NPC)**: Air-quotes "protect" me
- [x] **Fisher**: AI girlfriend who judges his diet

---

## Red's House — `text/RedsHouse1F.asm`

- [x] **Mum (wake up)**: Mr. Mime reference ("your fath- ahem MR.MIME and I will miss you")
- [x] **Mr. Mime**: Gazing at mum with adoration
- [ ] **TV**: Currently vanilla ("Four boys on railroad tracks"). Replace or leave?
- [ ] **Mum (after getting Pokemon)**: Could add Oak-calling-again reference here

---

## Oak's Lab — `text/OaksLab.asm`

- [x] **Rival — Gramps isn't around**: Mum joke ("prob out sniffing around your mum's place")
- [x] **Rival — go ahead and choose**: Full bully ("Go ahead and pick, loser")
- [x] **Rival — my Pokemon looks stronger**: Wet napkin insult
- [x] **Rival — fed up waiting**: "I've been waiting ages, old man!"
- [x] **Rival — what about me**: "Don't just ignore me for this nonce"
- [x] **Rival — I'll take you on (battle challenge)**: "That's so gay. Just like you"
- [x] **Rival — lost battle**: "I can't believe I lost to YOU of all people!"
- [x] **Rival — won battle**: "You're trash, absolute garbage"
- [x] **Rival — smell ya later**: Mr. Mime / mum joke, "Smell you later"
- [x] **Rival — leave it all to me (Pokedex)**: Bully taunts, "Good luck being lost AND useless"
- [x] **Oak — Vaporeon selection**: Innuendo text ("compatibility... she's the most... Ahem")
- [x] **Oak — Seel selection**: "Wow, nice choice mate. Solid pick."
- [x] **Oak — Ponyta selection**: "Wow, nice choice mate. Solid pick."
- [x] **Oak aide (girl)**: Wrong mug, flask thrown, "What a legend!"
- [x] **Scientist**: 90 hours/week, no pay, flask thrown, worships Oak
- [ ] **Oak — choose Pokemon speech**: Currently has some custom text but could go further (creep energy re: Vaporeon)
- [ ] **Oak aide [005]/[006]/[007]**: Only one aide has custom text so far — add more broken staff

---

## Route 1 — `text/Route1.asm`

- [x] **Mart employee (free Potion)**: Zipcar drunk driver, GUINNESS 0 ("Drunk drove home in a ZIPCAR")
- [x] **Ledge kid**: Existential ledge-jumping, "Sometimes I think about what's at the bottom"

---

## Viridian City — `text/ViridianCity.asm`

- [x] **Most NPCs**: Appear to be vanilla-ish (caterpillar question, old man coffee, etc.) — verified as largely unchanged
- [ ] **Old man blocking path**: Currently vanilla. Could be weirder/funnier
- [ ] **Pokecenter NPCs** (`text/ViridianPokecenter.asm`): Not yet checked
- [ ] **Mart clerk (Oak's parcel)** (`text/ViridianMart.asm`): Not yet checked
- [ ] **School NPCs** (`text/ViridianSchoolHouse.asm`): Blackboard — not yet checked

---

## Pewter City — `text/PewterCity.asm` / `text/PewterGym.asm`

- [ ] **Brock**: Currently vanilla. "rock hard defense and determination" — make more unhinged
- [ ] **Pewter City NPCs**: All vanilla — museum refs, Jigglypuff Pokecenter, repel guy
- [ ] **Museum** (`text/Museum1F.asm`, `text/Museum2F.asm`): Not yet changed
- [ ] **Nidoran house** (`text/PewterNidoranHouse.asm`): Not yet checked
- [ ] **Pokecenter** (`text/PewterPokecenter.asm`): Not yet checked

---

## Cerulean City — `text/CeruleanCity.asm` / `text/CeruleanGym.asm`

- [ ] **Misty**: Currently vanilla. Keep or tweak
- [ ] **Cerulean City NPCs**: Largely vanilla
- [ ] **Bill** (`text/BillsHouse.asm`): Not yet checked
- [ ] **Badge house** (`text/CeruleanBadgeHouse.asm`): Not yet checked
- [ ] **Rocket behind trashed house** (`text/CeruleanTrashedHouse.asm`): Not yet checked

---

## Vermilion City — `text/VermilionCity.asm`

- [ ] **Lt. Surge** (`text/VermilionGym.asm`): Not yet changed
- [ ] **Vermilion City NPCs**: Largely vanilla
- [ ] **Fan Club chairman** (`text/PokemonFanClub.asm`): Not yet checked
- [ ] **Old Rod house** (`text/VermilionOldRodHouse.asm`): Not yet checked
- [ ] **S.S. Anne** (`text/SSAnne*.asm`): Not yet changed

---

## Everything beyond Vermilion — not yet started

- [ ] Lavender Town + Pokemon Tower
- [ ] Celadon City (Erika, Game Corner, Giovanni Rocket Hideout)
- [ ] Saffron City (Sabrina, Silph Co., Copycat)
- [ ] Fuchsia City (Koga, Safari Zone, Warden)
- [ ] Cinnabar Island (Blaine, Lab, Mansion)
- [ ] Viridian Gym (Giovanni)
- [ ] Victory Road
- [ ] Elite Four + Blue Champion fight

---

## Items (already renamed — no text changes needed)

| Internal | Display |
|---|---|
| FULL_RESTORE | EST. GALICIA |
| MAX_POTION | CAMDEN STOUT |
| HYPER_POTION | BEAMISH |
| SUPER_POTION | MURPHYS |
| POTION | GUINNESS |

---

## Starters (logic done, text done)

| Starter | Display | Actually Given | Status |
|---|---|---|---|
| Middle | VAPOREON | DITTO | [x] script + text done |
| Right | SEEL | SEEL | [x] text done |
| Left | PONYTA | PONYTA | [x] text done |
