files = src/main.s src/entity.s src/player.s src/enemy.s

output: src/main.s gfx/tiles.chr gfx/sprites.chr
	cl65 --verbose -d -g -Wl --dbgfile,bullet.dbg $(files) --target nes -o bullet.nes 
