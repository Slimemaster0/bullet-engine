output: src/main.s gfx/tiles.chr gfx/sprites.chr
	cl65 --verbose -d -g -Wl --dbgfile,bullet.dbg src/main.s src/entity.s src/player.s --target nes  -o bullet.nes 
