; TeamPicker
; Scrollable 40-Pokemon picker (OU/UU competitive tier) for new game.
; Player picks 6 Pokemon stored in wTeamPickerMons[0..5].
;
; Screen layout (20×18 tiles):
;   Row  0: "CHOOSE MON N OF 6   " (slot-specific header)
;   Row  1: ────────────────────── (divider)
;   Rows 2–9: 8 visible Pokemon names with ▷ cursor at col 0
;   Row 11: "A:OK UP/DOWN:SCROLL " (instructions)
;
; Clobbers: AF, BC, DE, HL, wBuffer+9 (scratch for firstVisible)

DEF TEAM_PICKER_MON_COUNT EQU 40
DEF TEAM_PICKER_VISIBLE   EQU 8
DEF TEAM_PICKER_MAX_FIRST EQU TEAM_PICKER_MON_COUNT - TEAM_PICKER_VISIBLE ; 32

; ─────────────────────────────────────────────────────
; Pokemon list (Pokedex order, OU/UU tier)
; OU: Alakazam, Chansey, Cloyster, Exeggutor, Gengar, Golem, Jolteon,
;     Jynx, Lapras, Rhydon, Slowbro, Snorlax, Starmie, Tauros, Zapdos
; UU: Aerodactyl, Articuno, Clefable, Dewgong, Dodrio, Dragonite, Dugtrio,
;     Electabuzz, Electrode, Gyarados, Haunter, Hypno, Kadabra, Kangaskhan,
;     Moltres, Ninetales, Omastar, Persian, Raichu, Rapidash, Tangela,
;     Tentacruel, Vaporeon, Venusaur, Victreebel
; ─────────────────────────────────────────────────────
TeamPickerPokemonList:
	db VENUSAUR    ; #3   UU
	db RAICHU      ; #26  UU
	db CLEFABLE    ; #36  UU
	db NINETALES   ; #38  UU
	db DUGTRIO     ; #51  UU
	db PERSIAN     ; #53  UU
	db KADABRA     ; #64  UU
	db ALAKAZAM    ; #65  OU
	db VICTREEBEL  ; #71  UU
	db TENTACRUEL  ; #73  UU
	db GOLEM       ; #76  OU
	db RAPIDASH    ; #78  UU
	db SLOWBRO     ; #80  OU
	db DODRIO      ; #85  UU
	db DEWGONG     ; #87  UU
	db CLOYSTER    ; #91  OU
	db HAUNTER     ; #93  UU
	db GENGAR      ; #94  OU
	db HYPNO       ; #97  UU
	db ELECTRODE   ; #101 UU
	db EXEGGUTOR   ; #103 OU
	db RHYDON      ; #112 OU
	db CHANSEY     ; #113 OU
	db TANGELA     ; #114 UU
	db KANGASKHAN  ; #115 UU
	db STARMIE     ; #121 OU
	db JYNX        ; #124 OU
	db ELECTABUZZ  ; #125 UU
	db TAUROS      ; #128 OU
	db GYARADOS    ; #130 UU
	db LAPRAS      ; #131 UU
	db VAPOREON    ; #134 UU
	db JOLTEON     ; #135 OU
	db OMASTAR     ; #139 UU
	db AERODACTYL  ; #142 UU
	db SNORLAX     ; #143 OU
	db ARTICUNO    ; #144 UU
	db ZAPDOS      ; #145 OU
	db MOLTRES     ; #146 UU
	db DRAGONITE   ; #149 UU
TeamPickerPokemonListEnd:

; ─────────────────────────────────────────────────────
; Header strings: one per slot (1–6), 20 chars + @ each
; ─────────────────────────────────────────────────────
TeamPickerHeaders:
	dw .h1, .h2, .h3, .h4, .h5, .h6
.h1: db "CHOOSE MON 1 OF 6   @"
.h2: db "CHOOSE MON 2 OF 6   @"
.h3: db "CHOOSE MON 3 OF 6   @"
.h4: db "CHOOSE MON 4 OF 6   @"
.h5: db "CHOOSE MON 5 OF 6   @"
.h6: db "CHOOSE MON 6 OF 6   @"

TeamPickerInstrStr: db "A:OK UP/DOWN:SCROLL  @"

; ─────────────────────────────────────────────────────
; TeamPicker
; Outer loop: picks 6 Pokemon one at a time.
; ─────────────────────────────────────────────────────
TeamPicker:
	; Enable auto-repeat for held buttons (mode 2)
	ld a, 1
	ldh [hJoy7], a
	ld a, 1
	ldh [hJoy6], a

	xor a
	ld [wTeamPickerSlot], a

.slotLoop:
	ld a, [wTeamPickerSlot]
	cp 6
	ret z

	xor a
	ld [wTeamPickerCurrentIndex], a

	call DrawTeamPickerScreen
	call RunPickerForSlot

	ld a, [wTeamPickerSlot]
	inc a
	ld [wTeamPickerSlot], a
	jr .slotLoop

