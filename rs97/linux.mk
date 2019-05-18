CFLAGS = ${BASEFLAGS} $(shell sdl-config --cflags) -I/usr/include/lua5.1 
LDFLAGS = ${BASEFLAGS} $(shell sdl-config --libs) -lSDL_image -lSDL_mixer -lSDL_ttf -llua5.1

