; vim: set syntax=asm_ca65:
; vim:fileencoding=utf-8:foldmethod=marker

.include "entity.h"
.include "system.h"

.export FindSlots

; Lists out all 
FindSlots:
    .scope outer

    FullIndex 	= Temp1
    EmptyIndex 	= Temp2

    ldx #$00
    stx FullIndex
    stx EmptyIndex

	Enemies:  ; {{{
	.scope Enemies
	    cpx #$10
	    bcs Epilogue
	    lda Entities, x
	    inx
	    cmp #$00
	    beq EmptySlot
	    jmp FullSlot


	EmptySlot:
	    txa
	    ldy EmptyIndex
	    sta FreeSlots, y
	    inc EmptyIndex
	    jmp Enemies

	FullSlot:
	    txa
	    ldy FullIndex
	    sta UsedSlots, y
	    inc FullIndex
	    jmp Enemies

	Epilogue:
	lda #$ff

	ldy EmptyIndex
	.scope epilogue
	    EmptySlot:
		sta FreeSlots, y
		iny
		cpy #$10
		bcc EmptySlot
		sty EmptyIndex
		ldy FullIndex

	    FullSlot:
		sta UsedSlots, y
		iny
		cpy #$10
		bcc FullSlot
		sty FullIndex
		
	    .endscope

	.endscope ; }}}


	FriendlyBullets: ; {{{
	.scope FriendlyBullets
	    cpx #$20
	    bcs Epilogue
	    lda Entities, x
	    inx
	    cmp #$00
	    beq EmptySlot
	    jmp FullSlot


	EmptySlot:
	    txa
	    ldy EmptyIndex
	    sta FreeSlots, y
	    inc EmptyIndex
	    jmp FriendlyBullets

	FullSlot:
	    txa
	    ldy FullIndex
	    sta UsedSlots, y
	    inc FullIndex
	    jmp FriendlyBullets

	Epilogue:
	lda #$ff

	ldy EmptyIndex
	.scope epilogue
	    EmptySlot:
		sta FreeSlots, y
		iny
		cpy #$20
		bcc EmptySlot
		sty EmptyIndex
		ldy FullIndex

	    FullSlot:
		sta UsedSlots, y
		iny
		cpy #$20
		bcc FullSlot
		sty FullIndex
		
	    .endscope

	.endscope ; }}}

	    
	EnemyBullets: ; {{{
	.scope EnemyBullets
	    cpx #$40
	    bcs Epilogue
	    lda Entities, x
	    inx
	    cmp #$00
	    beq EmptySlot
	    jmp FullSlot


	EmptySlot:
	    txa
	    ldy EmptyIndex
	    sta FreeSlots, y
	    inc EmptyIndex
	    jmp EnemyBullets

	FullSlot:
	    txa
	    ldy FullIndex
	    sta UsedSlots, y
	    inc FullIndex
	    jmp EnemyBullets

	Epilogue:
	lda #$ff

	ldy EmptyIndex
	.scope epilogue
	    EmptySlot:
		sta FreeSlots, y
		iny
		cpy #$40
		bcc EmptySlot
		sty EmptyIndex
		ldy FullIndex

	    FullSlot:
		sta UsedSlots, y
		iny
		cpy #$40
		bcc FullSlot
		sty FullIndex
		
	    .endscope

	.endscope ; }}}

    .endscope
    rts
