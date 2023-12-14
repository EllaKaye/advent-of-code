library(aochelpers)
input <- aoc_input_matrix(11, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/11")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- c("...#......", ".......#..", "#.........", "..........", "......#...", ".#........", ".........#", "..........", ".......#..", "#...#.....")
input <- input |>
strsplit("") |>
do.call(what = rbind, args = _)

# find rows/cols that are all "."
is_empty_row <- apply(input, 1, \(x) all(x == "."))# |> which()
is_empty_col <- apply(input, 2, \(x) all(x == "."))# |> which()
empty_rows <- which(is_empty_row)
empty_cols <- which(is_empty_col)

# given a matrix and a vector of row indices, return a list of the matrix split at those rows
# Copilot wrote this, but it's wrong.
# Let's adapt
# split_rows <- function(mat, row_indices) {
# 	row_indices <- c(0, row_indices, nrow(mat) + 1)
# 	lapply(seq_along(row_indices) - 1, \(i) mat[(row_indices[i] + 1):(row_indices[i + 1] - 1), ])
# }



# my adaptation, which works

split_rows <- function(mat, indices) {
	indices <- c(0, indices, nrow(mat))
	lapply(1:(length(indices) - 1), \(i) mat[(indices[i]+1):(indices[i+1]), , drop = FALSE])
}

split_cols <- function(mat, indices) {
	indices <- c(0, indices, ncol(mat))
	lapply(1:(length(indices) - 1), \(i) mat[, (indices[i]+1):(indices[i+1]), drop = FALSE])
}



# expanded row indices: 0  4  8 10
# want to split matrix into mat[1:4, ], mat[5:8, ], mat[9:10, ]


add_empty_row <- function(mat) {
	rbind(mat, ".")
}

add_empty_rows <- function(mat, rows = 1) {
	
	extra_rows <- (matrix(".", nrow = rows, ncol = ncol(mat)))
	rbind(mat, extra_rows)
}

add_empty_col <- function(mat) {
	cbind(mat, ".")
}

add_empty_cols <- function(mat, cols = 1) {
	
	extra_cols <- (matrix(".", nrow = nrow(mat), ncol = cols))
	cbind(mat, extra_cols)
}

expanded_input_extra_col <- input |> 
	split_rows(empty_rows) |> 
	lapply(add_empty_row) |> 
	do.call(what = rbind, args = _) |> 
	head(-1) |> 
	split_cols(empty_cols) |> 
	lapply(add_empty_col) |>
	do.call(what = cbind, args = _)

expanded_input <- expanded_input_extra_col[, -ncol(expanded_input_extra_col)]
expanded_input

galaxies <- which(expanded_input == "#", arr.ind = TRUE)

eg <- expand.grid(1:nrow(galaxies), 1:nrow(galaxies))
pairs <- eg[eg$Var1 < eg$Var2, ] 
colnames(pairs) <- c("galaxy1", "galaxy2")
pairs

total <- 0

for (i in 1:nrow(pairs)) {
	g1 <- pairs[i, "galaxy1"]
	g2 <- pairs[i, "galaxy2"]
	
	g1_coords <- galaxies[g1, ]
	g2_coords <- galaxies[g2, ]
	
	shortest_dist <- sum(abs(g1_coords - g2_coords))
	total <- total + shortest_dist
}
total
# 9536038
# A bit slow with the for loop


# Part 1 ---------------------------------------------------------------------



# Part 2 ---------------------------------------------------------------------
# expanded_input_extra_cols <- input |> 
# 	split_rows(empty_rows) |> 
# 	lapply(\(x) add_empty_rows(x, 2)) |> 
# 	do.call(what = rbind, args = _) |> 
# 	head(-2) |> 
# 	split_cols(empty_cols) |> 
# 	lapply(\(x) add_empty_cols(x, 2)) |>
# 	do.call(what = cbind, args = _)
# 
# expanded_input_extra_cols
# actual_cols <- head(seq_len(ncol(expanded_input_extra_cols)), -2)
# actual_cols
# expanded_input <- expanded_input_extra_cols[, actual_cols] 

input <- aoc_input_matrix(11, 2023) # uncomment at end, once correct on test input

# input <- c("...#......", ".......#..", "#.........", "..........", "......#...", ".#........", ".........#", "..........", ".......#..", "#...#.....")
# input <- input |>
# 	strsplit("") |>
# 	do.call(what = rbind, args = _)
is_empty_row <- apply(input, 1, \(x) all(x == "."))# |> which()
is_empty_col <- apply(input, 2, \(x) all(x == "."))# |> which()
empty_rows <- which(is_empty_row)
empty_cols <- which(is_empty_col)


expand_input <- function(input, expansion) {
	expanded_input_extra_cols <- input |> 
		split_rows(empty_rows) |> 
		lapply(\(x) add_empty_rows(x, expansion)) |> 
		do.call(what = rbind, args = _) |> 
		head(-expansion) |> 
		split_cols(empty_cols) |> 
		lapply(\(x) add_empty_cols(x, expansion)) |>
		do.call(what = cbind, args = _)
	
	expanded_input_extra_cols
	actual_cols <- head(seq_len(ncol(expanded_input_extra_cols)), -expansion)
	actual_cols
	expanded_input <- expanded_input_extra_cols[, actual_cols] 	
	expanded_input
}

#expanded_input <- expand_input(input, 999999) # too big!
expanded_input

galaxies <- which(expanded_input == "#", arr.ind = TRUE)

eg <- expand.grid(1:nrow(galaxies), 1:nrow(galaxies))
pairs <- eg[eg$Var1 < eg$Var2, ] 
colnames(pairs) <- c("galaxy1", "galaxy2")
pairs

total <- 0

for (i in 1:nrow(pairs)) {
	g1 <- pairs[i, "galaxy1"]
	g2 <- pairs[i, "galaxy2"]
	
	g1_coords <- galaxies[g1, ]
	g2_coords <- galaxies[g2, ]
	
	shortest_dist <- sum(abs(g1_coords - g2_coords))
	total <- total + shortest_dist
}
total

# Need a new approach.
# The expanded matrix is too big.

# Work with the original matrix, find the shortest path, 
# then adjust accordingly depending on how many empty rows and columns the path crosses.
# input <- aoc_input_matrix(11, 2023) 
input <- c("...#......", ".......#..", 
					 "#.........", "..........", 
					 "......#...", ".#........", 
					 ".........#", "..........", 
					 ".......#..", "#...#.....") |>
	strsplit("") |>
	do.call(what = rbind, args = _)

# calculate the distance between two galaxies
# g1 is a vector of coordinates (row, col) for galaxy 1 and similar for g2.
# galaxy_distance <- function(g1, g2) {
# 	sum(abs(g1 - g2))
# }

galaxy_distances <- function(input, expand = 2) {
	# find rows/cols that are all "."
	empty_rows <- apply(input, 1, \(x) all(x == ".")) |> which()
	empty_cols <- apply(input, 2, \(x) all(x == ".")) |> which()
	
	# co-ordinates of the galaxies
	galaxies <- which(input == "#", arr.ind = TRUE)
	
	# all pairs of galaxies, by id 
	eg <- expand.grid(1:nrow(galaxies), 1:nrow(galaxies))
	pairs <- eg[eg$Var1 < eg$Var2, ] 
	colnames(pairs) <- c("galaxy1", "galaxy2")
	
	apply(pairs, 1, \(x) {
		# x is a row of pairs, as a vector
		# get the distance in the original grid
		
		galaxy_pair <- galaxies[x, ]
		galaxy_dist <- dist(galaxy_pair, "manhattan")
		
		# how many empty rows/cols between galaxies?
		g_rows <- galaxy_pair[,1]
		empty_rows_crossed <- sum(g_rows[1]:g_rows[2] %in% empty_rows)
		g_cols <- galaxy_pair[,2]
		empty_cols_crossed <- sum(g_cols[1]:g_cols[2] %in% empty_cols)
		
		galaxy_dist + empty_rows_crossed*(expand-1) + empty_cols_crossed*(expand-1)
	}) |> 
		sum()
	
}

input <- aoc_input_matrix(11, 2023)
system.time(galaxy_distances(input, 1000000)) # 1.4 secs elapsed
system.time(galaxy_distances(input, 2)) # 1.3 secs
# Part 1 original: 0.97

galaxy_distances(input, 100) 

#galaxies[c(1,3),] |> dist("manhattan")

tg <- galaxies[c(1,6),]
tg |> dist("manhattan")

# row indicies
g_rows <- tg[,1]
empty_rows_crossed <- sum(g_rows[1]:g_rows[2] %in% empty_rows)

# gets distance in non-expanded grid
# apply(pairs, 1, \(x) sum(abs(galaxies[x[1], ] - galaxies[x[2], ])))


# need a function that takes a pair of galaxies from pairs and returns the shortest distance between 
# the galaxies at those pairs, taking into account the empty rows and columns

