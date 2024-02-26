CC = clang
CFLAGS = -Wall -Wextra -std=c11 -pedantic # -g
LIBS = $(filter-out $@,$(MAKECMDGOALS))

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
