OBJ =  ../src/charset.o \
        ../src/jymain.o \
        ../src/luafun.o \
        ../src/mainmap.o \
        ../src/piccache.o \
        ../src/sdlfun.o

HEADERS =  config.h list.h luafun.h

CC = mipsel-linux-gcc
CXX = mipsel-linux-g++

TARGET = ../bin/sdljy.bin

BASEFLAGS = -g3 -D_DEBUG=1
#BASEFLAGS = -s -O3

CFLAGS = ${BASEFLAGS} $(shell /opt/buildroot-2018.02.11/output/host/mipsel-buildroot-linux-uclibc/sysroot/usr/bin/sdl-config --cflags) -I/usr/include/lua5.1 -I/usr/include/smpeg
LDFLAGS = ${BASEFLAGS} $(shell /opt/buildroot-2018.02.11/output/host/mipsel-buildroot-linux-uclibc/sysroot/usr/bin/sdl-config --libs) -lSDL_image -lSDL_mixer -lSDL_ttf -llua

#CFLAGS += -DHAS_SDL_MPEG=1
#LDFLAGS += -lsmpeg

all : ${TARGET}

${TARGET} : ${OBJ}
	${CC} ${LDFLAGS} -o ${TARGET} ${OBJ}

clean:
	rm -f ../src/*.o ${TARGET}

distclean:
	rm -f ../src/*.o ${TARGET}

%.o:    %.cpp ${HEADERS}
	${CXX} ${CFLAGS} -c $< -o $@

%.o:    %.c ${HEADERS}
	${CC} ${CFLAGS} -c $< -o $@
