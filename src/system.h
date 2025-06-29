; vim: set syntax=asm_ca65:
; PPU {{{
PPUCtrl = 	$2000
PPUMask = 	$2001
PPUStatus = 	$2002
OAMAddresse = 	$2003
OAMData = 	$2004
PPUScroll = 	$2005
PPUAddresse = 	$2006
PPUData = 	$2007
OAMDMA = 	$4014
SpriteIndex = 	$03fd
; }}}

; Joypad
JOYPAD1 = 	$4016
JOYPAD2 = 	$4017

Buttons = 	$03fc

Temp1 	= $ff
Temp2 	= $fe
