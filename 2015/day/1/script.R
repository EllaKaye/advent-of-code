library(aochelpers)
input <- aoc_input_vector(1, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/1")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

nchar(input)
input_tab <- input |> strsplit("") |> unlist() |> table()
input_tab['('] - input_tab[')']

# Part 1 ---------------------------------------------------------------------



# Part 2 ---------------------------------------------------------------------
