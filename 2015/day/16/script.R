library(aochelpers)
library(tidyverse)
input <- aoc_input_vector(16, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/16")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# Part 1 ---------------------------------------------------------------------

sues <- tibble(X = input) |> 
	separate_wider_regex(X, c("Sue ", sue = "\\d+", ": ", info = ".*")) |> 
	separate_longer_delim(info, ",") |> 
	separate_wider_delim(info, ":", names = c("item", "n")) |> 
	mutate(sue = as.numeric(sue),
				 item = str_trim(item),
				 n = as.numeric(n)) |> 
	pivot_wider(names_from = item, values_from = n)


sues

sues |> 
	filter(children == 3 | is.na(children)) |> 
	filter(cats == 7 | is.na(cats)) |> 
	filter(samoyeds == 2 | is.na(samoyeds)) |> 
	filter(pomeranians == 3 | is.na(pomeranians)) |> 
	filter(akitas == 0 | is.na(akitas)) |> 
	filter(vizslas == 0 | is.na(vizslas)) |> 
	filter(goldfish == 5 | is.na(goldfish)) |> 
	filter(trees == 3 | is.na(trees)) |> 
	filter(cars == 2 | is.na(cars)) |> 
	filter(perfumes == 1 | is.na(perfumes)) |> 
	pull(sue)

# Part 2 ---------------------------------------------------------------------

sues |> 
	filter(children == 3 | is.na(children)) |> 
	filter(cats > 7 | is.na(cats)) |> 
	filter(samoyeds == 2 | is.na(samoyeds)) |> 
	filter(pomeranians < 3 | is.na(pomeranians)) |> 
	filter(akitas == 0 | is.na(akitas)) |> 
	filter(vizslas == 0 | is.na(vizslas)) |> 
	filter(goldfish < 5 | is.na(goldfish)) |> 
	filter(trees > 3 | is.na(trees)) |> 
	filter(cars == 2 | is.na(cars)) |> 
	filter(perfumes == 1 | is.na(perfumes)) |> 
	pull(sue)



