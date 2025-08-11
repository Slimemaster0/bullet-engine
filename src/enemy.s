; vim: set syntax=asm_ca65:
; vim:fileencoding=utf-8:foldmethod=marker

; Includes generic functions for enemies and a refrence/test implementation

; Includes
.include "entity.h"
.include "system.h"
.include "player.h"

; Exports
.export EnemyTick
.export EnemyBulletTick
.export EnemyHP



    

; Refrence enemy
EnemyTick:
.scope RefrenceEnemy
    .scope Collision
	    ; Give tempurary veriables names for easyer readability
	    EnemyID = 	Temp1
	    EnemySlot = Temp2
	    BulletSlot =Temp3
	Prologue:
	    stx EnemyID
	    sty EnemySlot

	    ldx #$0f
	    stx BulletSlot
	PreLoop:
	    ldx BulletSlot
	Loop:
	    inx
	    cpx #$20
	    beq Epilogue
	    ldy UsedSlots, x
	    cpy #$fe
	    beq Loop
	    bcs Epilogue
	
	    stx BulletSlot
	    ldx EnemyID
	    clc
	    
	CheckBelow:
	    lda EntityPosYs, x
	    adc #$10
	    cmp EntityPosYs, y
	    bcc PreLoop
	    clc

	CheckAbove:
	    lda EntityPosYs, y
	    adc #$08
	    cmp EntityPosYs, x
	    bcc PreLoop
	    clc

	CheckLeft:
	    lda EntityPosXs, y
	    adc #$08
	    cmp EntityPosXs, x
	    bcc PreLoop
	    clc

	CheckRight:
	    lda EntityPosXs, x
	    adc #$10
	    cmp EntityPosXs, y
	    bcc PreLoop

	    ; Distroy the bullet
	    lda #$00
	    sta Entities, y
	    ldy BulletSlot
	    lda #$fe
	    sta UsedSlots, y

	    dec EntityHealths, x
	    lda EntityHealths, x
	    cmp #$00
	    bne Epilogue
	    
	    ldy EnemySlot

	    sta Entities, x
	    lda #$fe
	    sta UsedSlots, y
	

	Epilogue:
	    ldx EnemyID
	    ldy EnemySlot

    .endscope
	
    Movement:
	lda EntityStatuses, x
	cmp #%10000000
	bcs MoveLeft
    MoveRight:
	inc EntityPosXs, x
	lda EntityPosXs, x
	cmp #$d8
	bcc MoveDone
	lda EntityStatuses, x
	eor #%10000000
	sta EntityStatuses, x
	bcs MoveDone

    MoveLeft:
	dec EntityPosXs, x
	lda EntityPosXs, x
	cmp #$18
	bcs MoveDone
	lda EntityStatuses, x
	eor #%10000000
	sta EntityStatuses, x

    MoveDone:
	
    DrawPrologue:
	clc
	sty Temp1
	ldy SpriteIndex
	cpy #$fd
	bcs DrawEpilogue
    Draw:
	lda EntityPosYs, x
	sta $0200, y
	sta $0204, y
	adc #$08
	sta $0208, y
	sta $020c, y
	iny
	lda #$03
	sta $0200, y
	sta $0204, y
	lda #$04
	sta $0208, y
	sta $020c, y
	iny
	lda #%01000001
	sta $0204, y
	sta $0208, y
	lda #%00000001
	sta $0200, y
	sta $020c, y
	iny
	lda EntityPosXs, x
	sta $0200, y
	sta $020c, y
	adc #$08
	sta $0208, y
	sta $0204, y

	tya 
	adc #$0d
	sta SpriteIndex

    DrawEpilogue:
	ldy Temp1
    
	; Fire bullets
	txa
	adc GlobalClock
	and #%00111111
	cmp #$00
	bne FireDone

	ldy #$1f
    Search:
	iny
	cpy #$40
	beq FireEpilogue
	lda Entities, y
	cmp #$00
	bne Search

	; Placing the bullet
	lda #$01
	sta Entities, y
	lda EntityPosXs, x
	adc #$03
	sta EntityPosXs, y
	lda EntityPosYs, x
	adc #$04
	sta EntityPosYs, y
	lda #$ff
	sta EntityHealths, y
	sta EntityStatuses, y
	

    FireEpilogue:
    ldy Temp1

    FireDone:
    
    Done:
	rts
.endscope

DistroyBullet:
    lda #$00
    sta Entities, x
    lda #$fe
    sta UsedSlots, y
    rts

EnemyBulletTick:
    inc EntityPosYs, x
    inc EntityPosYs, x
    lda EntityPosYs, x
    cmp #$fe
    bcs DistroyBullet

    sty Temp1
    ; Build sprite
    ldy SpriteIndex
    sta $0200, y
    iny
    lda #$02
    sta $0200, y
    iny
    lda #%10000001
    sta $0200, y
    iny
    lda EntityPosXs, x
    sta $0200, y
    iny
    sty SpriteIndex

    ldy Temp1
    rts
    


EnemyHP: ; {{{
; $00 - $0f
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $10 - $1f
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $20 - $2f
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $30 - $3f
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $40 - $4f
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $50 - $5f
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $60 - $6f
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $70 - $7f
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $80 - $8f
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $90 - $9f
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $a0 - $af
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $b0 - $bf
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $c0 - $cf
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $d0 - $df
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $e0 - $ef
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05

; $f0 - $ff
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
 .byte $05, $05, $05, $05
; }}}
