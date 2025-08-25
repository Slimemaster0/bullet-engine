files = src/main.s src/entity.s src/player.s src/enemy.s src/map.s

output: $(files) gfx/tiles.chr gfx/sprites.chr mapconvertion
	cl65 --cpu 6502x --verbose -d -g -Wl --dbgfile,bullet.dbg $(files) --target nes -o bullet.nes 

mapconvertion: mapconverter
	tools/mapconverter screens/*

mapconverter: tools/src/mapconverter.c tools/src/mapconverter.h
	gcc -g tools/src/mapconverter.c -Og -o tools/mapconverter
