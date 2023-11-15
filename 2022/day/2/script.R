library(aochelpers)
input <- aoc_input_vector(2, 2022) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2022/day/2")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <- c("A Y", "B X", "C Z")

# A, X: rock, score 1
# B, Y: paper, score 2
# C, Z: scissors, score 3

# X defeats C, Z defeats B, and Y defeats A. 

# draw: "A X", "B Y", "C Z"
# win: "A Y", "B Z", "C X"
# lose: "A Z", "B X", "C Y"

# The score for a single round is the score for the shape you selected (1 for
# Rock, 2 for Paper, and 3 for Scissors) plus the score for the outcome of the
# round (0 if you lost, 3 if the round was a draw, and 6 if you won).The score
# for a single round is the score for the shape you selected (1 for Rock, 2 for
# Paper, and 3 for Scissors) plus the score for the outcome of the round (0 if
# you lost, 3 if the round was a draw, and 6 if you won).

input

round <- "A X"



# Part 1 ---------------------------------------------------------------------

my_score <- function(round) {
	
	draw <- c("A X", "B Y", "C Z")
	win <- c("A Y", "B Z", "C X")
	lose <- c("A Z", "B X", "C Y")
	
	my_shape <- strsplit(round, " ")[[1]][2]
	shape_score <- switch(my_shape, "X" = 1, "Y" = 2, "Z" = 3)
	
	if (round %in% draw) outcome_score <- 3
	else if (round %in% win) outcome_score <- 6
	else outcome_score <- 0
	
	shape_score + outcome_score
}

sapply(input, my_score) |> sum()

# Part 2 ---------------------------------------------------------------------


# A, rock, score 1
# B, paper, score 2
# C, scissors, score 3

# X means lose
# Y means draw
# Z means win

# A X: rock, lose: pick scissors
# A Y: rock, draw: pick rock
# A Z: rock, win: pick paper
# B X: paper, lose: pick rock
# B Y: paper, draw: pick paper
# B Z: paper, win: pick scissors
# C X: scissors, lose: pick paper
# C Y: scissors, draw: pick scissors
# C Z: scissors, win: pick rock

my_new_score <- function(round) {
	
	pick_scissors <- c("A X", "B Z", "C Y")
	pick_rock <- c("A Y", "B X", "C Z")
	pick_paper <- c("A Z", "B Y", "C X")
	
	outcome <- strsplit(round, " ")[[1]][2]
	outcome_score <- switch(outcome, "X" = 0, "Y" = 3, "Z" = 6)
	
	if (round %in% pick_rock) shape_score <- 1
	else if (round %in% pick_paper) shape_score <- 2
	else shape_score <- 3
	
	shape_score + outcome_score
}

sapply(input, my_new_score) |> sum()

