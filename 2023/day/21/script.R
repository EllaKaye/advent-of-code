library(aochelpers)
# input <- aoc_input_vector(21, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/21")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

library(tidyverse)
library(tidygraph)
library(adventdrob)

input <- read_table(here::here("2023", "day", "21", "input"), col_names = "grid")
grid <- input |> 
	adventdrob::grid_tidy(grid) |> 
	mutate(node = row_number()) 
View(grid)

# Part 1 ---------------------------------------------------------------------

grid_adj <- adventdrob::adjacent_join(grid, grid)

grid_adj_connected <- grid_adj |> 
	mutate(is_connected = if_else(value %in% c(".", "S") & value2 == ".", TRUE, FALSE))
grid_adj_connected 

# get nodes, edges and convert into graph
grid_nodes <- grid |> 
	select(node)

grid_edges <- grid_adj_connected |> 
	filter(is_connected) |> 
	select(from = node, to = node2)

garden_graph <- tbl_graph(nodes = grid_nodes, edges = grid_edges, directed = FALSE) 

# root node
root_node <- grid |> 
	filter(value == "S") |> 
	pull(node)

garden_depth <- garden_graph |> 
	activate(nodes) |> 
	mutate(depth = bfs_dist(root = root_node)) |> 
	as_tibble() 

garden_depth |> 
	filter(depth == 1)

grid_adj |> 
	filter(value == "S")
# that looks right

garden_depth |> 
	filter(depth == 2)

grid |> 
	filter(node %in% c(39, 59, 71))
# also looks right, except for not going back to "S" at 6,6

garden_depth |> 
	filter(depth == 3)

grid |> 
	filter(node %in% c(40, 48, 70, 82))

garden_depth |> 
	filter(depth == 6) 
# gives 7, but the solution for 6 steps in 16
# but where can he backtrack to?

even_depth <- seq(2, 64, by = 2)

garden_depth |> 
	filter(depth %in% even_depth) |> 
	nrow() |> 
	sum(1)
# everywhere in even number of steps, 
# plus one more for the starting point

# Part 2 ---------------------------------------------------------------------

# maybe work through Jonathan Carroll's solution:
# https://github.com/jonocarroll/advent-of-code/blob/main/2023/R/R/day21.R

# Also, see https://simontoth.substack.com/p/daily-bite-of-c-advent-of-code-day-f73?r=1g4l8a&utm_campaign=post&utm_medium=web 
# for an explantion of the maths

grid |> 
	filter(row == 66) |> 
	View()

grid |> 
	filter(col == 66) |> 
	View()

