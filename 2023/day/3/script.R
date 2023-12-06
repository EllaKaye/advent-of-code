library(aochelpers)
input <- aoc_input_data_frame(3, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

input <- input |> 
	rename(x = X1)

browseURL("https://adventofcode.com/2023/day/3")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)

library(tidyverse)
library(adventdrob)
# input is an example engine schematic:
input <- tibble::tribble(
						~x,
            "467..114..",
            "...*......",
            "..35..633.",
            "......#...",
            "617*......",
            ".....+.58.",
            "..592.....",
            "......755.",
            "...$.*....",
            ".664.598..",
           )

# In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is 4361.

# Part 1 ---------------------------------------------------------------------

g <- input |> 
	adventdrob::grid_tidy(x) |> 
	mutate(is_digit = str_detect(value, "\\d")) |>
	group_by(row) |> 
	mutate(number_id = paste0(row, ".", consecutive_id(is_digit))) |>
	group_by(number_id) |> 
	mutate(part_number = as.numeric(paste(value, collapse = ""))) |> 
	ungroup() 

nrow(input)

input |> 
	adventdrob::grid_tidy(x) |> 
	nrow()


g |> 
	filter(row == 4)

g |> 
	filter(!is.na(part_number)) |> 
	adventdrob::adjacent_join(g, diagonal = TRUE) |> 
	arrange(row, col) |> 
	#filter(part_number == 633) |> 
	filter(value2 != ".", !is_digit2) |> 
	distinct(number_id, .keep_all = TRUE) |> 
	summarise(sum_part_numbers = sum(part_number)) |> 
	pull(sum_part_numbers)
	

# Part 2 ---------------------------------------------------------------------

g |> 
	filter(value == "*") |> 
	adventdrob::adjacent_join(g, diagonal = TRUE) |> 
	arrange(row, col) |> 
	filter(!is.na(part_number2)) |>
	distinct(row, col, number_id2, .keep_all = TRUE) |>
	#group_by(row, col) |> 
	group_by(row, col) |> # equiv by number_id
	summarise(n_adjacent_numbers = n(),
						gear_ratio = prod(part_number2),
						.groups = "drop") |> 
	filter(n_adjacent_numbers == 2) |>
	summarise(sum_gear_ratios = sum(gear_ratio)) |> 
	pull(sum_gear_ratios)
