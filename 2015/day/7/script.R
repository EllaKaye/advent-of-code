library(aochelpers)
input <- aoc_input_vector(7, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/7")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

#input <- c("123 -> x", "456 -> y", "x AND y -> d", "x OR y -> e", "x LSHIFT 2 -> f", "y RSHIFT 2 -> g", "NOT x -> h", "NOT y -> i")
input

# Part 1 ---------------------------------------------------------------------

x <- 123 %% 2^16
y <- 456 %% 2^16
d <- bitwAnd(x, y) %% 2^16
e <- bitwOr(x, y) %% 2^16
f <- bitwShiftL(x, 2) %% 2^16
g <- bitwShiftR(y, 2) %% 2^16
h <- bitwNot(x) %% 2^16
i <- bitwNot(y) %% 2^16

d # 72
e # 507
f # 492
g # 114
h # 65412
i # 65079
x # 123
y # 456

# library(stringr)
# Will need to think careful about order of instructions
# how to store and process them
# get first inputs, i.e. of form NUM -> VAR
input[str_detect(input, "^\\d+ -> [a-z]+$")]
input[grepl("^\\d+ -> [a-z]+$", input)]

# assign LHS to RHS
# after this, d exists in the global environment and has value 0
line <- "12 -> d"
linesplit <- strsplit(line, " -> ") |> unlist()
assign(linesplit[2], as.numeric(linesplit[1]))
assign("e", bitwShiftL(d, 1))
# assign("f", bitwShiftL("d", 1))

# Original string
variable_name <- "f"
value <- 3
expression_string <- paste0(variable_name, " <- ", value)
eval(parse(text = expression_string))
# Now 'f' holds the value of 3

# N.B. can list all objects in global environment with ls()
# Can also use ls() with `name` to specify an environment
grepl("^d$", ls()) # d is in environment

# or maybe put in a dataframe with all lines separated with " -> " into cols for LHS and RHS?
# maybe some kind of data structure for instructions dealt with an instructions still to be dealt with?

# borrowing some aspects of the approach from Emil Hvitfeldt
# https://emilhvitfeldt.github.io/rstats-adventofcode/2015.html?panelset=day-7

# an approach to wrangling input lines into evaluated expressions
# here "d LSHIFT 1 -> g" results in g <- bitwShifL(d, 1)
`%AND%` <- function(a, b) {
	bitwAnd(a, b) %% 2^16
}

`%OR%` <- function(a, b) {
	bitwOr(a, b) %% 2^16
}

`%NOT%` <- function(tmp, a) {
	bitwNot(a) %% 2^16
}

`%RSHIFT%` <- function(a, n) {
	bitwShiftR(a, n) %% 2^16
}

`%LSHIFT%` <- function(a, n) {
	bitwShiftL(a, n) %% 2^16
}
# will need to replace occurences of NOT with 1 %NOT% to get tmp on other side

instructions <- input |> 
	gsub("AND", "%AND%", x = _) |> 
	gsub("OR", "%OR%", x = _) |> 
	gsub("NOT", "X %NOT%", x = _) |> 
	gsub("RSHIFT", "%RSHIFT%", x = _) |> 
	gsub("LSHIFT", "%LSHIFT%", x = _) 

# instructions[55] = "19138 -> b"
# instructions[90] = ""0 -> c"
eval(parse(text = instructions[55])) # this works to assign b <- 19138
eval(str2expression(instructions[90])) # also works, probably better (https://stackoverflow.com/questions/1743698/evaluate-expression-given-as-a-string))
c # 0
# vec <- c(3, 5) # having c in the global environment doesn't seem to mess with the c function.
# vec 

split_instructions <- instructions |> strsplit(" -> ")
operations <- sapply(split_instructions, "[", 1)
operations
wires <- sapply(split_instructions, "[", 2)
wires
which(wires == "a") # 79
# we can evalute
instructions[79]
operations[79]
wires[79]
operations[c(55, 90)]

operations <- instructions |> strsplit(" -> ") |> sapply("[", 1)

# get indicies of operations that can be evaluated
can_evaluate_indices <- which(!grepl("[a-z]", operations)) 
to_eval <- instructions[can_evaluate_indices]
eval(str2expression(to_eval))
get0("b")

pat <- paste0("\\b", wires[55], "\\b")
patterns <- paste0("\\b", wires[can_evaluate_indices], "\\b")

operations[grepl(pat, operations)]

operations <- gsub(paste0("\\b", wires[55], "\\b"), operations[55], operations)
operations <- gsub(paste0("\\b", wires[90], "\\b"), operations[90], operations)
which(!grepl("[a-z]", operations)) 

for (i in can_evaluate_indices) {
	print(i)
}

# START HERE
`%AND%` <- function(a, b) {
	bitwAnd(a, b) %% 2^16
}

`%OR%` <- function(a, b) {
	bitwOr(a, b) %% 2^16
}

`%NOT%` <- function(tmp, a) {
	bitwNot(a) %% 2^16
}

`%RSHIFT%` <- function(a, n) {
	bitwShiftR(a, n) %% 2^16
}

`%LSHIFT%` <- function(a, n) {
	bitwShiftL(a, n) %% 2^16
}

# FINAL SOLUTION
system.time(
	{
input <- aochelpers::aoc_input_vector(7, 2015) # uncomment at end, once correct on test input

# could use named vector to str_replace_all here too
instructions <- input |> 
	gsub("AND", "%AND%", x = _) |> 
	gsub("OR", "%OR%", x = _) |> 
	gsub("NOT", "X %NOT%", x = _) |> 
	gsub("RSHIFT", "%RSHIFT%", x = _) |> 
	gsub("LSHIFT", "%LSHIFT%", x = _) 

split_instructions <- instructions |> strsplit(" -> ")
operations <- sapply(split_instructions, "[", 1)
wires <- sapply(split_instructions, "[", 2)

		`%AND%` <- function(a, b) {
			bitwAnd(a, b) %% 2^16
		}
		
		`%OR%` <- function(a, b) {
			bitwOr(a, b) %% 2^16
		}
		
		`%NOT%` <- function(tmp, a) {
			bitwNot(a) %% 2^16
		}
		
		`%RSHIFT%` <- function(a, n) {
			bitwShiftR(a, n) %% 2^16
		}
		
		`%LSHIFT%` <- function(a, n) {
			bitwShiftL(a, n) %% 2^16
		}
		
		
repeat {
	
	# find wires that have already been assigned, i.e. operations are numbers
	assigned_indices <- which(str_detect(operations, "^\\d+$"))
	assigned_values <- operations[assigned_indices]
	assigned_wires <- wires[assigned_indices]
	names(assigned_values) <- paste0("\\b", assigned_wires, "\\b")
	
	# break if we've assigned "a"
	if ("a" %in% assigned_wires) {
		print(as.numeric(assigned_values["\\ba\\b"])) # 16076
		break
	}
	
	# replace other occurrences of assigned wires with their values
	# neat trick with passing a named vector to str_replace_all
	operations <- stringr::str_replace_all(operations, assigned_values)
	
	# remove already evaluated instructions
	operations <- operations[-assigned_indices]
	wires <- wires[-assigned_indices]
	
	# find operations that can now be evaluated
	can_evaluate_indices <- which(!grepl("[a-z]", operations)) 
	
	# evaluate those operations and replace with the new values
	operations[can_evaluate_indices] <- operations[can_evaluate_indices] |> 
		sapply(str2expression) |> 
		sapply(eval) |> 
		as.character()
}
		
	}
)
# testing 

12 %LSHIFT% 1

test <- "d LSHIFT 1 -> g"
test_split <- strsplit(test, " -> ") |> unlist()
instruction <- test_split[1]
instruction_fun <- sub("LSHIFT", "%LSHIFT%", instruction)
instruction
var <- test_split[2]
expression_string <- paste0(var, " <- ", instruction_fun)
eval(parse(text = expression_string))
# d was 12, g is now 24, as it should be!

wrangle_line <- function(line) {
	linesplit <- strsplit(line, " -> ") |> unlist() 
	paste0(linesplit[2], " <- ", linesplit[1])
}

wrangled_instructions <- instructions |> 
	sapply(wrangle_line) |> 
	unname()

wrangled_instructions


split_instructions <- instructions |> strsplit(" -> ")
operations <- sapply(split_instructions, "[", 1)
operations
wires <- sapply(split_instructions, "[", 2)
wires

instructions
wrangled_instructions
split_instructions 
operations
wires

# Part 2 ---------------------------------------------------------------------

system.time(
	{
		input <- aochelpers::aoc_input_vector(7, 2015) # uncomment at end, once correct on test input
		
		instructions <- input |> 
			gsub("AND", "%AND%", x = _) |> 
			gsub("OR", "%OR%", x = _) |> 
			gsub("NOT", "X %NOT%", x = _) |> 
			gsub("RSHIFT", "%RSHIFT%", x = _) |> 
			gsub("LSHIFT", "%LSHIFT%", x = _) 
		
		split_instructions <- instructions |> strsplit(" -> ")
		operations <- sapply(split_instructions, "[", 1)
		wires <- sapply(split_instructions, "[", 2)
		
		which(wires == "b")
		operations[which(wires == "b")] <- "16076" 
		
		`%AND%` <- function(a, b) {
			bitwAnd(a, b) %% 2^16
		}
		
		`%OR%` <- function(a, b) {
			bitwOr(a, b) %% 2^16
		}
		
		`%NOT%` <- function(tmp, a) {
			bitwNot(a) %% 2^16
		}
		
		`%RSHIFT%` <- function(a, n) {
			bitwShiftR(a, n) %% 2^16
		}
		
		`%LSHIFT%` <- function(a, n) {
			bitwShiftL(a, n) %% 2^16
		}
		
		repeat {
			
			# find wires that have already been assigned, i.e. operations are numbers
			assigned_indices <- which(str_detect(operations, "^\\d+$"))
			assigned_values <- operations[assigned_indices]
			assigned_wires <- wires[assigned_indices]
			names(assigned_values) <- paste0("\\b", assigned_wires, "\\b")
			
			# break if we've assigned "a"
			if ("a" %in% assigned_wires) {
				print(as.numeric(assigned_values["\\ba\\b"])) 
				break
			}
			
			# replace other occurrences of assigned wires with their values
			# neat trick with passing a named vector to str_replace_all
			operations <- stringr::str_replace_all(operations, assigned_values)
			
			# remove already evaluated instructions
			operations <- operations[-assigned_indices]
			wires <- wires[-assigned_indices]
			
			# find operations that can now be evaluated
			can_evaluate_indices <- which(!grepl("[a-z]", operations)) 
			
			# evaluate those operations and replace with the new values
			operations[can_evaluate_indices] <- operations[can_evaluate_indices] |> 
				sapply(str2expression) |> 
				sapply(eval) |> 
				as.character()
		}
		
	}
)