; ─────────────────────────────────────────────────────
; RunPickerForSlot
; Input loop for one slot. Returns when A pressed.
; ─────────────────────────────────────────────────────
RunPickerForSlot:
.inputLoop:
	call JoypadLowSensitivity
	ldh a, [hJoy5]

	bit B_PAD_UP, a
	jr nz, .up

	bit B_PAD_DOWN, a
	jr nz, .down

	bit B_PAD_A, a
	jr nz, .select

	jr .inputLoop

.up:
	ld a, [wTeamPickerCurrentIndex]
	and a
	jr z, .inputLoop         ; already at top
	dec a
	ld [wTeamPickerCurrentIndex], a
	call DrawTeamPickerScreen
	jr .inputLoop

.down:
	ld a, [wTeamPickerCurrentIndex]
	cp TEAM_PICKER_MON_COUNT - 1
	jr z, .inputLoop         ; already at bottom
	inc a
	ld [wTeamPickerCurrentIndex], a
	call DrawTeamPickerScreen
	jr .inputLoop

.select:
	; Get species ID at current index
	ld a, [wTeamPickerCurrentIndex]
	ld hl, TeamPickerPokemonList
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]               ; A = species ID

	; Store in wTeamPickerMons[wTeamPickerSlot]
	ld b, a                  ; save species
	ld a, [wTeamPickerSlot]
	ld hl, wTeamPickerMons
	ld e, a
	ld d, 0
	add hl, de
	ld [hl], b
	ret

; ─────────────────────────────────────────────────────
; DrawTeamPickerScreen
; Full screen redraw. Clobbers: AF, BC, DE, HL
; Uses wBuffer+9 as scratch for firstVisible.
; ─────────────────────────────────────────────────────
DrawTeamPickerScreen:
	call ClearScreen

	; ── Row 0: slot-specific header ──
	ld a, [wTeamPickerSlot]
	add a                    ; *2 (word table offset)
	ld e, a
	ld d, 0
	ld hl, TeamPickerHeaders
	add hl, de               ; HL = &table[slot*2]
	ld a, [hli]
	ld h, [hl]
	ld l, a                  ; HL = header string pointer
	ld d, h
	ld e, l                  ; DE = string
	hlcoord 0, 0
	call PlaceString

	; ── Row 1: ──────────────────── divider ──
	hlcoord 0, 1
	ld b, 20
.divider:
	ld [hl], $7a             ; ─ tile
	inc hl
	dec b
	jr nz, .divider

	; ── Row 11: instructions ──
	hlcoord 0, 11
	ld de, TeamPickerInstrStr
	call PlaceString

	; ── Compute firstVisible = clamp(currentIndex-4, 0, MAX_FIRST) ──
	ld a, [wTeamPickerCurrentIndex]
	sub 4
	jr nc, .noUnderflow
	xor a
.noUnderflow:
	cp TEAM_PICKER_MAX_FIRST + 1
	jr c, .storeFV
	ld a, TEAM_PICKER_MAX_FIRST
.storeFV:
	ld [wBuffer + 9], a      ; wBuffer+9 = firstVisible scratch

	; ── Draw 8 visible entries (rows 2–9) ──
	ld b, 0                  ; B = visibleRow (0–7)
.drawLoop:
	ld a, b
	cp TEAM_PICKER_VISIBLE
	jr z, .drawDone

	; listIndex = firstVisible + visibleRow
	ld a, [wBuffer + 9]
	add b                    ; A = listIndex
	cp TEAM_PICKER_MON_COUNT
	jr nc, .drawDone         ; safety

	; Get species at this listIndex
	ld e, a
	ld d, 0
	ld hl, TeamPickerPokemonList
	add hl, de
	ld a, [hl]               ; A = species ID
	ld [wNamedObjectIndex], a

	push bc                  ; save B=visibleRow (C=garbage, harmless)
	call GetMonName          ; result: DE = wNameBuffer
	pop bc                   ; B = visibleRow restored

	; Determine cursor tile: ▷ if this row is current, space otherwise
	ld a, [wBuffer + 9]      ; firstVisible
	add b                    ; + visibleRow = absolute listIndex for this row
	ld c, a                  ; C = absolute listIndex
	ld a, [wTeamPickerCurrentIndex]
	cp c
	ld a, $7f                ; space (not cursor)
	jr nz, .notCursor
	ld a, $ec                ; ▷
.notCursor:
	ld c, a                  ; C = cursor tile

	; Compute tilemap address: wTileMap + screenRow * 20, col 0
	; screenRow = 2 + visibleRow (= 2 + B)
	push de                  ; save name pointer
	ld a, b
	add 2                    ; A = screenRow (2–9)
	ld l, a
	ld h, 0                  ; HL = screenRow
	add hl, hl               ; *2
	add hl, hl               ; *4
	ld e, l
	ld d, h                  ; DE = screenRow * 4
	add hl, hl               ; *8
	add hl, hl               ; *16
	add hl, de               ; HL = screenRow * 20
	ld de, wTileMap
	add hl, de               ; HL = wTileMap + screenRow*20 (col 0)

	ld [hl], c               ; cursor tile at col 0
	inc hl
	ld [hl], $7f             ; space at col 1
	inc hl                   ; HL = col 2 (name starts here)

	pop de                   ; DE = wNameBuffer
	call PlaceString

	inc b                    ; next visible row
	jr .drawLoop

.drawDone:
	ret
