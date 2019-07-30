CFLAGS = ${BASEFLAGS} $(shell sdl-config --cflags) $(shell pkg-config --cflags lua5.1)
LDFLAGS = ${BASEFLAGS} $(shell sdl-config --libs) -lSDL_image -lSDL_mixer -lSDL_ttf $(shell pkg-config --libs lua5.1)

