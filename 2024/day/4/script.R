library(aochelpers)
# input <- aoc_input_vector(4, 2024) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2024/day/4")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select,
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# initial_M <- matrix(LETTERS[1:25], 5, 5)
# Zs <- matrix("Z", 5, 3)
# Mz <- cbind(Zs, initial_M, Zs)
# ZZs <- matrix("Z", 3, 11)
# M <- rbind(ZZs, Mz, ZZs)

# Part 1 ---------------------------------------------------------------------

input <- aochelpers::aoc_input_matrix(4, 2024)

count_xmas <- function(M, i, j) {
  N <- M[i:(i - 3), j]
  S <- M[i:(i + 3), j]
  E <- M[i, j:(j + 3)]
  W <- M[i, j:(j - 3)]
  NE <- c(M[i, j], M[i - 1, j + 1], M[i - 2, j + 2], M[i - 3, j + 3])
  NW <- c(M[i, j], M[i - 1, j - 1], M[i - 2, j - 2], M[i - 3, j - 3])
  SE <- c(M[i, j], M[i + 1, j + 1], M[i + 2, j + 2], M[i + 3, j + 3])
  SW <- c(M[i, j], M[i + 1, j - 1], M[i + 2, j - 2], M[i + 3, j - 3])

  words_list <- list(
    N = N,
    S = S,
    E = E,
    W = W,
    NE = NE,
    NW = NW,
    SE = SE,
    SW = SW
  )

  words <- sapply(words_list, paste0, collapse = "")
  sum(words == "XMAS")
}

# so we don't get indexing errors
pad_matrix <- function(M, n, pad = "o") {
  nr <- nrow(M)
  nc <- ncol(M)

  pad_c <- matrix(pad, nr, n)
  M_pad_c <- cbind(pad_c, M, pad_c)
  pad_r <- matrix(pad, n, nc + 2 * n)
  rbind(pad_r, M_pad_c, pad_r)
}

n <- 3
nr <- nrow(input)
nc <- ncol(input)
M <- pad_matrix(input, n)

# start accumulator
xmas <- 0

# iterate over M (with padding) and count "XMAS" whenever an "X" is found
for (i in (1:nc) + n) {
  for (j in (1:nr) + n) {
    if (M[i, j] == "X") {
      xmas <- xmas + count_xmas(M, i, j)
    }
  }
}

# see result
xmas

# Part 2 ---------------------------------------------------------------------
