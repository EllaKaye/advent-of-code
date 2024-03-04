library(aochelpers)
input <- aoc_input_data_frame(9, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/9")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- tibble(X1 = c("London", "London", "Dublin"), 
								X3 = c("Dublin", "Belfast", "Belfast"), 
								X5 = c(464, 518, 141))

# Part 1 ---------------------------------------------------------------------
library(dplyr)
initial_paths <- input |> 
	select(from = X1, to = X3, dist = X5)

other_paths <- input |> 
	select(to = X1, from = X3, dist = X5)

paths <- bind_rows(initial_paths, other_paths)

paths |> arrange(from) |> View()

locations <- c(paths$from) |> unique()
n_locations <-  length(locations)

# visited <- numeric(n_locations)

visited <- numeric()
min_dist <- paths |> 
	filter(dist == min(dist)) |> 
	slice(1)
visited <- c(visited, min_dist$from)
distance <- min_dist$dist

while (length(visited) < n_locations - 1) {
	min_dist <- paths |> 
		filter(from == min_dist$to) |> 
		filter(!(to %in% visited)) |> 
		filter(dist == min(dist)) 

	visited <- c(visited, min_dist$from)
	
	distance <- distance + min_dist$dist
	print(distance)
}

#distance <- distance + min_dist$dist
distance
# this is NOT the right algorithm
# possibly need the Held-Karp algorithm
# https://en.wikipedia.org/wiki/Held–Karp_algorithm

# or is it the right algorithm for the shortest path from a given node
# then need to check over all start nodes?

from_loc <- "AlphaCentauri"

# slightly better
shortest_path_from <- function(from_loc) {
	
	visited <- character(n_locations - 1)
	visited[1] <- from_loc
	min_dist <- paths |> 
		filter(from == from_loc) |> 
		filter(dist == min(dist)) 
	distance <- min_dist$dist
	
	for (i in 2:(n_locations - 1)) {
		min_dist <- paths |> 
			filter(from == min_dist$to) |> 
			filter(!(to %in% visited)) |> 
			filter(dist == min(dist)) 
		
		from_loc <- min_dist$to
		visited[i] <- min_dist$from
		distance <- distance + min_dist$dist
		#print(distance)
	}
	distance
}

shortest_path_from("AlphaCentauri")
locations |> sapply(shortest_path_from) |> min()

# solution
system.time(
	{
		locations |> sapply(shortest_path_from) |> min()
	}
)

# matrix version
dist_mat <- xtabs(dist ~ from + to, paths)

from_loc <- "AlphaCentauri"

shortest_path_from_matrix <- function(from_loc) {
	
	visited <- character(n_locations - 1)
	distance <- 0
	
	for (i in 1:(n_locations - 1)) {
		visited[i] <- from_loc
		possible_next <- dist_mat[from_loc, !(colnames(dist_mat) %in% visited)]
		next_location <- possible_next[which.min(possible_next)]
		distance <- distance + as.numeric(next_location) # keeps name with value (unlike min)
		from_loc <- names(next_location)
		#print(from_loc, as.numeric(distance))
	}
	distance
}

shortest_path_from_matrix("AlphaCentauri")

locations |> sapply(shortest_path_from_matrix) |> min()

system.time(
	{
		locations |> sapply(shortest_path_from_matrix) |> min()
	}
)

# Part 2 ---------------------------------------------------------------------

# longest path

longest_path_from_matrix <- function(from_loc) {
	
	visited <- character(n_locations - 1)
	distance <- 0
	
	for (i in 1:(n_locations - 1)) {
		visited[i] <- from_loc
		possible_next <- dist_mat[from_loc, !(colnames(dist_mat) %in% visited)]
		next_location <- possible_next[which.max(possible_next)]
		distance <- distance + as.numeric(next_location) # keeps name with value (unlike min)
		from_loc <- names(next_location)
		#print(from_loc, as.numeric(distance))
	}
	distance
}

longest_path_from_matrix("AlphaCentauri")

locations |> sapply(longest_path_from_matrix) |> max()
