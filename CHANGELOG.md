# PokeRiver Romhack - Changelog

All notable changes to the romhack will be documented here.

Format: each entry lists the phase, date, and a summary of what changed.

---

## [Unreleased]

### Phase 1: Pallet Town & Route 1 (2026-02-26)

**Item Renames (Stout/Beer Theme)**
- FULL_RESTORE → "EST. GALICIA" (Estrella Galicia, abbreviated for 12-char limit)
- MAX_POTION → "CAMDEN STOUT"
- HYPER_POTION → "BEAMISH"
- SUPER_POTION → "MURPHYS"
- POTION → "GUINNESS"
- Internal constants unchanged; only display names in `data/items/names.asm`

**Starter Pokemon Changes**
- STARTER1 = CLEFAIRY (middle ball, was Charmander)
- STARTER2 = SEEL (right ball, was Squirtle)
- STARTER3 = DODUO (left ball, was Bulbasaur)
- Rival trainer data updated across ALL encounters (Oak's Lab → Champion)
- Evolution mapping: Clefairy→Clefable, Seel→Dewgong, Doduo→Dodrio
- Assembly labels still say "Charmander"/"Squirtle"/"Bulbasaur" (functional via STARTER constants)

**Oak Dialogue**
- Tall grass scene: subliminal messaging about player's mum ("How's your mum doing? What's she wearing today?")
- Choose mon speech: "Some people raise powerful Pokemon cause they're scared. Others choose humanoid female ones...for some reason."
- Clefairy selection: "She's quite the handful at night. Heh heh." (innuendo)

**Oak's Lab NPCs**
- Girl: Oak yelled at her for 20 mins for using wrong mug, she thanked him (pathetic sycophant)
- Scientist: Works 90 hours unpaid, Oak threw a flask at him, "What a legend!" (abusive boss worship)

**Rival Dialogue (90s Bully Overhaul)**
- First encounter: "Prob out sniffing around your mum's place again"
- Choose phase: "Go ahead and pick, loser... I'll still destroy you"
- After starter: "Yours looks like it'd lose to a wet napkin"
- Battle challenge: "What? Scared? Ha! That's so gay. Just like you!"
- Rival loses: "I can't believe I lost to YOU of all people!"
- Rival wins: "You're trash! Absolute garbage!"
- Farewell: "Tell her MR.MIME misses her too! Hahaha! Smell you later"
- Pokedex farewell: "Good luck being lost AND useless!"
- Other insults added throughout ("nonce", "loser", "old man")

**Route 1 NPCs**
- Youngster 1 (gives Guinness): On the GUINNESS 0 after drunk driving a ZIPCAR, nearly killed a PIDGEY. Return dialogue about 0.0% tasting like fizzy water.
- Youngster 2 (ledge kid): Jumps off ledges daily, "the only thing to do around here", darkly ponders what's at the bottom

**Pallet Town NPCs (previously changed)**
- Fisher: Goth AI girlfriend tells him off for eating pizza
- Girl: Raises Pokemon that can "protect" her

### Phase 0: Project Setup (2026-02-24)
- Forked from pret/pokered
- Added GitHub Actions workflow to build and publish ROM artifacts
- Added project management docs (ROADMAP, CHANGELOG, IDEAS)
