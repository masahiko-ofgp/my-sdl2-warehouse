SRCS := step1.nim

EXEC := app

all: $(EXEC)

$(EXEC): Makefile
	nim c --warnings:on --debugger:native -o:$@ $(SRCS)

clean:
	rm -f $(EXEC)

.PHONY: all clean
