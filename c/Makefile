CC := clang

CFLAGS := `sdl2-config --libs --cflags` -ggdb3 -O0 --std=c99 -Wall -lSDL2_image -lm

HDRS :=

SRCS := step.c

OBJS := $(SRCS:.c=.o)

EXEC := app

all: $(EXEC)

$(EXEC): $(OBJS) $(HDRS) Makefile
	$(CC) -o $@ $(OBJS) $(CFLAGS)

clean:
	rm -f $(EXEC) *.o

.PHONY: all clean
