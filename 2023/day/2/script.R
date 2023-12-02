library(aochelpers)
input <- aoc_input_vector(2, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/2")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- c("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green", "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue", "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red", "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red", "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green")


# Part 1 ---------------------------------------------------------------------
library(stringr)
i1 <- input[1]
i3 <- input[3]
str_extract(i1, "\\d+")

str_extract("Game 10:", "\\d+")

extract_first_num <- function(x) {
	x |> 
		str_extract("\\d+") |> 
		as.numeric()
}

# get Game ID
extract_first_num(i1)

get_draws <- function(game) {
	game |> 
		str_split(":|;") |> 
		unlist() |> 
		tail(-1) #
}

i1_draws <- get_draws(i1)
i3_draws <- get_draws(i3)

i1_draws
i3_draws
i3d3 <- i3_draws[3]

i1d2 <- i1_draws[2]

colour_val <- function(draw, colour) {
	split_draw <- str_split(draw, ",") |> unlist()
	
	num <- split_draw[str_detect(split_draw, colour)] |> 
		extract_first_num() |> 
		as.numeric()
	
	ifelse((length(num) == 1), num, 0) 
	}

i1d2
	
colour_val(i1d2, "red")
colour_val(i1d2, "green")
colour_val(i1d2, "blue")

i3d3
colour_val(i3d3, "red")
colour_val(i3d3, "green")
colour_val(i3d3, "blue")

draw_possible <- function(draw) {
	if (colour_val(draw, "red") > 12 || colour_val(draw, "green") > 13 || colour_val(draw, "blue") > 14) {
		FALSE
	} else {
		TRUE
	}
}			

i1d2
draw_possible(i1d2)
draw_possible(i3d3)
draw_possible(i3_draws[1])

sapply(i3_draws, draw_possible)
sapply(i1_draws, draw_possible)

game_possible <- function(game) {
	game_ID <- extract_first_num(game)
	
	draws <- get_draws(game)
	
	all_possible <- draws |> 
		sapply(draw_possible) |> 
		all()
	
	ifelse(all_possible, game_ID, 0)
}

game_possible(i1)
game_possible(i3)

sapply(input, game_possible) |> sum()

# Part 2 ---------------------------------------------------------------------

# get all vals for each colour, and find min
colour_val(i3d3, "red")

fewest_of_colour <- function(draws, colour) {
	draws |> 
		sapply(colour_val, colour) |> 
		max()
}

fewest_of_colour(i1_draws, "green")

sapply(i1_draws, colour_val, "red") |> max()

power_cubes <- function(draws) {
	red <- fewest_of_colour(draws, "red")
	blue <- fewest_of_colour(draws, "blue")
	green <- fewest_of_colour(draws, "green")
	
	red * blue * green
}

power_cubes(i1_draws)
power_cubes(i3_draws)

input |> 
	sapply(get_draws) |> 
	sapply(power_cubes) |> 
	sum()

