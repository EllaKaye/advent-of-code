library(aochelpers)
input <- aoc_input_vector(9, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE
input

browseURL("https://adventofcode.com/2023/day/9")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- c("0 3 6 9 12 15", "1 3 6 10 15 21", "10 13 16 21 30 45")
i1 <- input[1]
i3 <- input[3] # from full, has negative numbers
i3 <- input[3] # from full, has negative numbers

# Part 1 ---------------------------------------------------------------------

# works for no negatives
split_numeric <- function(seq) {
	strsplit(seq, " ") |> unlist() |> as.numeric() 
}

# works for negatives - phew!
i3_num <- strsplit(i3, " ") |> unlist() |> as.numeric() 

x <- i1 |> split_numeric() 

predict_oasis <- function(x) {
	
	prediction <- tail(x, 1)
	
	#while(sum(x) != 0) {
	while(!all(x == 0)) {
		x <- diff(x)
		prediction <- prediction + tail(x, 1)
	}
	prediction
}
predict_oasis(x)

input |> 
	lapply(split_numeric) |> 
	sapply(predict_oasis) |> 
	sum()
# works on example input, not on full input, answer is too high
# 1904165829
# 1904165718


# Part 2 ---------------------------------------------------------------------

# predict_oasis_back <- function(x) {
# 	
# 	prediction <- tail(x, 1)
# 	
# 	#while(sum(x) != 0) {
# 	while(!all(x == 0)) {
# 		x <- diff(x)
# 		prediction <- prediction + tail(x, 1)
# 	}
# 	prediction
# }

input |> 
	lapply(split_numeric) |> 
	lapply(rev) |> 
	sapply(predict_oasis) |> 
	sum()
