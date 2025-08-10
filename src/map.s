; vim: set syntax=asm_ca65:
; vim:fileencoding=utf-8:foldmethod=marker

.include "system.h"

.export DrawMap

DrawMap:
    lda $2002
    stx $2006
    sty $2006
    
    ldx Temp1
    lda TableLo, x
    sta PointerLo
    lda TableHi, x
    sta PointerHi

    
    clc
    ldy #$ff
Loop:
    iny
    cpy #$00
    bne _
    inc PointerHi
    _:
    lda ($00), y
    tax
    cpx #$00
    beq Done
    iny
    cpy #$00
    bne WriteRLE
    inc PointerHi
WriteRLE:
    lda ($00), y
    sta $2007
    dex
    cpx #$00
    bne WriteRLE

    iny
    cpy #$00
    bne WriteImmediatePrelude
    inc PointerHi
WriteImmediatePrelude:
    lda ($00), y
    tax
WriteImmediate:
    cpx #$00
    beq Loop
    iny
    lda ($00), y
    sta $2007

    dex
    cpx #$00
    bne WriteImmediate
    jmp Loop
    
    Done:
    
    rts

TableLo:
    .byte <Screen1

TableHi:
    .byte >Screen1 -1
    

Screen1:
.incbin "../screens/screen1"
