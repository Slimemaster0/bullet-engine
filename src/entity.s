; vim: set syntax=asm_ca65:
; vim:fileencoding=utf-8:foldmethod=marker

.include "entity.h"
.include "system.h"

.export FindSlots

; Lists out all 
FindSlots:
    .scope outer

    lda #$ff
    tax
ClearOldData:
    inx
    sta FreeSlots, x
    cpx #$8f
    bne ClearOldData

    EmptyIndex 	= Temp1
    FullIndex 	= Temp2
    ldy #$00
    sty EmptyIndex
    sty FullIndex


    tax
	Enemies:  ; {{{
	.scope Enemies
	    inx
	    cpx #$10
	    bcs Epilogue
	    lda Entities, x
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
	.endscope ; }}}

	.scope FriendlyBullets ; {{{
	Prologue:
	ldx #$0f
	ldy #$10
	sty EmptyIndex
	sty FullIndex

	FriendlyBullets: 
	    inx
	    cpx #$20
	    bcs Epilogue
	    lda Entities, x
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
	.endscope ; }}}

	.scope EnemyBullets  ; {{{
	Prologue:
	ldx #$1f
	ldy #$10
	sty EmptyIndex
	sty FullIndex
	    
	EnemyBullets:
	    inx
	    cpx #$40
	    bcs Epilogue
	    lda Entities, x
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
	.endscope ; }}}

    .endscope
    rts
