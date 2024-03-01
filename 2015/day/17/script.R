library(aochelpers)
input <- aoc_input_vector(17, 2015, mode = "numeric") # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/17")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input


# Part 1 ---------------------------------------------------------------------

# get all subsets
#input <- vec <- c(1, 2, 2)
# BRUTE FORCE. USE A BETTER ALGORITHM FOR C!
input
system.time(
	{
		all_subsets <- lapply(1:length(input), function(x) combn(input, x, simplify = FALSE))
		all_subsets <- unlist(all_subsets, recursive = FALSE)
		all_container_sums <- all_subsets |> sapply(sum)
		sum(all_container_sums == 150)		
	}
)



# Part 2 ---------------------------------------------------------------------
fits_150 <- which(all_container_sums == 150) 
fits_150_containers <- all_subsets[fits_150] 
min_containers <- lengths(fits_150_containers) |> min()

(lengths(fits_150_containers) == min_containers) |> sum()
