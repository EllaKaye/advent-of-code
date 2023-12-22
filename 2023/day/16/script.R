library(aochelpers)
# input <- aoc_input_vector(16, 2023) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2023/day/16")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <- 

# Part 1 ---------------------------------------------------------------------

# Work through Jonathan Carroll's solution:
# https://github.com/jonocarroll/advent-of-code/blob/main/2023/R/R/day16.R

# The top time for the first star for day 16 was just over 2 minutes (:exploding_head:) -- 
# I took more than an hour to get to a working solution, 
# mainly due to my verbose approach and handling the different requirements. 
# I've refactored it down to use complex numbers (which makes pos + dir really nice) 
# and using utils::hashtab to keep track of which tiles have already been visited 
# in which direction (vs my original rbind  every iteration). 
# It runs part 1 on my full input in just over 1s, 
# which is manageable for Part 2 which only needed some iteration over what I already had.


# Part 2 ---------------------------------------------------------------------
