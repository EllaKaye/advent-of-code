library(aochelpers)
input <- aoc_input_vector(5, 2022) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2022/day/5")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

#input <- c("[D]", "[N] [C]", "[Z] [M] [P]", "1   2   3", NA, "move 1 from 2 to 1", "move 3 from 1 to 3", "move 2 from 2 to 1", "move 1 from 1 to 2")


# Part 1 ---------------------------------------------------------------------

#head(input, 10)

blank <- which(input == "") # this works for main input
#blank <- which(is.na(input)) # this works for test input

stack_numbers_index <- blank - 1
stack_numbers <- input[stack_numbers_index]
stacks <- input[1:(stack_numbers_index-1)]
instructions <- input[(blank+1):length(input)]
stacks_matrix <- matrix(unlist(strsplit(stacks, split = "")), 
												nrow = length(stacks),
												byrow = TRUE)


digits_split <- stack_numbers |> strsplit("") |> unlist() |> as.numeric() 
stack_columns <- which(!is.na(digits_split))

stacks_matrix <- matrix(unlist(strsplit(stacks, split = "")), 
												nrow = length(stacks),
												byrow = TRUE)
stacks_matrix_letters <- stacks_matrix[,stack_columns]
stacks_matrix_letters

stacks_list <- apply(stacks_matrix_letters, 2, function(x) rev(x[x != " "])) 

# Now let's deal with the instructions
first_instruction <- instructions |> head(1) 
words <- strsplit(first_instruction, " ") |> unlist()
ints <- as.integer(words)
ints[!is.na(ints)] 

get_values <- function(instruction) {
	words <- strsplit(instruction, " ") |> unlist()
	ints <- as.integer(words)
	ints[!is.na(ints)] 
}

instruction_values <- lapply(instructions, get_values)

# first value: number of stacks to move
# second value: from stack
# third value: to stack

stacks_list

for (i in seq_along(instruction_values)) {
	
	inst <- instruction_values[[i]]
	
	transfer <- stacks_list[[inst[2]]] |> 
		tail(inst[1]) |> # take inst[1] values
		rev() # reverse the order
	
	stacks_list[[inst[2]]] <-	stacks_list[[inst[2]]] |> 
		head(-inst[1]) # remove inst[1] values
	
	stacks_list[[inst[3]]] <- c(stacks_list[[inst[3]]], transfer)
}

stacks_list |> sapply(tail, 1) |> paste(collapse = "")

# test
stacks_list <- list(c("Z", "N"), c("M", "C", "D"), c("P"))

instructions <- c("move 1 from 2 to 1", "move 3 from 1 to 3", "move 2 from 2 to 1", "move 1 from 1 to 2")
instruction_values <- lapply(instructions, get_values)

for (i in seq_along(instruction_values)) {
	transfer <- stacks_list[[inst[2]]] |> 
		tail(inst[1]) |> # take inst[1] values
		rev() # reverse the order
	
	stacks_list[[inst[2]]] <-	stacks_list[[inst[2]]] |> 
		head(-inst[1]) # remove inst[1] values
	
	stacks_list[[inst[3]]] <- c(stacks_list[[inst[3]]], transfer)
}

# Part 2 ---------------------------------------------------------------------
