CFLAGS = ${BASEFLAGS} $(shell /opt/buildroot-2018.02.11/output/host/mipsel-buildroot-linux-uclibc/sysroot/usr/bin/sdl-config --cflags) -I/usr/include/lua5.1 -I/usr/include/smpeg
LDFLAGS = ${BASEFLAGS} $(shell /opt/buildroot-2018.02.11/output/host/mipsel-buildroot-linux-uclibc/sysroot/usr/bin/sdl-config --libs) -lSDL_image -lSDL_mixer -lSDL_ttf -llua

