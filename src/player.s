; vim: set syntax=asm_ca65:
; vim:fileencoding=utf-8:foldmethod=marker

; Addresses
.include "system.h"
.include "player.h"
.include "entity.h"

; Exports
.export Fire
.export BulletTick

Failure:
    ldx #$ff
    rts

Fire:
    ; Find empty slot
    ldx #$0f
Search:
    inx
    cpx #$20
    bcs Failure
    lda Entities, x
    cmp #$00
    bne Search
    
    ; Placing the projectile
    lda #$01
    sta Entities, x
    lda PlayerPosX
    adc #$03 ; Adding 8 because I know the carry flag is set
    sta EntityPosXs, x
    lda PlayerPosY
    sta EntityPosYs, x
    lda #$ff
    sta EntityHealths, x
    sta EntityStatuses, x
Done:
    rts

DistroyBullet:
    lda #$00
    sta Entities, x
    lda #$fe
    sta UsedSlots, y
    rts

; Set X to the ID of the Bullet and Y to the used slot
BulletTick:
    dec EntityPosYs, x
    dec EntityPosYs, x
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
    lda #%00000010
    sta $0200, y
    iny
    lda EntityPosXs, x
    sta $0200, y
    iny
    sty SpriteIndex

    ldy Temp1
    rts
