library(aochelpers)
input <- aoc_input_vector(2, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/2")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <- 

# Part 1 ---------------------------------------------------------------------
wrapping <- function(dims) {
	l <- dims[1]
	w <- dims[2]
	h <- dims[3]
	2 * (l*w + w*h + h*l) + min(l*w, w*h, h*l)
}

input |> 
	lapply(extract_numbers) |> 
	sapply(wrapping) |> 
	sum()
	

# Part 2 ---------------------------------------------------------------------

ribbon <- function(dims) {
	sorted <- sort(dims)
	2 * (sum(sorted[1:2])) + prod(dims)
}
	
input |> 
	lapply(extract_numbers) |> 
	sapply(ribbon) |> 
	sum()
	