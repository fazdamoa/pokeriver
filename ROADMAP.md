# PokeRiver Romhack - Roadmap

A Pokemon Red/Blue romhack built on the [pret/pokered](https://github.com/pret/pokered) disassembly.

## Project Approach

Changes are made **town-by-town**, progressing through the game in roughly the order a player encounters each area. Each town/area gets its own phase covering:

- Trainer teams (gym leaders, route trainers, rival encounters)
- Wild Pokemon encounters (grass, water, fishing)
- NPC dialogue and storyline
- Shop inventories
- Map layout changes (if any)
- Any new events or mechanics

## Progress Tracker

### Phase 0: Project Setup
- [x] Fork and set up repository
- [x] GitHub Actions for ROM builds
- [x] Project management docs

### Phase 1: Pallet Town & Route 1
- [x] Opening dialogue / Oak's speech
- [x] Starter Pokemon: Vaporeon (gives Ditto), Seel, Ponyta
- [ ] Route 1 wild encounters
- [x] Rival battle team (all encounters updated through Champion)
- [x] Item renames: potion line -> stout/beer theme (Guinness, Murphys, Beamish, Camden Stout, Est. Galicia)
- [x] Oak's lab NPC dialogue (pathetic sycophants)
- [x] Route 1 NPC dialogue (Guinness 0 kid, ledge kid)
- [x] Pallet Town NPC dialogue (AI girlfriend fisher, "protect" girl)

### Phase 2: Viridian City & Route 2
- [ ] Viridian City NPC dialogue
- [ ] Viridian Mart inventory
- [ ] Route 2 wild encounters
- [ ] Viridian Forest wild encounters & trainers

### Phase 3: Pewter City & Brock's Gym
- [ ] Pewter Gym: Brock's team
- [ ] Pewter City NPC dialogue
- [ ] Pewter Mart inventory
- [ ] Museum changes (if any)
- [ ] Route 3 trainers & wild encounters

### Phase 4: Mt. Moon & Route 4
- [ ] Mt. Moon wild encounters (all floors)
- [ ] Mt. Moon trainers
- [ ] Fossil selection events
- [ ] Route 4 wild encounters

### Phase 5: Cerulean City & Misty's Gym
- [ ] Cerulean Gym: Misty's team
- [ ] Cerulean City NPC dialogue
- [ ] Nugget Bridge (Route 24) trainers
- [ ] Route 25 trainers & Bill's house
- [ ] Routes 5-6 wild encounters & trainers

### Phase 6: Vermilion City & Lt. Surge's Gym
- [ ] Vermilion Gym: Lt. Surge's team
- [ ] S.S. Anne trainers & events
- [ ] Vermilion City dialogue & shops
- [ ] Route 11 trainers & wild encounters
- [ ] Diglett's Cave encounters

### Phase 7: Lavender Town & Pokemon Tower
- [ ] Pokemon Tower encounters & trainers
- [ ] Lavender Town dialogue
- [ ] Routes 8-10 trainers & wild encounters
- [ ] Rock Tunnel encounters & trainers

### Phase 8: Celadon City & Erika's Gym
- [ ] Celadon Gym: Erika's team
- [ ] Game Corner prizes & Rocket Hideout
- [ ] Celadon Dept. Store inventory
- [ ] Celadon City dialogue
- [ ] Routes 16-18 (Cycling Road) trainers

### Phase 9: Fuchsia City & Koga's Gym
- [ ] Fuchsia Gym: Koga's team
- [ ] Safari Zone encounters
- [ ] Fuchsia City dialogue & shops
- [ ] Routes 12-15 trainers & wild encounters
- [ ] Sea Routes 19-20 encounters

### Phase 10: Saffron City & Sabrina's Gym
- [ ] Saffron Gym: Sabrina's team
- [ ] Fighting Dojo
- [ ] Silph Co. trainers & events
- [ ] Saffron City dialogue & shops

### Phase 11: Cinnabar Island & Blaine's Gym
- [ ] Cinnabar Gym: Blaine's team
- [ ] Pokemon Mansion encounters & trainers
- [ ] Cinnabar Lab events
- [ ] Route 21 encounters

### Phase 12: Viridian Gym & Giovanni
- [ ] Viridian Gym: Giovanni's team
- [ ] Route 22-23 encounters & trainers
- [ ] Victory Road encounters & trainers

### Phase 13: Elite Four & Champion
- [ ] Lorelei's team
- [ ] Bruno's team
- [ ] Agatha's team
- [ ] Lance's team
- [ ] Champion (Rival) teams
- [ ] Hall of Fame / ending

### Phase 14: Post-Game & Polish
- [ ] Cerulean Cave encounters
- [ ] Any remaining loose ends
- [ ] Playtesting & balance pass

## Key Files Reference

| What to change | File(s) |
|---|---|
| Gym leader / trainer teams | `data/trainers/parties.asm` |
| Wild Pokemon (grass/water) | `data/wild/grass_water.asm` |
| Fishing encounters | `data/wild/super_rod.asm`, `data/wild/good_rod.asm` |
| NPC dialogue | `text/<MapName>.asm` |
| Map event scripts | `scripts/<MapName>.asm` |
| Shop inventories | `data/items/marts.asm` |
| Pokemon base stats | `data/pokemon/base_stats/` |
| Moves | `data/moves/moves.asm` |
| Evolutions & learnsets | `data/pokemon/evos_moves.asm` |
| Item definitions | `data/items/` |
| Map objects (NPC placement) | `data/maps/objects/` |
| Map headers (connections) | `data/maps/headers/` |
