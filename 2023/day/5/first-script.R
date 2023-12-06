library(aochelpers)
input <- aoc_input_vector(5, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/5")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input
path <- here::here("2023", "day", "5", "example-input")
input <- readr::read_lines(path)
input

# Part 1 ---------------------------------------------------------------------


# wrangle the data
split_input <- split(input, cumsum(input == "")) |> 
	lapply(\(x) x[x != ""])

seeds <- split_input[[1]]

maps <- tail(split_input, -1)

#map_names <- sapply(maps, \(x) x[1])
#maps <- sapply(maps, \(x) tail(x, -1))
#setNames(maps, map_names)

# function to create a tibble from a map
library(tidyverse)

extract_numbers <- function(x) {
	str_extract_all(x, "\\d+") |> 
		unlist() |> 
		as.numeric()
}

maps[[1]][1] |> 
	extract_numbers()

# write a function that takes a vector, x, of length 3 and returns a tibble
# let n be the value of the 3rd element of x
# the tibble has n rows
# with a first column called "source" which is vector x[2]:(x[2]+n-1)
# and a second column called "destination" which is vector x[1]:(x[1]+n-1)

make_map <- function(x) {
	n <- x[3]
	tibble(
		source = x[2]:(x[2]+n-1),
		destination = x[1]:(x[1]+n-1)
	)
}

maps[[1]][1] |> 
	extract_numbers() |> 
	make_map()

# lapply(maps[[1]], extract_numbers) |> 
# 	lapply(make_map) |> 
# 	bind_rows() |> 
# 	arrange(source) |> 
# 	View()

map_names[1] |> str_split("-|\\s") |> unlist()

map_col_names <- function(map_name) {
	name_split <- map_name |> 
		str_split("-|\\s") |> 
		unlist() 
	
	name_split[c(1,3)]
} 

names_vec <- lapply(map_names, map_col_names) |> unlist() |> unique()

map_col_names(map_names[1])

map1 <- maps[[1]]

make_map_df <- function(map, vec = NULL) {
	
	#col_names <- map_col_names(map[1])
	
	map <- map |> 
		tail(-1) |> 
		lapply(extract_numbers) |>
		lapply(make_map) |>
		bind_rows() 
	

	if (!is.null(vec)) {
		
		min_source <- min(map$source)
		min_vec <- min(vec)
		
		if (min_vec < min_source) {
			extra_vec <- min_vec:(min_source-1)
			extra_rows <- tibble(source = extra_vec, destination = extra_vec) 
			map <- bind_rows(extra_rows, map)
		}
	}
	
	map |> 
		arrange(source)
	
	#do.call(rbind, map) 
	
	#colnames(map) <- col_names
}

map_df1 <- make_map_df(maps[[1]], seeds_vec) 
map_df2 <- make_map_df(maps[[2]])

build_map_table <-  function(map_table, map) {
	full_join(map_table, map, join_by(destination == source)) |> 
		mutate(destination.y = if_else(is.na(destination.y), destination, destination.y)) |> 
		select(-destination) |> 
		rename(destination = destination.y)
}

build_map_table(map_df1, map_df2) |> View()

#build_map_table(map_df1, map_df2) |> View()
map_table <- make_map_df(maps[[1]], seeds_vec) 
for (i in 2:length(maps)) {
	map_df <- make_map_df(maps[[i]])
	map_table <- build_map_table(map_table, map_df)
}
map_table |> filter(source %in% seeds_vec) |> 
	summarise(min_location = min(destination)) |>
	pull(min_location)


make_map_df(maps[[2]]) |> View()

seeds <- seeds |> extract_numbers() 

map_df <- make_map_df(maps[[1]])
vec <- seeds

expand_map_df <- function(map_df, vec) {
	vec_min <- min(vec)
	vec_max <- max(vec)
	
	df_min <- min(map_df[,1, drop = TRUE])
	df_max <- max(map_df[,1, drop = TRUE])
}

make_map_df(maps[[1]]) |> View()

all_maps <- lapply(maps, make_map_df)

# build up the data frame:


View(map_table)





# Part 2 ---------------------------------------------------------------------
