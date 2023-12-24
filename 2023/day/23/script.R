library(aochelpers)
input <- aoc_input_vector(23, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/23")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

library(tidyverse)
library(adventdrob)
library(tidygraph)
library(igraph)

input <- read_table(here::here("2023", "day", "23", "example-input"), col_names = "grid")
input

#input <- read_table(here::here("2023", "day", "23", "input"), col_names = "grid")


# Part 1 ---------------------------------------------------------------------

grid <- input |> 
	adventdrob::grid_tidy(grid) |> 
	mutate(name = row_number()) 

start_node <- grid |> 
	filter(row == 1 & value == ".") |> 
	pull(name)

end_node <- grid |> 
	filter(row == nrow(input) & value == ".") |> 
	pull(name)

grid_adj <- adventdrob::adjacent_join(grid, grid)

grid_adj_connected <- grid_adj |> 
	mutate(is_connected = case_when(
		value == "." & value2 == "." ~ TRUE,
		value == ">" & row2 == row & col2 == (col + 1) & value2 == "." ~ TRUE,
		value == "<" & row2 == row & col2 == (col - 1) & value2 == "." ~ TRUE,	
		value == "^" & row2 == (row - 1) & col2 == col & value2 == "." ~ TRUE,
		value == "v" & row2 == (row + 1) & col2 == col & value2 == "." ~ TRUE,
		value == "." & value2 == "v" & col2 == col & row2 == (row + 1) ~ TRUE,
		value == "." & value2 == "^" & col2 == col & row2 == (row - 1) ~ TRUE,
		value == "." & value2 == "<" & col2 == (col - 1) & row2 == row ~ TRUE,
		value == "." & value2 == ">" & col2 == (col + 1) & row2 == row ~ TRUE,
		.default = FALSE
	))

grid_adj_connected 

grid_nodes <- grid |> 
	select(name)

grid_edges <- grid_adj_connected |> 
	filter(is_connected) |> 
	select(from = name, to = name2) |> 
	as.matrix()

forest_graph <- graph_from_edgelist(grid_edges) 

# forest_graph <- tbl_graph(nodes = grid_nodes, edges = grid_edges) 
all_paths_lengths <- all_simple_paths(forest_graph, start_node, end_node) |> 
	lengths() 

# need to subtract one as paths include start node,
# whereas we want number of steps, not number of nodes in the path
max(all_paths_lengths - 1)

# Part 2 ---------------------------------------------------------------------

grid_no_slopes <- grid |> 
	mutate(value = if_else(value %in% c("<", ">", "^", "v"), ".", value)) 

grid_no_slopes_adj <- adventdrob::adjacent_join(grid_no_slopes, grid_no_slopes)

grid_no_slopes_adj_connected <- grid_no_slopes_adj |> 
	mutate(is_connected = if_else(value == "." & value2 == ".", TRUE, FALSE))

grid_no_slopes_edges <- grid_no_slopes_adj_connected |> 
	filter(is_connected) |> 
	select(from = name, to = name2)

forest_no_slopes_graph <- tbl_graph(nodes = grid_nodes, edges = grid_no_slopes_edges) 
all_paths_no_slopes_lengths <- all_simple_paths(forest_no_slopes_graph, start_node, end_node) |> 
	lengths() 

max(all_paths_no_slopes_lengths - 1)

## new approach, dfs
forest_no_slopes_graph |> 
	activate(nodes) |> 
	mutate(dist = dfs_dist(root = 2)) |> 
	as_tibble() |> 
	slice_max(dist)

# come back to this another year!
# need to learn more about data structures and algorithms!

# start thinking about base R versions of adventdrob functions
# Create a sample matrix
# nrow <- 3
# ncol <- 4
# mat <- matrix(1:(nrow*ncol), nrow, ncol)
# 
# expand.grid(x = 1:nrow, y = 1:ncol)
# 
# # Create a sample matrix
# mat <- matrix(1:9, nrow = 3, ncol = 3)
# 
# # Get row and column indices for each element
# indices <- which(TRUE, arr.ind = TRUE, useNames = FALSE)
# 
# # Create a data frame from the indices and values
# df <- data.frame(row = indices[, 1], col = indices[, 2], value = mat[indices])
# 
# # Print the resulting data frame
# print(df)
# 
# as.data.frame(mat, ncol = 2)
# 
