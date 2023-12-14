library(aochelpers)
library(tidyverse)
library(tidygraph)
library(adventdrob)
input <- aoc_input_data_frame(10, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/10")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

#input <- read_table(here::here("2023", "day", "10", "example2"), col_names = FALSE) 
colnames(input) <- "grid"
input

grid <- input |> 
	adventdrob::grid_tidy(grid) |> 
	mutate(id = row_number()) 

grid_adj <- adventdrob::adjacent_join(grid, grid)

# save start, come back to this later
S <- grid_adj |> 
	filter(value == "S")
# example1, id = 7
# example2, id = 11

# in full example, S is (17, 38)
#  J
# F?-
#  F

# can't go S to F
# can go N to J
# can go W to F
# can go E to -

# S could be "J" to connect west and north
# S could be "-" to connect east and west
# S could be "L" to connect east and north
 
open_S <- c("|", "F", "7") # pipes that go north from value
open_N <- c("|", "L", "J") # pipes that go south from value
open_W <- c("-", "J", "7") # pipes that go east from value
open_E <- c("-", "L", "F") # pipes that go west from value

grid_adj_connected <- grid_adj |> 
#	mutate(value = if_else(value == "S", "F", value)) |> # example1, also example2
#	mutate(value = if_else(value == "S", "J", value)) |> # possibility 1
#	mutate(value = if_else(value == "S", "-", value)) |> # possibility 2
#	mutate(value = if_else(value == "S", "L", value)) |> # possibility 3
	mutate(is_connected = case_when(
		# build up slowly
#		value == "|" & col2 == col & row2 < row & value2 %in% open_S ~ TRUE, # go N of "|"
#		value == "L" & col2 == col & row2 < row & value2 %in% open_S  ~ TRUE, # go N of "L"
#		value == "J" & col2 == col & row2 < row & value2 %in% open_S  ~ TRUE, # go N of "J"
#		value %in% c("|", "L", "J") & col2 == col & row2 < row & value2 %in% open_S  ~ TRUE, # go N
		value %in% open_N & col2 == col & row2 < row & value2 %in% open_S  ~ TRUE, # go N
				
#		value == "7" & col2 == col & row2 > row & value2 %in% open_N ~ TRUE, # go S of "7"
#		value == "|" & col2 == col & row2 > row & value2 %in% open_N ~ TRUE, # go S of "|"
#		value == "F" & col2 == col & row2 > row & value2 %in% open_N ~ TRUE, # go S of "F"	
		value %in% open_S & col2 == col & row2 > row & value2 %in% open_N ~ TRUE, # go S of "F"	
		
#		value == "-" & col2 > col & row2 == row & value2 %in% open_W ~ TRUE, # go E of "-"
#		value == "F" & col2 > col & row2 == row & value2 %in% open_W ~ TRUE, # go E of "F"
#		value == "L" & col2 > col & row2 == row & value2 %in% open_W  ~ TRUE, # go E of "L"	
		value %in% open_E & col2 > col & row2 == row & value2 %in% open_W  ~ TRUE, # go E of "L"		
		
#		value == "-" & col2 < col & row2 == row & value2 %in% open_E ~ TRUE, # go W of "-"
#		value == "J" & col2 < col & row2 == row & value2 %in% open_E ~ TRUE, # go W of "J"
#		value == "7" & col2 < col & row2 == row & value2 %in% open_E ~ TRUE, # go W of "7"
		value %in% open_W & col2 < col & row2 == row & value2 %in% open_E ~ TRUE, # go W of "7"
		.default = FALSE
	)) |> 
	# filter(value == "L") looks OK. May need to double check more later
	I()

table_for_graph <- grid_adj_connected |> 
	select(id, id2, is_connected)

table_for_graph |> tbl_graph()

grid_nodes <- grid |> 
	select(name = id)

grid_edges <- table_for_graph |> 
	filter(is_connected) |> 
	select(from = id, to = id2)

pipe_graph <- tbl_graph(nodes = grid_nodes, edges = grid_edges) 

str(pipe_graph)

longest_loop <- pipe_graph |> 
	activate(nodes) |> 
	mutate(group = group_components()) |> 
	as_tibble() |> 
	count(group) |> 
	slice_max(n) |> 
	pull(n)

#longest_loop/2 # if S = J
#longest_loop/2 # if S = -
#longest_loop/2 # if S = L
# 6831 same for all

(longest_loop + 1)/2

# Part 1 ---------------------------------------------------------------------



# Part 2 ---------------------------------------------------------------------
# Consider a solution using the Shoelace Formula and Pick's formula
# "https://en.wikipedia.org/wiki/Shoelace_formula"
# "https://en.wikipedia.org/wiki/Pick%27s_theorem"
