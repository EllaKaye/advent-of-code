library(aochelpers)
# input <- aoc_input_vector(1, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/1")

# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- c("1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet")
test <- "treb7uchet"
# Part 1 ---------------------------------------------------------------------

get_value <- function(x) {
	x <- strsplit(x, "") |> unlist()
	x_nums <- x[x %in% 1:9]
	paste0(head(x_nums, 1), tail(x_nums, 1)) |> as.numeric()
}

sapply(input, get_value) |> sum()

# Part 2 ---------------------------------------------------------------------

library(stringr)
input <- c("two1nine", "eightwothree", "abcone2threexyz", "xtwone3four", "4nineeightseven2", "zoneight234", "7pqrstsixteen")

nums <- c("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")
nums_pattern <- paste(nums, collapse = "|")
nums_digit_pattern <- paste0(nums_pattern, "|\\d")
# str_extract_all doesn't work with overlapping text
#str_extract_all(input[2], nums_pattern) 

str_extract()


str_extract(input[1], nums_digit_pattern) # want "two"
str_extract(input[2], nums_digit_pattern) # want "eight"
str_extract(input[3], nums_digit_pattern) # want "one"
str_extract(input[4], nums_digit_pattern) # want "two"
str_extract(input[5], nums_digit_pattern) # want "4"
str_extract(input[6], nums_digit_pattern) # want "one"
str_extract(input[7], nums_digit_pattern) # want "7"
# that works


match("two", nums)


nums <- c("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")
nums_pattern <- paste(nums, collapse = "|")
nums_digit_pattern <- paste0(nums_pattern, "|\\d")

# getting last digit is same as gettern first digit of reversed string


string_reverse <- function(x) {
	strsplit(x, "") |> unlist() |> rev() |> paste0(collapse = "")
}

nums_pattern_rev <- string_reverse(nums_pattern)
nums_digit_pattern_rev <- paste0(nums_pattern_rev, "|\\d")
nums_digit_pattern_rev


get_last_digit <- function(x) {
	str_extract(string_reverse(x), nums_digit_pattern_rev) |> string_reverse() 
}

sapply(input, get_last_digit) # yes!

convert_to_digit <- function(x) {
	if (nchar(x) == 1) {
		x <- as.numeric(x)
	} else {
		x <- match(x, nums)
	}
	x
}

convert_to_digit("nine")
convert_to_digit("2")

get_value2 <- function(x) {

	first <- str_extract(x, nums_digit_pattern)
	
	last <- get_last_digit(x)
	
	first_digit <- convert_to_digit(first)
	last_digit <- convert_to_digit(last)
	
	10*first_digit + last_digit
}

sapply(input, get_value2) |> sum()

