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

#while (is.null(get0("a")))
while (is.null(get0("a"))) {
	
	# evaluate instructions that can be evaluated
	can_evaluate_indices <- which(!grepl("[a-z]", operations)) 
	system.time(
		{
			to_eval <- instructions[can_evaluate_indices]
			eval(str2expression(to_eval))			
			to_eval <- instructions[can_evaluate_indices]
			eval(str2expression(to_eval))
		}
	)
	
	# replace assigned variables with their values
	evaluated_values <- operations[can_evaluate_indices]
	names(evaluated_values) <- paste0("\\b", wires[can_evaluate_indices], "\\b")
	operations <- stringr::str_replace_all(operations, evaluated_values)
	
	# remove already evaluated instructions
	#instructions <- instructions[-can_evaluate_indices]
	#operations <- operations[-can_evaluate_indices]
	#wires <- wires[-can_evaluate_indices]
}

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

# Emil's solution
library(magrittr)
library(stringr)

input <- aochelpers::aoc_input_vector(7, 2015)

int_2_16 <- function(x) {
	as.logical(intToBits(x)[1:16])
}

int_2_16_rev <- function(x) {
	sum(2 ^ (0:15) * x)
}

`%AND%` <- function(x, y) {
	int_2_16_rev(int_2_16(x) & int_2_16(y))
}

`%OR%` <- function(x, y) {
	int_2_16_rev(int_2_16(x) | int_2_16(y))
}

`%LSHIFT%` <- function(x, y) {
	int_2_16_rev(c(rep(FALSE, y), int_2_16(x)[seq(1, 16 - y)]))
}

`%RSHIFT%` <- function(x, y) {
	int_2_16_rev(c(int_2_16(x)[seq(y + 1, 16)], rep(FALSE, y)))
}

`%NOT%` <- function(temp, x) {
	int_2_16_rev(!int_2_16(x))
}

eval_fun <- function(x) {
	as.character(eval(parse(text = x)))
}

instructions <- strsplit(input, " -> ")

lhs <- purrr::map_chr(instructions, ~.x[1]) %>%
	str_replace_all(
		c(
			"OR" = "%OR%",
			"AND" = "%AND%",
			"RSHIFT" = "%RSHIFT%",
			"LSHIFT" = "%LSHIFT%",
			"NOT" = "1 %NOT%"
		)
	) %>%
	paste0("( ", ., " )")

lhs[which(str_detect(lhs, "^\\( [0-9]* \\)$"))] <- str_extract(
	lhs[which(str_detect(lhs, "^\\( [0-9]* \\)$"))],
	"[0-9]+"
)
lhs

rhs <- purrr::map_chr(instructions, ~.x[2])
iters <- 0
repeat {
	numbers_ind <- which(str_detect(lhs, "^[0-9]*$"))
	
	if (length(numbers_ind) == length(lhs)) break
	
	replacement <- str_extract(lhs[numbers_ind], "[0-9]+")
	names(replacement) <- paste0(" ", rhs[numbers_ind], " ")
	# after first round, this is a named vector, replacement = c(b = 19138, c = 0)
	
	lhs <- lhs %>%
		str_replace_all(replacement)
	
	can_evaluate <- !lhs %>% str_detect("[a-z]+")
	
	lhs[can_evaluate] <- purrr::map_chr(lhs[can_evaluate], eval_fun)
	iters <- iters + 1
}

# after first round, can_evaluate is 55  90  93 122 275 282 284

lhs[rhs == "a"]
# Part 2 ---------------------------------------------------------------------
