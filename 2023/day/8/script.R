library(aochelpers)
library(tidyverse)
input <- aoc_input_vector(8, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/8")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

input <- c("LLR", "", "AAA = (BBB, BBB)", "BBB = (AAA, ZZZ)", "ZZZ = (ZZZ, ZZZ)")
input

instructions <- input[1] |> strsplit("") |> unlist()
n_inst <- length(instructions)

nodes <- tail(input, -2)
# network <- tibble(node = nodes) |> #
# 	separate_wider_position(node, c(node = 3, 4, L = 3, 2, R = 3, 1)) |>
# 	as.data.frame()

# Part 1 ---------------------------------------------------------------------

matches <- gregexpr(pattern = "\\w{3}", text = nodes)
list_rows <- regmatches(nodes, m = matches)
list_rows |> head()
network <- do.call(rbind, list_rows)# |> 
	#as.data.frame() |> 
#	I()
colnames(network) <- c("node", "L", "R")
rownames(network) <- network[,1]
network

loc <- "AAA"
steps <- 0

while (loc != "ZZZ") {
	ii <- (steps %% n_inst) + 1 ## instruction index
	i <- instructions[ii] ## instruction value, "L" or "R"
	#cat(paste(i, loc, "\n"))
	
	#loc <- network[network$node == loc, i]
	loc <- network[loc, i]
	steps <- steps + 1
}
steps



# Sample list
my_list <- list(Name = c("John", "Alice", "Bob"),
								Age = c(25, 30, 22),
								Score = c(90, 85, 95))

# Collapse the list into a data frame
my_data_frame <- do.call(data.frame, my_list)

# Print the resulting data frame
my_data_frame
lapply(my_list, I)


# Part 2 ---------------------------------------------------------------------

all_nodes <- network[,1]
all_nodes[grepl("..A", all_nodes)] # logical vector
start_nodes <- all_nodes[grep("..A", all_nodes)] # indices
end_nodes <- all_nodes[grep("..Z", all_nodes)]
end_nodes

# function for a single start
steps_from_start <- function(start_loc, instructions, network) {
	
	loc <- start_loc
	steps <- 0
	
	n_inst <- length(instructions)
	
	# needs just to end in Z
	while (!(loc %in% end_nodes)) {
		ii <- (steps %% n_inst) + 1 ## instruction index
		i <- instructions[ii] ## instruction value, "L" or "R"
		#cat(paste(i, loc, "\n"))
		
		#loc <- network[network$node == loc, i]
		loc <- network[loc, i]
		steps <- steps + 1
	}
	steps
}

steps_from_start("AAA", instructions, network)

all_steps <- sapply(start_nodes, \(x) steps_from_start(x, instructions, network))
pracma::Lcm(all_steps)
options(digits = 14)
Reduce(pracma::Lcm, all_steps)




#https://en.wikipedia.org/wiki/Euclidean_algorithm
gcd <- function(x, y) {
	while (y != 0) {
		t <- y
		y <- x %% y
		x <- t
		#cat(paste("t", t, "y", y, "x", x, "\n"))
	}
	x
}
gcd(6, 10)	

#https://stackoverflow.com/questions/3154454/what-is-the-most-efficient-way-to-calculate-the-least-common-multiple-of-two-int
lcm <- function(x, y) {
	x * y / gcd(x, y)
}
	

lcm(2,3)
	
Reduce(lcm, all_steps)

gcd(6, 10)
