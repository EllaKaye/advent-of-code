library(aochelpers)
library(stringr)
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

extract_numbers <- function(x) {
	str_extract_all(x, "\\d+") |> 
		unlist() |> 
		as.numeric()
}

# Part 1 ---------------------------------------------------------------------
## Wrangle the data


split_input <- split(input, cumsum(input == "")) |> 
	lapply(\(x) x[x != ""])

seeds <- split_input[[1]] |> extract_numbers()

maps <- tail(split_input, -1) |> 
	lapply(\(x) tail(x, -1))

# want to get to a function that takes a seed and returns a location

# first we need to go from map to map,
# so a function that takes a source element and returns the destination element

map1 <- maps[[1]] 
map2 <- maps[[2]]
map1
seed1 <- seeds[1]
item1 <- map1[1]
item2 <- map1[2]
item2

# item is one line of the map
source_in_range <- function(source, item) {
	item <- extract_numbers(item)
	
	if (source >= item[2] && source <= item[2] + item[3] - 1) {
		return(TRUE)
	}
	else {
		return(FALSE)
	}
}

source_in_range(14, map2[1])

#purrr::map_lgl(map1, \(x) source_in_range(seed1, x))
vapply(map1, \(x) source_in_range(seed1, x), logical(1)) 
vapply(map2, \(x) source_in_range(14, x), logical(1)) 

# e.g. seed1 is 79
# it is in the range of item2, "52, 50, 48"
# the sources starts at 50 and the destinations start at 52, 
# so the destination is 79 - 52 + 50 = 77

source_to_destination <- function(source, map) {
	
	# check if source is in each range
	# logical vector of length(map)
	is_in_range <- purrr::map_lgl(map, \(x) source_in_range(source, x))
	which_range <- which(is_in_range)
	
	if (length(which_range) == 0) {
		return(source)
	}
	else {
		# get the item that contains the source
		item <- map[which_range] |> extract_numbers()
		destination <- source - item[2] + item[1]
		return(destination)
	}
}

source_to_destination(seed1, map1) 
sapply(seeds, \(x) source_to_destination(x, map1))

# now we need to start with a seed and go all the way to location, iterating over maps
seed_to_location <- function(seed, maps) {
	
	# start with the seed
	source <- seed
	
	# iterate over maps
	for (i in seq_along(maps)) {
		# get the destination
		destination <- source_to_destination(source, maps[[i]])
		# set the source to the destination
		source <- destination
		#cat(paste0("round ", i, ": source ", source, "\n"))
	}
	
	# return the final destination
	destination
}

seed_to_location(seeds[2], maps)

source_to_destination(seeds[2], maps[[2]])
seeds[2]

sapply(seeds, \(x) seed_to_location(x, maps)) |> min()

# Part 2:
seeds
get_all_seeds <- function(seeds) {
	
	n_seeds <- length(seeds)
	
	# odd indices given by seq(1, n_seeds, 2)
	starts <- seeds[seq(1, n_seeds, 2)]
	ranges <- seeds[seq(2, n_seeds, 2)]
	
	ranges
}

get_all_seeds(seeds)


