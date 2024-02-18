Trying to figure out the best way to `make` the C files.

Option 1:

-   Have a `Makefile` in the post template and `cd` into the directory and run `make part1` etc.

Option 2:

-   Have a global `Makefile` in the root directory.

-   At the beginning of each session, for the appropriate year, `YYYY` and day, `DD`, set

    `export DAY="$HOME/Rprojs/mine/advent-of-code/YYYY/day/DD"`

-   Then, from project root, run, e.g. `make $DAY/part1` to compile and run the program with `$DAY/part1 $DAY/input`

-   Would need to update the global `Makefile` to clean the `dSYM` files in `$DAY`.

-   Could also update `aoc_new_day()` and `part1.c` template so that the default input file is not just `input`, but `path/to/input` from the root.
