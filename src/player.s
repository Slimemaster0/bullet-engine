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
    adc #$07 ; Adding 8 because I know the carry flag is set
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
    lda EntityPosYs, x
    cmp #$ff
    beq DistroyBullet


    rts
