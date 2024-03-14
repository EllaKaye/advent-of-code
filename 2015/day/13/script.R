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

# optimal_happiness <- function(mat) {
# 	
# 	people <- row.names(mat)
# 	n <- length(people)
# 	
# 	seated <- character(n - 1)
# 	
# 	diffs <- mat + t(mat)
# 	max_net_happiness <- max(diffs)
# 	max_pair <- which(diffs == max(diffs), arr.ind = TRUE) |> row.names()
# 	happiness <- max_net_happiness
# 	
# 	seated[1:2] <- max_pair
# 	last_seated <- seated[2]
# 	
# 	for (i in 3:(n - 1)) {
# 		seated[i + 1] <- last_seated
# 		possible_next <- diffs[last_seated, !(people %in% seated)]
# 		next_seated <- possible_next[which.max(possible_next)] # keeps name with value (unlike max)
# 		happiness <- happiness + as.numeric(next_seated) 
# 		last_seated <- names(next_seated)
# 		#print(from_loc, as.numeric(distance))
# 	}
# 	happiness
# }

# guests <- row.names(mat)
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

apply(arrangements, 1, happiness, mat = diffs) |> max()

# Part 2 ---------------------------------------------------------------------

diffs2 <- diffs |> cbind(0) |> rbind(0)

arrangements_with_me <- permutations(n + 1, n + 1)

apply(arrangements_with_me, 1, happiness, mat = diffs2) |> max()
