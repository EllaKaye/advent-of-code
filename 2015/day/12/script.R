library(aochelpers)
input <- aoc_input_vector(12, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/12")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <- 

# Part 1 ---------------------------------------------------------------------
# Solution 1
input |> extract_numbers() |> sum()

library(jsonlite)
library(stringr)
library(purrr)

# solution 2
char_vec <- input |> parse_json() |> unlist() 
char_vec[str_detect(char_vec, "\\d")] |> as.numeric() |> sum()

# sum_list <- function(lst) {
# 	lst <- keep(lst, str_detect(lst, "//d"))
# 	unlist(lst) |> as.numeric() |> sum()
# }
# 
# input |> parse_json() |> modify_depth(1, sum_list)

# solution 3
strings_to_zero <- function(leaf) {
	if (is.character(leaf)) {
		return(0)
	} else {
		return(leaf)
	}
}

input |> 
	parse_json() |> 
	modify_tree(leaf = strings_to_zero) |> 
	unlist() |> 
	sum()

# Part 2 ---------------------------------------------------------------------

library(jsonlite)
library(tidyverse)
json <- parse_json(input)

# examples
example1 <- parse_json('[1,2,3]') # sum 6
str(example1)
names(example1) # NULL
example1 |> unlist() |> sum()

example2 <- parse_json('[1,{"c":"red","b":2},3]') # sum 4 - ignore middle array
str(example2)
names(example2) # NULL
example2 |> unlist() # no - collapses everything
example2 |> unlist(recursive = FALSE) # no - object is still split
example2

example3 <- parse_json('{"d":"red","e":[1,2,3,4],"f":5}') # sum 0 - ignore entire structure
str(example3)
names(example3) # "d" "e" "f"
example4 <- parse_json('[1,"red",5]') # sum 6 - red in array has no effect
str(example4)
names(example4) # NULL
# can tell difference between arrays and objects 
# because objects have names and arrays do not
# an object parses to a named list, where the key is the name, and the value is the value
# an array parses to an unnamed list, with one element for each item

# maybe need a recursive function?

df1 <- tibble(json = example1)
df1 |> unnest_longer(json) 

df2 <- tibble(json = example2)
df2
#df2 |> unnest_wider(json) # error
#df2 |> unnest_longer(json) # error
# working with nested tibbles not the way to go here
example2 |> sapply(class)

example1
example2
example3
example4

example1 |> 
	sapply(is.list) |> 
	any()

example2 |> 
	sapply(is.list) 

example3 |> 
	sapply(is.list) 

example4 |> 
	sapply(is.list) 

"red" %in% example2[[2]] # true
has_element(example2, "red") # FALSE
has_element(example2[[2]], "red") # TRUE

# from purrr, keep/discard could come in handy
# 
example4 |> keep(is.numeric) # yes!

has_red <- function(lst) {
	has_element(lst, "red")
}

has_red(example3)

example2
example2 |> sapply(has_red)

remove_red <- function(lst) {
	if (has_element(lst, "red") && !is.null(names(lst))) {
		return(0)
	}
	return(lst)
}

example2 |> sapply(remove_red)

example4 |> modify_tree(pre = remove_red)

# solution (with remove_red)
no_red <- input |> parse_json() |> modify_tree(pre = remove_red) |> unlist() 
no_red[str_detect(no_red, "\\d")] |> as.numeric() |> sum()

# solution (with remove_red and strings_to_zero)
# better!
input |> 
	parse_json() |> 
	modify_tree(leaf = strings_to_zero, pre = remove_red) |> 
	unlist() |> 
	sum()

