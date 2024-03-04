library(aochelpers)
input <- aoc_input_vector(10, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/10")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

digits <- input |> strsplit("") |> unlist() |> as.numeric()

rle(digits)

rle_digits <- rle(c(1,1))
c(rle_digits$lengths, rle_digits$values)
rle(c(2,1))

digits <- 1

for (i in 1:5) {
	rle_digits <- rle(digits)
	digits <- c(rle_digits$values, rle_digits$lengths)
	print(digits)
}
digits

# not quite. 
# Need 1st element of lengths, then 1st element of values, 
# then 2nd of length, 2nd of values etc
digits <- input |> strsplit("") |> unlist() |> as.numeric()


# Part 1 ---------------------------------------------------------------------
digits <- input |> strsplit("") |> unlist() |> as.numeric()


for (i in 1:40) {
	rle_digits <- rle(digits)
	vals <- rle_digits$values
	lens <- rle_digits$lengths
	n <- 2 * length(vals)
	digits <- numeric(n)
	digits[seq(1, n, by = 2)] <- lens
	digits[seq(2, n, by = 2)] <- vals
	
	# digits <- c(rle_digits$values, rle_digits$lengths)
	#print(digits)
}
length(digits)

# Part 2 ---------------------------------------------------------------------

for (i in 1:50) {
	rle_digits <- rle(digits)
	vals <- rle_digits$values
	lens <- rle_digits$lengths
	n <- 2 * length(vals)
	digits <- numeric(n)
	digits[seq(1, n, by = 2)] <- lens
	digits[seq(2, n, by = 2)] <- vals
	
	# digits <- c(rle_digits$values, rle_digits$lengths)
	#print(digits)
}
length(digits)