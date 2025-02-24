library(aochelpers)
# input <- aoc_input_vector(4, 2024) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2024/day/4")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select,
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <-

initial_M <- matrix(LETTERS[1:25], 5, 5)
Zs <- matrix("Z", 5, 3)
Mz <- cbind(Zs, initial_M, Zs)
ZZs <- matrix("Z", 3, 11)
M <- rbind(ZZs, Mz, ZZs)

get_words <- function(M, i, j) {
  N <- M[i:(i-3), j]
  S <- M[i:(i+3), j]
  E <- M[i, j:(j+3)]
  W <- M[i, j:(j-3)]
  NE <- c(M[i,j], M[i-1, j+1], M[i-2, j+2], M[i-3, j+3])
  NW <- c(M[i,j], M[i-1, j-1], M[i-2, j-2], M[i-3, j-3])
  SE <- c(M[i,j], M[i+1, j+1], M[i+2, j+2], M[i+3, j+3])
  SW <- c(M[i,j], M[i+1, j-1], M[i+2, j-2], M[i+3, j-3])
  
  list(N=N, S=S, E=E, W=W, NE=NE, NW=NW, SE=SE, SW=SW)
}

i <- 6
j <- 6
  
get_words(M, i, j)

paste0(letters[1:4])

# Part 1 ---------------------------------------------------------------------

# Part 2 ---------------------------------------------------------------------
  