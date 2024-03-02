library(aochelpers)
input <- aoc_input_vector(8, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/8")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- aoc_input_vector(8, 2015, "example")

# Part 1 ---------------------------------------------------------------------
num_chars_code <- input |> nchar() |> sum() # total number of characters of code
num_chars_code

# to get total number of chars in memory:
# start & end quotes - subtract two from num_chars
# \\
# \" - need four \ to match one! https://stringr.tidyverse.org/articles/regular-expressions.html#escaping
# \xXX where XX are two hexadecimal chars
# each of these represent one character in memory
# in the regex, need to escape all special symbols
chars_memory <- input |> 
	gsub('\\\\"', "X", x = _) |> 
	gsub("\\\\\\\\", "Y", x = _) |> 
	gsub("\\\\x[0-9a-f]{2}", "Z", x = _) |> 
	nchar() - 2

num_chars_memory <- sum(chars_memory)

num_chars_code - num_chars_memory

# Part 2 ---------------------------------------------------------------------

# don't need to handle \xhh case differently, as taken care of with \
chars_encoded <- input |> 
	gsub('"', 'XX', x = _) |> 
	gsub('\\\\', 'YY', x = _) |> 
	nchar() + 2
num_chars_encoded <- sum(chars_encoded)

num_chars_encoded - num_chars_code
