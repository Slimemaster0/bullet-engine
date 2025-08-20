files = src/main.s src/entity.s src/player.s src/enemy.s src/map.s

output: src/main.s gfx/tiles.chr gfx/sprites.chr
	cl65 --cpu 6502x --verbose -d -g -Wl --dbgfile,bullet.dbg $(files) --target nes -o bullet.nes 
