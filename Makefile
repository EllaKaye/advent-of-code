CC = clang
CFLAGS = -Wall -Wextra -std=c11 -pedantic $(shell pkg-config --cflags glib-2.0)# -g
# LIBS = $(filter-out $@,$(MAKECMDGOALS))
LIBS = $(shell pkg-config --libs glib-2.0)

SRCS = $(wildcard *.c)
BINS = $(SRCS:.c=)

%: %.c
	$(CC) $(CFLAGS) -o $@ $< $(LIBS)

%:
	@true

.PHONY: clean

clean:
	rm -f $(BINS)
	rm -rf $(addsuffix .dSYM)
	# rm -rf $(addsuffix .dSYM, $(BINS))
