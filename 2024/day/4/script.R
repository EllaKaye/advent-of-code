library(aochelpers)
# input <- aoc_input_vector(4, 2024) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2024/day/4")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select,
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <-

M <- matrix(LETTERS[1:25], 5, 5)
Zs <- matrix("Z", 5, 3)
Mz <- cbind(Zs, M, Zs)
ZZs <- matrix("Z", 3, 11)
padded_M <- rbind(ZZs, Mz, ZZs)

get_words <- function(M, i, j) {
  N <- M[i:(i-3), j]
  S <- M[i:(i+3), j]
  E <- M[i, j:(j+3)]
  W <- M[i, j:(j-3)]
  NE <-
  NW <-
  SE <- M[i:(i+3), j:(j+3)]
  SW <-
  
}

i <- 6
j <- 6
  
padded_M[i:(i+3), j:(j+3)]

# Part 1 ---------------------------------------------------------------------

# Part 2 ---------------------------------------------------------------------
  