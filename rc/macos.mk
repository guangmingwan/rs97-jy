CFLAGS = ${BASEFLAGS} $(shell sdl-config --cflags) -I/opt/local/include/lua-5.1 -I/usr/include/lua5.1 -I/usr/include/smpeg
LDFLAGS = ${BASEFLAGS} $(shell sdl-config --libs) -L/opt/local/lib/lua-5.1/ -lSDL_image -lSDL_mixer -lSDL_ttf -llua-5.1

