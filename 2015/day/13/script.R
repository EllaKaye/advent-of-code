library(aochelpers)
input <- aoc_input_data_frame(13, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/13")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input


# Part 1 ---------------------------------------------------------------------

library(tidyverse)

input <- aoc_input_data_frame(13, 2015)

mat <- input |> 
	mutate(X4 = if_else(X3 == "lose", X4 * -1, X4)) |> 
	select(from = X1, to = X11, gain = X4) |> 
	mutate(to = str_sub(to, end = -2)) |> 
	xtabs(gain ~ from + to, data = _)

mat + t(mat)

library(gtools)
diffs <- mat + t(mat)
n <- nrow(diffs)
arrangements <- permutations(n, n)
arrangements[2,]


#diffs[cbind(v1,v2)] |> sum() # equivalent to diffs[1, 2] + diffs[2, 3] + diffs[3, 4] + diffs[4, 1]

happiness <- function(vec, mat) {
	v1 <- vec
	v2 <- c(tail(v1, -1), v1[1])
	
	indices <- cbind(v1, v2)
	
	edges <- mat[indices] 
	
	sum(edges) # total happiness for arrangement vec
}

all_arrangement_sums <- apply(arrangements, 1, happiness, mat = diffs)

all_arrangement_sums |> max()

system.time(
	{
		arrangements <- permutations(n, n)
		
		part1 <- apply(arrangements, 1, happiness, mat = diffs) |> max()
	}
)

# 0.46 secs

# Part 2 ---------------------------------------------------------------------

diffs2 <- diffs |> cbind(0) |> rbind(0)

system.time(
	{
		arrangements_with_me <- permutations(n + 1, n + 1)
		
		apply(arrangements_with_me, 1, happiness, mat = diffs2) |> max()
	}
)


# Try not brute force - break the weakest link from part 1

# 3.6 secs

input <- aoc_input_data_frame(13, 2015, file = "example")

mat <- input |> 
	mutate(X4 = if_else(X3 == "lose", X4 * -1, X4)) |> 
	select(from = X1, to = X11, gain = X4) |> 
	mutate(to = str_sub(to, end = -2)) |> 
	xtabs(gain ~ from + to, data = _)

guests <- row.names(mat)
diffs <- mat + t(mat)
n <- nrow(diffs)
library(gtools)
arrangements <- permutations(n, n)
arrangements
which(diffs == min(diffs), arr.ind = TRUE)

# start here - much smarter break the weakest edge. both edges out of the 'me'
# node are zero. inserting 'me' between two of the other guests removes an edge.
# e.g. if the Alice - David edge has a weight of 44, then Alice - Me - David
# replaces the 44 with 0 + 0. So, to keep the sum maximal, we want to seat 'me'
# between the pair with the minimal contribution to the happiness score.

best_arrangement <- all_arrangement_sums |> which.max()

v1 <- arrangements[best_arrangement,]
v2 <- c(tail(v1, -1), v1[1])

indices <- cbind(v1, v2)

edges <- diffs[indices] 
edges

part1 - min(edges)


