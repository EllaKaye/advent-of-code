CC = clang
CFLAGS = -Wall -Wextra -std=c11 -g -pedantic

SRCS = $(wildcard *.c)
BINS = $(SRCS:.c=)

%: %.c
	$(CC) $(CFLAGS) -o $@ $<
	
clean:
	rm -rf $(addsuffix .dSYM, $(BINS))
