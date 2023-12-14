library(aochelpers)
# input <- aoc_input_vector(14, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/14")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- c("O....#....", "O.OO#....#", ".....##...", "OO.#O....O", ".O.....O#.", "O.#..O.#.#", "..O..#O..O", ".......O..", "#....###..", "#OO..#....")
mat <- input |> 
	strsplit("") |> 
	do.call(rbind, args = _)
mat

# Approach, split, sort, combine. 
# Function per column.
# Not sure if better to work N-S or to reverse matrix and think S-N.
# Latter may be better for indexing. 
# Not sure which better for splitting/sorting.
# Let's experiment

symbs <- c(".", "O", "#")
sort(symbs) # "." "#" "O"

# Part 1 ---------------------------------------------------------------------
# for c3 want
# ..OO#....O
c3 <- mat[,3]
c3 

c3f <- factor(c3, levels = c(".", "O", "#"))

sorted <- c3f |>
	rev() |> 
	split(cumsum(c3f == "#")) |> 
	lapply(sort) |> 
	do.call(c, args = _) 

which(sorted == "O")

# That's it. Wrap as function.

tilt_north <- function(col) {
	sorted <- col |> 
#	col |> 
		factor(levels = c(".", "O", "#")) |> 
		rev() |> 
		split(cumsum(rev(col) == "#")) |> 
		lapply(sort) |> 
		do.call(c, args = _) 
	
	which(sorted == "O") |> sum()
		
}

apply(mat, 2, tilt_north) |> 
	sum()
# not quite

# inspect by column
tilt_north(mat[,8]) 
# wrong for 1, 4, 5, 6, 8
# right for 2, 3, 7

# Let's try with c8
c8 <- mat[,8]
c8 |> 
	factor(levels = c("#", ".", "O")) |> 
	rev() |> 
	split(cumsum(rev(c8) == "#")) |> 
	lapply(sort) |> 
	do.call(c, args = _) 

# try again
tilt_north <- function(col) {
	sorted <- col |> 
		factor(levels = c("#", ".", "O")) |> 
		rev() |> 
		split(cumsum(rev(col) == "#")) |> 
		lapply(sort) |> 
		do.call(c, args = _) 
	
	which(sorted == "O") |> sum()
	
}

apply(mat, 2, tilt_north) |> 
	sum()
# Yes! 

# refactor for reversed matrix
mat_rev <- mat[nrow(mat):1,]
mat_rev

tilt <- function(col) {
	sorted <- col |> 
		factor(levels = c("#", ".", "O")) |> 
		split(cumsum(col == "#")) |> 
		lapply(sort) |> 
		do.call(c, args = _) 
	
	which(sorted == "O") |> sum()
	
}

tilt(rev(c8))
apply(mat_rev, 2, tilt) |> sum()

# now with input
input <- aoc_input_matrix(14, 2023) 
input_rev <- input[nrow(input):1,]

apply(input_rev, 2, tilt) |> 
	sum()
#105461

# Part 2 ---------------------------------------------------------------------
