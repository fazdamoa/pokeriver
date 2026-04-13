; GiveChosenTeam
; Adds all 6 Pokemon from wTeamPickerMons to the player's party at level 50
; with optimised movesets from OptimizedMovesTable.

GiveChosenTeam:
	xor a
	ld [wGiveTeamIndex], a

.loop
	ld a, [wGiveTeamIndex]
	cp 6
	ret z

	; Load species for this slot
	ld hl, wTeamPickerMons
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [wCurPartySpecies], a

	; Set level 50 for AddPartyMon
	ld a, 50
	ld [wCurEnemyLevel], a

	; $10 = add to player party, skip naming screen
	ld a, $10
	ld [wMonDataLocation], a

	; Add to party (home bank — always accessible)
	call AddPartyMon

	; Overwrite level-up moves with optimised set
	call WriteOptimizedMoveset

	ld a, [wGiveTeamIndex]
	inc a
	ld [wGiveTeamIndex], a
	jr .loop

; ─────────────────────────────────────────────
; WriteOptimizedMoveset
; Reads 8 bytes from OptimizedMovesTable for the
; current wCurPartySpecies and writes them into
; the last party mon: moves[0..3] then pp[0..3].
; Clobbers: AF, BC, DE, HL
; ─────────────────────────────────────────────
WriteOptimizedMoveset:
	; Step 1: compute table pointer into HL
	; table entry = OptimizedMovesTable + (species-1) * 8
	ld a, [wCurPartySpecies]
	dec a              ; 0-based index
	ld h, 0
	ld l, a
	add hl, hl         ; *2
	add hl, hl         ; *4
	add hl, hl         ; *8
	ld bc, OptimizedMovesTable
	add hl, bc         ; HL = table entry for this species

	; Step 2: copy all 8 bytes (moves+pp) into wBuffer temporarily
	ld de, wBuffer
	ld bc, 8
	call CopyData      ; wBuffer[0..7] = {move1,move2,move3,move4,pp1,pp2,pp3,pp4}

	; Step 3: find last party mon base address
	ld a, [wPartyCount]
	dec a              ; 0-based slot
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes     ; HL = mon_base

	; Step 4: write 4 moves at mon_base + MON_MOVES
	ld a, l
	add MON_MOVES
	ld e, a
	ld a, h
	adc 0
	ld d, a            ; DE = &moves[0]

	ld a, [wBuffer + 0]
	ld [de], a
	inc de
	ld a, [wBuffer + 1]
	ld [de], a
	inc de
	ld a, [wBuffer + 2]
	ld [de], a
	inc de
	ld a, [wBuffer + 3]
	ld [de], a

	; Step 5: write 4 PP at mon_base + MON_PP
	; Recompute mon_base (HL was clobbered by AddNTimes already saved it)
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes     ; HL = mon_base again

	ld a, l
	add MON_PP
	ld e, a
	ld a, h
	adc 0
	ld d, a            ; DE = &pp[0]

	ld a, [wBuffer + 4]
	ld [de], a
	inc de
	ld a, [wBuffer + 5]
	ld [de], a
	inc de
	ld a, [wBuffer + 6]
	ld [de], a
	inc de
	ld a, [wBuffer + 7]
	ld [de], a
	ret
