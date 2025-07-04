; vim: set syntax=asm_ca65:
; vim:fileencoding=utf-8:foldmethod=marker


.segment "HEADER"
    .byte $4E, $45, $53, $1A
    .byte 2
    .byte 1
    .byte $01, $05

.export Main
.segment "CODE"

.proc Main

    rts
.endproc

.segment "STARTUP"

; Constants

; Addresses
; Includes
.include "system.h"
.include "player.h"
.include "entity.h"


; Imports
.import FindSlots
.import Fire
.import BulletTick
.import EnemyTick



RESET: ; {{{
.scope
    sei ; Disable Interupts
    cld ; Turn off decimal as its not supported on the NES


    ldx #%1000000 ; Disable sound IRQ
    stx $4017
    ldx #$00
    stx $4010     ; Disable PCM

    ; Initialize the stack
    ldx #$FF
    txs

    ; Clear PPU registers
    ldx #$00
    stx $2000
    stx $2001

    ; Wait for VBlank
:
    bit $2002
    bpl :-

    ; Clear the memory
    txa
ClearMemory: ; Clear the memory from $0000 to $07ff
	sta $0000, x
	sta $0100, x
	sta $0300, x
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x
	lda #$FF
	sta $0200, x
	lda #$00
	inx
	cpx #$00
    bne ClearMemory

    ; Prepair PPU for writting palette data.
    lda #$3f
    sta $2006
    lda #$00
    sta $2006

    ldx #$00
LoadPalettes:
	lda PaletteData, x
	sta $2007
	inx
	cpx #$20
    bne LoadPalettes

    ; Reset scroll
    lda #$00
    sta $2005
    sta $2005

ClearBackground:
	lda $2002 ; Read PPU status to reset high/low latch
	lda #$20
	sta $2006
	lda #$00
	; Store #$00 in X and Y
	tay
	tax
	sta $2006
	lda #$ff
	ClearBackground1:
	    sta $2007
	    inx
	    cpx #$00
	    bne ClearBackground1
	    iny
	    cpy #$04
	    bne ClearBackground1

    


    ; Enable Interupts
    cli

    lda #%10010000
    sta $2000 		; When VBlank occurs call NMI

    lda #%00011110 	; Show sprites and background
    sta $2001

    ; Initialize veriables
    lda #$78
    sta PlayerPosX
    lda #$d0
    sta PlayerPosY

    ; Tempurary debugging stuff
    ; Spawn Debug Enemy
    lda #$01
    sta Enemies
    lda #$20
    sta EntityPosXs
    sta EntityPosYs
    lda #$00
    sta EntityStatuses

.endscope ; }}}

    InfLoop: 
	jmp InfLoop

NMI:
    lda $2002

    ; lda SpriteIndex	; Load sprite range
    ; lsr
    ; lsr
    lda #$02
    sta $4014

    lda #$ff
    ldx #$10
ClearOAM:
    sta $0200, x
    inx
    cpx SpriteIndex
    bcc ClearOAM

    jsr FindSlots

    ; Decriment fire cool down
    lda FireCooldown
    cmp #$00
    beq BuildPlayerSprite
    dec FireCooldown
    
BuildPlayerSprite:
    ldx #$00
    stx SpriteIndex

    clc
    ; build player

    ; Sprite 1
    lda PlayerPosY
    sta $0200, x
    inx
    lda #$00
    sta $0200, x
    inx
    lda #%00000000
    sta $0200, x
    inx
    lda PlayerPosX
    sta $0200, x
    inx

    ; Sprite 2
    lda PlayerPosY
    adc #$08
    sta $0200, x
    inx
    lda #$01
    sta $0200, x
    inx
    lda #%00000000
    sta $0200, x
    inx
    lda PlayerPosX
    sta $0200, x
    inx
    
    ; Sprite 3
    lda PlayerPosY
    sta $0200, x
    inx
    lda #$00
    sta $0200, x
    inx
    lda #%01000000
    sta $0200, x
    inx
    lda PlayerPosX
    adc #$08
    sta $0200, x
    inx
    
    ; Sprite 4
    lda PlayerPosY
    adc #$08
    sta $0200, x
    inx
    lda #$01
    sta $0200, x
    inx
    lda #%01000000
    sta $0200, x
    inx
    lda PlayerPosX
    adc #$08
    sta $0200, x
    inx
    stx SpriteIndex

    ; Input
    jsr ReadJoy
    lda Buttons
    tax
    ; Right
    and #%00000001
    cmp #%00000001
    bne Left
    ldy PlayerPosX
    cpy #$f0
    beq Down
    inc PlayerPosX
Left:
    txa
    and #%00000010
    cmp #%00000010
    bne Down
    ldy PlayerPosX
    cpy #$00
    beq Down
    dec PlayerPosX
Down:
    txa
    and #%00000100
    cmp #%00000100
    bne Up
    ldy PlayerPosY
    cpy #$df
    beq StartBtn
    inc PlayerPosY
Up:
    txa
    and #%00001000
    cmp #%00001000
    bne StartBtn
    ldy PlayerPosY
    cpy #$00
    beq StartBtn
    dec PlayerPosY
StartBtn:
    txa
    and #%00010000
    bne SelectBtw
    ; To do
SelectBtw:
    txa
    and #%00100000
    bne BtnB
    ; To do
BtnB:
    txa
    and #%01000000
    bne BtnA
    ; To do
BtnA:
    lda FireCooldown
    cmp #$00
    bne InputDone

    txa 
    cmp #%10000000
    bcc InputDone
    lda #$0a
    sta FireCooldown
    jsr Fire
    
InputDone:
    
    ldy #$ff
HandleEnemies:
    iny
    ldx UsedSlots, y
    cpx #$fe
    bcs HandleEnemyBullets
    jsr EnemyTick
    jmp HandleEnemies

HandleEnemyBullets:
    
    
    ldy #$0f
HandlePlayerBullets:
    iny
    ldx UsedSlots, y
    cpx #$fe
    bcs EntityDone
    jsr BulletTick
    jmp HandlePlayerBullets
    

EntityDone:
    
    rti


; At the same time that we strobe bit 0, we initialize the ring counter
; so were hitting two birds with one stone here
ReadJoy:
    lda Buttons
    lda #$01
    ; While the strobe bit is set, buttons will be continuously reloaded.
    ; This means that reading from JOYPAD1 will only return the state of the
    ; first button: button A.
    sta JOYPAD1
    sta Buttons
    lsr a        ; now A is 0
    ; By storing 0 into JOYPAD1, the strobe bit is cleared and the reloading stops.
    ; This allows all 8 buttons (newly reloaded) to be read from JOYPAD1.
    sta JOYPAD1
Loop:
    lda JOYPAD1
    lsr a        ; bit 0 -> Carry
    rol Buttons  ; Carry -> bit 0; bit 7 -> Carry
    bcc Loop
    rts

PaletteData:
    .byte $00, $0F, $00, $10, 	$00, $0A, $15, $01, 	$00, $29, $28, $27, 	$00, $34, $24, $14 	; background palettes
    .byte $31, $30, $27, $15, 	$31, $06, $0f, $2d, 	$00, $0F, $30, $27, 	$00, $3C, $2C, $1C 	; sprite palettes

.segment "VECTORS"
    .word NMI
    .word RESET

.segment "CHARS"
.incbin "../gfx/sprites.chr"
.incbin "../gfx/tiles.chr"
