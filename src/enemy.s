; vim: set syntax=asm_ca65:
; vim:fileencoding=utf-8:foldmethod=marker

; Includes generic functions for enemies and a refrence/test implementation

; Includes
.include "entity.h"

; Imports
.import DistroyBullet

; Exports
.export EnemyTick

; Refrence enemy
EnemyTick:
.scope RefrenceEnemy
	; Collision to do
	
	; Movement
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
	
    Draw:
	

    Done:
	rts
.endscope



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
