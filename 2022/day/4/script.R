library(aochelpers)
input <- aoc_input_vector(4, 2022) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2022/day/4")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <- c("2-4,6-8", "2-3,4-5", "5-7,7-9", "2-8,3-7", "6-6,4-6", "2-6,4-8")


# Part 1 ---------------------------------------------------------------------

pair <- input[1]

all_ints <- strsplit(input, "\\D")

pair_ints <- all_ints[[1]]

range_contain <- function(ints) {
	all(ints[1]:ints[2] %in% ints[3]:ints[4]) || all(ints[3]:ints[4] %in% ints[1]:ints[2])
}

range_contain(pair_ints)

sapply(all_ints, range_contain) |> sum()

# Part 2 ---------------------------------------------------------------------

range_overlap <- function(ints) {
	any(ints[1]:ints[2] %in% ints[3]:ints[4])
}

sapply(all_ints, range_overlap) |> sum()

