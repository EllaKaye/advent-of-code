library(aochelpers)
input <- aoc_input_vector(3, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/3")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

instructions <- input |> 
	strsplit("") |> 
	unlist() 

table(instructions) |> max()

# Part 1 ---------------------------------------------------------------------


# list implementation

#input <- c(">")

# visited <- vector("list", 3)
# current <- c(0, 0)
# num_visited <- 1
# visited[[num_visited]] <- current
# 
# visited
# (c(0, 0)) %in% visited # doesn't work

# to_check <- c(1, 0)
# any(sapply(visited, \(x) identical(x, to_check)))
# to_check <- c(0, 0)
# any(sapply(visited, \(x) identical(x, to_check)))
# 
# visited |> 
#   sapply(\(x) identical(x, to_check)) |> 
#   any()

# complex implementation
system.time(
	{
		visited <- rep(NA_complex_, length(instructions) + 1)
		current <- 0 + 0i
		num_visited <- 1
		visited[num_visited] <- current
		
		for (i in instructions) {
			switch(i,
						 "^" = current <- current + 1i,
						 "v" = current <- current - 1i,
						 ">" = current <- current + 1,
						 "<" = current <- current - 1,
						 print("Unexpected symbol"))
			
			# check if we've already visited current
			# increase count and add to list if not
			if (!(current %in% visited)) {
				num_visited <- num_visited + 1
				visited[num_visited] <- current
			}
		}
		
		# Answer should be num_visited
		num_visited		
	}
)

# time 0.343


## vectorised
library(aochelpers)
input <- aoc_input_vector(3, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

#input <- "^>v<"

instructions <- input |> 
	strsplit("") |> 
	unlist() 

system.time(
	{
		instructions[instructions == ">"] <- 1+0i
		instructions[instructions == "<"] <- -1+0i
		instructions[instructions == "^"] <- 0+1i
		instructions[instructions == "v"] <- 0-1i
		
		instructions <- as.complex(instructions)
		num_visited <- cumsum(c(0+0i, instructions)) |> unique() |> length()
		num_visited		
	}
)

# 0.002


# Part 2 ---------------------------------------------------------------------

houses_visited <- function(instructions) {
	
	visited <- rep(NA_complex_, length(instructions) + 1)
	current <- 0 + 0i
	num_visited <- 1
	visited[num_visited] <- current
	
	for (i in instructions) {
		switch(i,
					 "^" = current <- current + 1i,
					 "v" = current <- current - 1i,
					 ">" = current <- current + 1,
					 "<" = current <- current - 1,
					 print("Unexpected symbol"))
		
		# check if we've already visited current
		# increase count and add to list if not
		if (!(current %in% visited)) {
			num_visited <- num_visited + 1
			visited[num_visited] <- current
		}
	}
	visited[!is.na(visited)]
}

houses_visited(instructions)

santa_instructions <- instructions[(seq(1, length(instructions), by = 2))]
length(santa_instructions)
robo_santa_instructions <- instructions[(seq(2, length(instructions), by = 2))]
length(robo_santa_instructions)
santa_houses <- houses_visited(santa_instructions)
robo_santa_houses <- houses_visited(robo_santa_instructions)
#santa_houses
#robo_santa_houses
union(santa_houses, robo_santa_houses) |> length()

# vectorised
system.time(
	{
		santa_instructions <- instructions[(seq(1, length(instructions), by = 2))]
		robo_santa_instructions <- instructions[(seq(2, length(instructions), by = 2))]
		
		santa_houses <- cumsum(c(0+0i, santa_instructions)) 
		robo_santa_houses <- cumsum(c(0+0i, robo_santa_instructions)) 
		
		union(santa_houses, robo_santa_houses) |> unique() |> length()		
	}
)
