# get current year
current_year <- function() {
	as.character(format(Sys.Date(), "%Y"))
}

# get the input path given day and year
aoc_input_path <- function(day, year = NULL) {
	if (is.null(year)) year <- current_year()
	here::here("input", year, paste0("day", day, ".txt"))
}

# input <- c("123", "456", "789", "123")
# write a function that takes input as its argument and returns a matrix
# where each element is the corresponding digit from the input
# and the number of rows in the length of input
# e.g. for input = c("123", "456", "789", "123") the output should be matrix(c(1,2,3,4,5,6,7,8,9,1,2,3), nrow = 4, byrow = TRUE)	
# your function should work for inputs of arbitrary length
# hint: use strsplit() in your function
# hint: you can use the unlist() function to convert a list to a vector
# hint: you can assume that all elements of input have the same length
# hint: you can use the matrix() function to create a matrix from a vector
# hint: you can use the nrow and byrow arguments to matrix() to specify the number of rows and whether to fill the matrix by rows or columns
input_as_matrix <- function(input) {
  matrix(unlist(strsplit(input, split = "")), nrow = length(input), byrow = TRUE)
}
# note: GitHub copilot wrote this function for me.
# I provided input and the first three comments,
# then it wrote the rest of the comments.
# I then gave it the function name and <- and it wrote the rest of the code.

aoc_read_input <- function(day, year = NULL, 
													 as = c("vector", "tibble", "data.frame", "matrix"),
													 numeric = FALSE) {
  
	as <- match.arg(as)
	
	path <- aoc_input_path(day, year)
	
	# read in path, switch between cases in as
	input <- switch(as,
				 vector = {
					 # read the input file as a vector of strings
					 readr::read_lines(path)
				 },
				 tibble = {
					 # read the input file as a tibble
					 readr::read_tsv(path, col_names = FALSE)
				 },
				 data.frame = {
					 # read the input file as a data frame
					 read.table(path)
					 # if numeric is TRUE, convert the vector to numeric

				 },
				 matrix = {
					 # read the input file as a vector of strings
				 	 # then convert to matrix
					 readr::read_lines(path) |> input_as_matrix()
				 }
	)
	
	if (numeric) {
		input <- as.numeric(input)
	}
	
	input
	
}
