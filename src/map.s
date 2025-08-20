; vim: set syntax=asm_ca65:
; vim:fileencoding=utf-8:foldmethod=marker

.include "system.h"
.include "map.h"
.include "entity.h"

.export DrawMap
.export MapProgress
.export MapPointersLo
.export MapPointersHi

.import EnemyHP

DrawMap: ; {{{
    .scope Drawing
    lda $2002
    stx $2006
    sty $2006
    
    ldx Temp1
    lda #$00
    sta PointerLo
    ldy TableLo, x
    lda TableHi, x
    sta PointerHi

    dey
Loop:
    iny
    cpy #$00 ; DO NOT TOUCH!!!
    bne skip1
    inc PointerHi
skip1:
    lax ($00), y
    beq Done
    iny
    bne LoadTile
    inc PointerHi
LoadTile:
    lda ($00), y
WriteRLE:
    sta $2007
    dex
    bne WriteRLE

    iny
    bne WriteImmediatePrelude
    inc PointerHi
WriteImmediatePrelude:
    lax ($00), y
WriteImmediate:
    beq Loop
    iny
    bne skip2
    inc PointerHi
skip2:
    lda ($00), y
    sta $2007

    dex
    bne WriteImmediate

    jmp Loop
    
    Done:
    
    rts

TableLo:
    .byte <Screen1, <Screen2, <Status

TableHi:
    .byte >Screen1, >Screen2, >Status
    

Screen1:
.incbin "../screens/screen1"
Screen2:
.incbin "../screens/screen2"


Status:
.incbin "../screens/statusbar"
.endscope
; }}}

MapProgress: ; {{{
.scope MapProgress
	lda #$ff
	dec MapPosLo
	cmp MapPosLo
	bne DontRun
	dec MapPosHi
	cmp MapPosHi
	beq RunRutine
    DontRun:
	rts

    RunRutine:
	; Increment and load map pointer
	clc
	lda MapPointerLo
	adc #$01
	sta PointerLo

	lda MapPointerHi
	adc #$00
	sta PointerHi

	ldy #$00
	


    Check:
	; Quick and dirty check
	lda ($00), y
	cmp #$00
	beq SpawnEnemy
	cmp #$01
	beq ChangeBackground
	cmp #$ff
	beq End

	jmp Finish

    Done:
    .scope local
	clc
	lda PointerLo
	adc #$01
	sta PointerLo
	lda PointerHi
	adc #$00
	sta PointerHi
	lda ($00), y
	tax

	lda PointerLo
	adc #$01
	sta PointerLo
	lda PointerHi
	adc #$00
	sta PointerHi
	lda ($00), y
	tay

	cpx #$00
	bne StoreAndReturn
	cpy #$00
	bne StoreAndReturn
	
	inc PointerLo
	lda #$00
	cmp PointerLo
	bne Check
	inc PointerHi

	ldy #$00

	jmp Check
	
    StoreAndReturn:
	stx MapPosHi
	sty MapPosLo

	jmp Finish
    .endscope
	

    Finish:
	lda PointerLo
	sta MapPointerLo
	lda PointerHi
	sta MapPointerHi
	rts


    End:
	sec
	lda PointerLo
	sbc #$03
	sta PointerLo
	lda PointerHi
	sbc #$00

	jmp Done


    ChangeBackground:
	clc
	lda PointerLo
	adc #$04
	sta PointerLo
	lda PointerHi
	adc #$00
	sta PointerHi
	

	jmp Done


    SpawnEnemy:
    .scope SpawnEnemy
	    ldx #$ff
	Search:
	    inx
	    cpx #$10
	    beq Failure
	    lda Entities, x
	    cmp #$00
	    bne Search

	Spawn:
	    ldy #$01

	    lda ($00), y
	    sta Entities, x
	    tay
	    lda EnemyHP, y
	    sta EntityHealths, x
	    
	    ldy #$02

	    lda ($00), y
	    sta EntityPosXs, x

	    iny
	    lda ($00), y
	    sta EntityPosYs, x

	    lda #$00
	    sta EntityStatuses, x
	    
	    clc
	    lda PointerLo
	    adc #$03
	    sta PointerLo
	    lda PointerHi
	    adc #$00
	    sta PointerHi
	    
	    
	    jmp Done

	Failure:
	    clc
	    lda PointerLo
	    adc #$03
	    sta PointerLo
	    lda PointerHi
	    adc #$00
	    sta PointerHi
	    
	    ldx #$ff
	    jmp Done

	.endscope

.endscope

MapPointersLo:
    .byte <Map1 +1

MapPointersHi:
    .byte >Map1

; Map data
; Map format: TimeHi, TimeLo, command id, args
;
; Commands: 		$ID, args
; Spawn Enemy: 		$00, enemy id, X possiton, Y possiton
; Change background: 	$01, background id, Nametable Hi Name Table Lo
; Change Palettes:	$03, Palette1 Id, Palette2 Id, Palette3 Id, Palette3 Id, Palette4 Id
; End 			$ff

Map1:
;    .byte $00, $00, $01, $00, $20, $00
;    .byte $00, $00, $01, $01, $28, $00

    .byte $00, $00, $00, $01, $30, $10
    .byte $01, $00, $00, $01, $30, $10
    .byte $ff, $ff, $ff


PaletteColor1:
    .byte $31, $31, $31, $31 ; $00-$03
    .byte $2a, $2a, $2a, $2a ; $04-$07

PaletteColor2:
    .byte $0f, $29, $29, $34 ; $00-$03
    .byte $17 		     ; $04-$07

PaletteColor3:
    .byte $00, $1a, $28, $24 ; $00-$03
    .byte $09


PaletteColor4:
    .byte $10, $11, $27, $14 ; $00-$03
    .byte $19 		     ; $04-$07

; }}}
