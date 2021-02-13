CC = gcc

CFLAGS = `sdl2-config --libs --cflags` -std=c99 -Wall --pedantic-errors

LDFLAGS = -lSDL2_image -lm

SRCS := step.c

OBJS := $(SRCS:.c=.o)

EXEC := app

all: $(EXEC)

$(EXEC): $(OBJS) Makefile
	$(CC) -o $@ $< $(CFLAGS) $(LDFLAGS)

clean:
	rm -f $(EXEC) *.o

.PHONY: all clean
