library(aochelpers)
input <- aoc_input_vector(3, 2022) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2022/day/3")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <- c("vJrwpWtwJgWrhcsFMMfFFhFp", "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL", "PmmdzqPrVvPwwTWBwg", "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn", "ttgJtRGJQctTZtZT", "CrZsJsPPZsGzwwsLwLmpwMDw")

# Part 1 ---------------------------------------------------------------------

priority <- function(rucksack) {
	n <- nchar(rucksack)
	items <- unlist(strsplit(rucksack, ""))
	item <- intersect(head(items, n/2), 
										tail(items, n/2))
	match(item, c(letters, LETTERS))
}

sapply(input, priority) |> sum()


# Part 2 ---------------------------------------------------------------------

# Split input into groups of three
groups <- split(input, rep(1:(length(input)/3), each = 3))

# try on single group
group <- groups[[1]]
group_items <- strsplit(group, "") 
Reduce(intersect, group_items)

# function to find priority of common item in a group
priority_shared_item <- function(group) {
	group_items <- strsplit(group, "") 
	common_item <- Reduce(intersect, group_items)	
	match(common_item, c(letters, LETTERS))
}

sapply(groups, priority_shared_item) |> sum()
