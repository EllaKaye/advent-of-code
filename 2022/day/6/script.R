library(aochelpers)
input <- aoc_input_vector(6, 2022) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2022/day/6")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

#input <- "mjqjpqmgbljsphdztnvjfqwrcgsmlb"

# Part 1 ---------------------------------------------------------------------

data <- strsplit(input, "") |> unlist() 


for (i in 4:length(data)) {
	
	last_4 <- data[(i-3):i]
	last_4_unique <- last_4 |> unique() |> length()
	
	if (last_4_unique == 4) {
		break
	}
}
i

# Part 2 ---------------------------------------------------------------------

for (i in 14:length(data)) {
	
	last_14 <- data[(i-13):i]
	last_14_unique <- last_14 |> unique() |> length()
	
	if (last_14_unique == 14) {
		break
	}
}
i
