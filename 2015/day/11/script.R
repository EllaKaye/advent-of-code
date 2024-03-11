library(aochelpers)
input <- aoc_input_vector(11, 2015) # uncomment at end, once correct on test input
# also consider aoc_input_data_frame() or aoc_input_matrix(), with view = TRUE

browseURL("https://adventofcode.com/2015/day/11")
# use datapasta addin to copy in test input from the website
# triple-click in test input box in the puzzle to select, 
# then choose appropriate paste format from addin
# comment out once ready to run on full input

# input <- 

# Part 1 ---------------------------------------------------------------------
password <- input

password <- "byz"

next_letter <- function(let) {
	if (let == "z") return("a")
	pos <- match(let, letters)
	new_pos <- pos + 1 + (let %in% c("h", "k", "n"))
	letters[new_pos]
}

str_sub(password, -1, -1) <- next_letter(str_sub(password, -1, -1))
password

next_password <- function(password) {
	# increment last letter
	str_sub(password, -1, -1) <- next_letter(str_sub(password, -1, -1))
	
	if (str_sub(password, -1, -1) != "a") {
		return(password)
	}
	
	# if last letter is now "a" (i.e. was "z" before the increment), we also have
	# to increment the penultimate letter, then if that is now "a" , we also have to
	# increment the letter before that and so on working leftwards along the string
	# until we come to a letter that isn't then "a"
	
	for (i in nchar(password):2) {
		if (str_sub(password, i, i) == "a") {
			str_sub(password, i - 1, i - 1) <- next_letter(str_sub(password, i - 1, i - 1))
		}
		else {
			return(password)
		}
	}
	
	password
}

next_password(input)

next_password("azz")
next_password("zaz")
# debugging
next_password("haa") # jab !wrong! should be hab
next_password("aaa") # bab !wrong! should be aab

library(stringr)
# regex for a string of consecutive letters
# N.B. base R substr is not vectorised
letter_str <- letters |> paste(collapse = "")
straight_pattern <- str_sub(letter_str, 1:24, 3:26) |> paste(collapse = "|")
str_detect("abasd", straight_pattern)
str_detect("xbcdy", straight_pattern)

# regex for pairs
# want this >= 2
str_extract_all("aaedd", "(.)\\1") |> unlist() |> unique() |> length()

is_valid <- function(password) {
	n_pairs <- str_extract_all(password, "(.)\\1") |> 
		unlist() |> 
		unique() |> 
		length()
	
	has_straight <- str_detect(password, straight_pattern)
	
	has_straight && (n_pairs >= 2)
}

is_valid("abcdefgh")
is_valid("abcdffaa")
is_valid("vzbxxyzz")

file_path <- here::here("2015", "day", "11", "output.txt")
con <- file(file_path, open = "a")

password <- input

while (!is_valid(password)) {
	password <- next_password(password)
	writeLines(password, con)
}

close(con)

password <- "vzbxkgzz"
next_password(password)


password <- input

while (!is_valid(password)) {
	password <- next_password(password)
}
password

solution <- "vzbxxyzz"

# Part 2 ---------------------------------------------------------------------
password <- next_password("vzbxxyzz")

while (!is_valid(password)) {
	password <- next_password(password)
}
password
