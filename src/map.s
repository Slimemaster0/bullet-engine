; vim: set syntax=asm_ca65:
; vim:fileencoding=utf-8:foldmethod=marker

.include "system.h"

.export DrawMap

DrawMap:
    lda $2002
    lda #$20
    sta $2006
    sta Temp1
    lda #$00
    sta $2006
    sta Temp2
    
    clc
    ldx #$ff
Loop:
    inx
    ldy Screen1, x
    cpy #$00
    beq Done
    inx
WriteRLE:
    lda Screen1, x
    sta $2007
    dey
    cpy #$00
    bne WriteRLE

    inx
    ldy Screen1, x
WriteImmediate:
    cpy #$00
    beq Loop
    inx
    lda Screen1, x
    sta $2007

    dey
    cpy #$00
    bne WriteImmediate
    jmp Loop
    
    Done:
    
    rts
    

Screen1:
.incbin "../screens/screen1"
