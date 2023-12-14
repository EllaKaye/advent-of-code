library(aochelpers)
input <- aoc_input_vector(13, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/13")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input


# Part 1 ---------------------------------------------------------------------

# test
#input <- readLines(here::here("2023", "day", "13", "example")) 
input

lines_as_matrix <- function(lines) {
	strsplit(lines, "") |> do.call(rbind, args = _)
}
	
# split input at blank lines
matrix_list <- input |> 
	split(cumsum(input == "")) |> 
	lapply(\(x) x[x != ""]) |> 
	lapply(lines_as_matrix)

m1 <-  matrix_list[[1]]
m2 <-  matrix_list[[2]]
mat <- m1

col_reflection <- function(mat) {
	
	nc <- ncol(mat)
	
	# iterate over columns to the left
	for (i in 1:(nc-1)) {
		if (i <= nc/2) {
			left_mat <- mat[, 1:i]
			right_mat <- mat[, (2 * i):(i + 1)]
		} else {
			left_mat <- mat[,(2 * i - nc + 1):i]
			right_mat <- mat[, nc:(i + 1)]
		}
		
		compare <- identical(left_mat, right_mat)
		
		if (compare) {
			return(i)
		}
	}
	
	return(0)
}

row_reflection <- function(mat) {
	
	nr <- nrow(mat)
	
	# iterate over rows above
	for (i in 1:(nr-1)) {
		if (i <= nr/2) {
			above_mat <- mat[1:i, ]
			below_mat <- mat[(2 * i):(i + 1), ]
		} else {
			above_mat <- mat[(2 * i - nr + 1):i, ]
			below_mat <- mat[nr:(i + 1), ]
		}
		
		compare <- identical(above_mat, below_mat)
		
		if (compare) {
			return(100 * i)
		}
	}
	
	return(0)
}



col_reflection(m1)
col_reflection(m2)
row_reflection(m1)
row_reflection(m2)

reflection <- function(mat) {
	
	row_mirror <- row_reflection(mat)
	
	if (row_mirror > 0) {
		return(row_mirror)
	} else {
		col_reflection(mat)
	}
	
}

reflection(m1)
reflection(m2)

sapply(matrix_list, reflection) |> sum()

# Part 2 ---------------------------------------------------------------------

# want the matrices to be the identical in all but one place,
# so different in exactly one place 

col_reflection <- function(mat) {
	
	nc <- ncol(mat)
	
	# iterate over columns to the left
	for (i in 1:(nc-1)) {
		if (i <= nc/2) {
			left_mat <- mat[, 1:i]
			right_mat <- mat[, (2 * i):(i + 1)]
		} else {
			left_mat <- mat[,(2 * i - nc + 1):i]
			right_mat <- mat[, nc:(i + 1)]
		}
		
		compare <- sum(left_mat != right_mat)
		
		if (compare == 1) {
			return(i)
		}
	}
	
	return(0)
}

row_reflection <- function(mat) {
	
	nr <- nrow(mat)
	
	# iterate over rows above
	for (i in 1:(nr-1)) {
		if (i <= nr/2) {
			above_mat <- mat[1:i, ]
			below_mat <- mat[(2 * i):(i + 1), ]
		} else {
			above_mat <- mat[(2 * i - nr + 1):i, ]
			below_mat <- mat[nr:(i + 1), ]
		}
		
		compare <- sum(above_mat != below_mat)
		
		if (compare == 1) {
			return(100 * i)
		}
	}
	
	return(0)
}

sapply(matrix_list, reflection) |> sum()
