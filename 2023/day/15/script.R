library(aochelpers)
input <- aoc_input_vector(15, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/15")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

# Part 1 ---------------------------------------------------------------------

split_input <- strsplit(input, ",") |> unlist() 

hash <- function(start) {
	chars <- strsplit(start, "") |> unlist()
	chars
	
	# current value
	cv <- 0
	
	for (char in chars) {
		cv <- cv + utf8ToInt(char)
		cv <- cv * 17
		cv <- cv %% 256
	}
	cv
}

split_input |> 
	sapply(hash) |> 
	sum()

# Part 2 ---------------------------------------------------------------------
library(stringr)
# split into label and rest
str_split("rm=1", "=|-") # "rm", "1"
str_split("cm-", "=|-") # "cm", ""

# if =, will return a vector of length 2 with the label and focal length
# if -, will return a vector of length 2 with the label and empty string
# label_value() is a function in ggplot2
sep_label_value <- function(step) {
	step |> 
		str_split("=|-") |> 
		unlist() 
} 

sep_label_value("rn=1")
sep_label_value("cm-")

hash("rn") # 0
hash("cm") # 0
hash("qp") # 1
hash("pc") # 3
hash("ot") # 3
hash("ab") # 3

library(tidyverse)
list

boxes <- vector("list", 256)
for (i in seq_along(boxes)) {
	boxes[[i]] <- tibble(label = character(), value = character())
}
input <- aoc_input_vector(15, 2023)
split_input <- strsplit(input, ",") |> unlist() 

for (i in seq_along(split_input)) {
	# separate into label and value
	step <- sep_label_value(split_input[i])
	names(step) <- c("label", "value") # need this for binding rows
	lens_label <- step[1]
	# avoid off-by-one errors when indexing into list!
	box_index <- hash(lens_label) + 1 
	lens_value <- step[2]
	box <- boxes[[box_index]]
	
	# deal with "-" instructions
	if (lens_value == "") {
		# remove lens with given label
		boxes[[box_index]] <- box |> 
			filter(label != lens_label) 
	} else {
		# deal with "=" instructions
		# if lens with same label, replace with new value
		if (lens_label %in% box$label) {
			boxes[[box_index]]  <- box |> 
				mutate(value = if_else(label == lens_label, lens_value, value))	
		} else {
			boxes[[box_index]]  <- bind_rows(box, step) 
		}
	}
}
#boxes
for (i in seq_along(boxes)) {
	boxes[[i]] <- boxes[[i]] |> 
		mutate(box_index = i) |> 
		mutate(slot = row_number())
}
bind_rows(boxes) |> 
	mutate(power = as.numeric(value) * box_index * slot) |> 
	summarise(total_power = sum(power)) |> 
	pull(total_power)
